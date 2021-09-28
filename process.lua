-- Data processing for Geofabrik Vector Tiles schema
-- Copyright (c) 2021, Geofabrik GmBH
-- All rights reserved.

-- Enter/exit Tilemaker
function init_function()
end
function exit_function()
end

-- Process node tags

node_keys = { "place", "highway", "railway", "aeroway", "aerialway", "addr:housenumber", "addr:housename" }

inf_zoom = 99

function fillWithFallback(value1, value2, value3)
	if value1 ~= "" then
		return value1
	end
	if value2 ~= "" then
		return value2
	end
	return value3
end

-- Ensure that
function ensureSortableNumberInRange(number)
	local limit = 2 ^ 32 - 1
	if number >= limit then
		return limit
	elseif number < 0 then
		return 0
	end
	return number
end

-- Set name, name_en, and name_de on any object
function setNameAttributes(obj)
	local name = obj:Find("name")
	local name_de = obj:Find("name:de")
	local name_en = obj:Find("name:en")
	obj:Attribute("name", fillWithFallback(name, name_en, name_de))
	obj:Attribute("name_de", fillWithFallback(name_de, name, name_en))
	obj:Attribute("name_en", fillWithFallback(name_en, name, name_de))
end

-- Set z_order
function setZOrder(way, is_rail)
	local highway = way:Find("highway")
	local railway = way:Find("highway")
	local layer = tonumber(way:Find("layer"))
	local bridge = way:Find("bridge")
	local tunnel = way:Find("tunnel")
	local zOrder = 0
	local Z_STEP = 14
	if bridge ~= "" and bridge ~= "no" then
		zOrder = zOrder + Z_STEP
	elseif tunnel ~= "" and tunnel ~= "no" then
		zOrder = zOrder - Z_STEP
	end
	if not (layer == nil) then
		if layer > 7 then
			layer = 7
		elseif layer < -7 then
			layer = -7
		end
		zOrder = zOrder + layer * Z_STEP
	end
	local hwClass = 0
	if not is_rail and railway == "rail" and not way:Holds("service") then
		hwClass = 13
	elseif not is_rail and railway == "rail" then
		hwClass = 12
	elseif not is_rail and (israilway == "subway" or railway == "light_rail" or railway == "tram" or railway == "funicular" or railway == "monorail") then
		hwClass = 11
	elseif highway == "motorway" then
		hwClass = 10
	elseif highway == "trunk"  then
		hwClass = 9
	elseif highway == "primary"  then
		hwClass = 8
	elseif highway == "secondary"  then
		hwClass = 7
	elseif highway == "tertiary"  then
		hwClass = 6
	elseif highway == "unclassified" or highway == "residential" or highway == "road" or highway == "motorway_link" or highway == "trunk_link" or highway == "primary_link" or highway == "secondary_link" or highway == "tertiary_link" then
		hwClass = 5
	elseif highway == "living_street" or highway == "pedestrian" then
		hwClass = 4
	elseif highway == "service" then
		hwClass = 3
	elseif highway == "foootway" or highway == "bridleway" or highway == "cycleway" or highway == "path" or highway == "track" then
		hwClass = 2
	elseif highway == "steps" or highway == "platform" then
		hwClass = 1
	end
	zOrder = zOrder + hwClass
	way:ZOrder(zOrder)
end

function process_place_layer(node)
	local place = node:Find("place")
	local mz = 99
	local kind = place
	if place == "city" then
		mz = 6
	elseif place == "town" then
		mz = 7
	elseif place == "village" or place == "hamlet" or place == "suburb" or place == "neighbourhood" or place == "locality" or place == "isolated_dwelling" or place == "farm" or place == "island" then
		mz = 10
	end
	if (place == "city" or place == "town" or place == "village" or place == "hamlet") and node:Holds("capital") then
		local capital = node:Find("capital")
		if capital == "yes" then
			mz = 4
			kind = "capital"
		elseif capital == "4" then
			mz = 4
			kind = "state_capital"
		end
	end
	if mz < 99 then
		node:Layer("place_labels", false)
		node:MinZoom(mz)
		node:Attribute("kind", kind)
		setNameAttributes(node)
		local population = node:Find("population")
		local populationNum = tonumber(population)
		if populationNum ~= nil then
			node:AttributeNumeric("population", populationNum)
		        node:SortableNumber(ensureSortableNumberInRange(populationNum))
		end
	end
end

function process_public_transport_layer(obj, is_area)
	local railway = obj:Find("railway")
	local aeroway = obj:Find("aeroway")
	local aerialway = obj:Find("aerialway")
	local kind = ""
	local mz = inf_zoom
	if railway == "station" or railway == "halt" then
		kind = railway
		mz = 13
	elseif railway == "tram_stop" then
		kind = railway
		mz = 14
	elseif aerialway == "station" then
		kind = "aerialway_station"
		mz = 13
	else
		kind = obj:Find("aeroway")
		mz = 11
	end
	if is_area then
		obj:LayerAsCentroid("public_transport")
	else
		obj:Layer("public_transport", false)
	end
	obj:MinZoom(11)
	obj:Attribute("kind", kind)
	setNameAttributes(obj)
end
	

function node_function(node)
	-- Layer place_labels
	if node:Holds("place") and node:Holds("name") then
		process_place_layer(node)
	end
	-- Layer street_labels_points
	local highway = node:Find("highway")
	if highway == "motorway_junction" then
		node:Layer("street_labels_points", false)
		node:MinZoom(12)
		node:Attribute("kind", highway)
		setNameAttributes(node)
		node:Attribute("ref", node:Find("ref"))
	end
	-- Layer public_transport 
	local railway = node:Find("railway")
	local aeroway = node:Find("aeroway")
	local aerialway = node:Find("aerialway")
	if railway == "station" or railway == "halt" or aeroway == "aerodrome" or aerialway == "station" then
		process_public_transport_layer(node, false)
	end

	-- Layer addresses
	local housenumber = node:Find("addr:housenumber")
	local housename = node:Find("addr:housename")
	if housenumber ~= "" or housename ~= "" then
		process_addresses(node, false)
	end
end

function zmin_for_area(way, min_square_pixels)
	-- Return minimum zoom level where the area of the way/multipolygon is larger than
	-- the provided threshold.
	local way_area = way:Area()
	local circumfence = 40052725.78
	local zmin = (math.log((min_square_pixels * circumfence^2) / (2^16 * way_area))) / (2 * math.log(2))
	return math.floor(zmin)
end

function zmin_for_length(way, min_length_pixels)
	-- Return minimum zoom level where the length of a line is larger than
	-- the provided threshold.
	local length = way:Length()
	local circumfence = 40052725.78
	local zmin = (math.log((circumfence * min_length_pixels) / (2^8 * length))) / math.log(2)
	return math.floor(zmin)
end

function process_water_polygons(way)
	local waterway = way:Find("waterway")
	local natural = way:Find("natural")
	local landuse = way:Find("landuse")
	local mz = inf_zoom
	local kind = ""
	if landuse == "reservoir" or landuse == "basin" or natural == "water" or natural == "glacier" then
		mz = math.max(4, zmin_for_area(way, 0.01))
		if mz >= 10 then
			mz = math.max(10, zmin_for_area(way, 0.1))
		end
		if landuse == "reservoir" or landuse == "basin" then
			kind = landuse
		elseif natural == "water" or natural == "glacier" then
			kind = natural
		end
	elseif waterway == "riverbank" or waterway == "dock" or waterway == "canal" then
		mz = math.max(4, zmin_for_area(way, 0.1))
		kind = waterway
	end
	if mz < inf_zoom then
		way:Layer("water_polygons", true)
		way:MinZoom(mz)
		way:Attribute("kind", kind)
		if way:Holds("name") then
			way:LayerAsCentroid("water_polygons_labels")
			way:MinZoom(14)
			way:Attribute("kind", kind)
			setNameAttributes(way)
		end
	end
end

function process_water_lines(way)
	local kind = way:Find("waterway")
	local mz = inf_zoom
	local mz_label = inf_zoom
	-- skip if area > 0 (it's no line then)
	local area = way:Area()
	if area > 0 and way:Find("area") ~= no then
		return
	end
	mz = inf_zoom
	if kind == "river" or kind == "canal" then
		mz = math.max(9, zmin_for_length(way, 0.25))
		mz_label = math.max(13, zmin_for_length(way, 0.25))
	elseif kind == "canal" then
		mz = 12
		mz_label = 14
	elseif kind == "ditch" or kind == "stream" then
		mz = 14
		mz_label = 14
	end
	if mz < inf_zoom then
		way:Layer("water_lines", false)
		way:MinZoom(mz)
		way:Attribute("kind", kind)
		if way:Holds("name") then
			way:Layer("water_lines_labels", false)
			way:MinZoom(mz_label)
			way:Attribute("kind", kind)
			setNameAttributes(way)
		end
	end
end

function process_land(way)
	local landuse = way:Find("landuse")
	local natural = way:Find("natural")
	local wetland = way:Find("wetland")
	local leisure = way:Find("leisure")
	local kind = ""
	local mz = inf_zoom
	if landuse == "forest" or natural == "wood" then
		kind = "forest"
		mz = 7
	elseif landuse == "residential" or landuse == "industrial" or landuse == "commercial" or landuse == "retail" or landuse == "railway" or landuse == "landfill" or landuse == "brownfield" or landuse == "greenfield" or landuse == "farmyard" or landuse == "farmland" then
		kind = landuse
		mz = 10
	elseif landuse == "grass" or landuse == "meadow" or landuse == "orchard" or landuse == "vineyard" or landuse == "allotments" or landuse == "village_green" or landuse == "recreation_ground" or landuse == "greenhouse_horticulture" or landuse == "plant_nursery" or landuse == "quarry" then
		kind = landuse
		mz = 11
	elseif natural == "sand" or natural == "beach" then
		kind = natural
		mz = 10
	elseif natural == "wood" or natural == "heath" or natural == "scrub" or natural == "grassland" or natural == "bare_rock" or natural == "scree" or natural == "shingle" or natural == "sand" or natural == "beach" then
		kind = natural
		mz = 11
	elseif wetland == "swamp" or wetland == "bog" or wetland == "string_bog" or wetland == "wet_meadow" or wetland == "marsh" then
		kind = wetland
		mz = 11
	elseif way:Find("amenity") == "grave_yard" then
		kind = "grave_yard"
		mz = 13
	elseif leisure == "golf_course" or leisure == "park" or leisure == "garden" or leisure == "playground" or leisure == "miniature_golf" then
		kind = leisure
		mz = 11
	elseif way:Find("man_made") == "pier" then
		kind = "pier"
		mz = 11
	elseif landuse == "cemetery" then
		kind = "cemetery"
		mz = 13
	end
	if mz < inf_zoom then
		way:Layer("land", true)
		way:MinZoom(mz)
		way:Attribute("kind", kind)
	end
end

function process_sites(way)
	local kind = ""
	local amenity = way:Find("amenity")
	local military = way:Find("military")
	local leisure = way:Find("leisure")
	local landuse = way:Find("landuse")
	local mz = inf_zoom
	if amenity == "university" or amenity == "hospital" or amenity == "prison" or amenity == "parking" or amenity == "bicycle_parking" then
		kind = amenity
		mz = 14
	elseif leisure == "sports_center" then
		kind = leisure
		mz = 14
	elseif landuse == "construction" then
		kind = landuse
		mz = 14
	elseif military == "danger_area" then
		kind = military
		mz = 14
	end
	if mz < inf_zoom then
		way:Layer("sites", true)
		way:MinZoom(mz)
		way:Attribute("kind", kind)
	end
end

function process_boundary_labels(way)
	if not way:Find("type") == "boundary" then
		return
	end
	if not way:Holds("name") then
		return
	end
	local area = way:Area()
	if area == 0 then
		return
	end
	local mz = inf_zoom
	local admin_level = tonumber(way:Find("admin_level"))
	if admin_level == nil then
		return
	end
	if admin_level == 2 and area >= 2 * 10^12 then
		mz = 2
	elseif (admin_level == 2 or admin_level == 4) and area >= 7 * 10^11 then
		mz = 3
	elseif (admin_level == 2 or admin_level == 4) and area >= 1 * 10^11 then
		mz = 4
	elseif admin_level == 2 or admin_level == 4 then
		mz = 5
	end
	if mz < inf_zoom then
		way:LayerAsCentroid("boundary_labels")
		way:MinZoom(mz)
		setNameAttributes(way)
		way:Attribute("admin_level", admin_level)
		-- way_area is in ha, not m² due to 32-bit limit
		way:AttributeNumeric("way_area", area / 10000)
		way:SortableNumber(ensureSortableNumberInRange(area / 10000))
	end
end

function process_boundary_lines(way)
	if way:Holds("type") then
		return
	end
	local mz = inf_zoom
	local mzLabel = inf_zoom
	local admin_level = tonumber(way:Find("admin_level"))
	if admin_level == nil then
		return
	end
	if admin_level == 2 then
		mz = 0
	elseif admin_level == 4 then
		mz = 7
	end
	if mz < inf_zoom then
		way:Layer("boundaries", false)
		way:MinZoom(mz)
		way:Attribute("admin_level", admin_level)
	end
end

function process_streets(way)
	local min_zoom_layer = 5
	local mz = inf_zoom
	local kind = ""
	local highway = way:Find("highway")
	local railway = way:Find("railway")
	local aeroway = way:Find("aeroway")
	local surface = way:Find("surface")
	local tunnel = way:Find("tunnel")
	local bicycle = way:Find("bicycle")
	local horse = way:Find("horse")
	local tracktype = way:Find("tracktype")
	local tunnelBool = false
	local covered = way:Find("covered")
	local bridge = way:Find("bridge")
	local bridgeBool = false
	local name = way:Find("name")
	local rail = false
	if name == "" then
		name = way:Find("ref")
	end
	if highway ~= "" then
		if highway == "motorway" or highway == "motorway_link" then
			mz = min_zoom_layer
			kind = "motorway"
		elseif highway == "trunk" or highway == "trunk_link" then
			mz = 6
			kind = "trunk"
		elseif highway == "primary" or highway == "primary_link" then
			mz = 8
			kind = "primary"
		elseif highway == "secondary" or highway == "secondary_link" then
			mz = 9
			kind = "secondary"
		elseif highway == "tertiary" or highway == "tertiary_link" then
			mz = 10
			kind = "tertiary"
		elseif highway == "unclassified" or highway == "residential" then
			mz = 12
			kind = highway
		elseif highway == "living_street" or highway == "pedestrian" or highway == "track" then
			mz = 13
			kind = highway
		elseif highway == "service" then
			mz = 14
			kind = highway
		elseif highway == "footway" or highway == "steps" or highway == "path" or highway == "cycleway" then
			mz = 13
			kind = highway
		end
	elseif (railway == "rail" or railway == "narrow_gauge") and not way:Holds("service") then
		kind = railway
		rail = true
		mz = 8
	elseif ((railway == "rail" or railway == "narrow_gauge") and way:Holds("service"))
		or railway == "light_rail" or railway == "tram" or railway == "subway"
		or railway == "funicular" or railway == "monorail" then
		kind = railway
		rail = true
		mz = 10
	elseif aeroway == "runway" then
		kind = aeroway
		mz = 11
	elseif aeroway == "taxiway" then
		kind = aeroway
		mz = 13
	end
	if kind ~= "" and (surface ~= "" or tunnel ~= "" or bridge ~= "") then
		if surface == "unpaved" or surface == "compacted" or surface == "dirt" or surface == "earth" or surface == "fine_gravel" or surface == "grass" or surface == "grass_paver" or surface == "gravel" or surface == "ground" or surface == "mud" or surface == "pebblestone" or surface == "salt" or surface == "woodchips" or surface == "clay" then
			suface = "unpaved"
		elseif surface == "paved" or surface == "asphalt" or surface == "cobblestone" or surface == "cobblestone:flattended" or surface == "sett" or surface == "concrete" or surface == "concrete:lanes" or surface == "concrete:plates" or surface == "paving_stones" then
			suface = "unpaved"
		else
			surface = ""
		end
		if tunnel == "yes" or tunnel == "building_passage" or covered == "yes" then
			tunnelBool = true
		else
			tunnelBool = false
		end
		if bridge == "yes" then
			bridgeBool = true
		else
			bridgeBool = false
		end
	end
	local link = (highway == "motorway_link" or highway == "trunk_link" or highway == "primary_link" or highway == "secondary_link" or highway == "tertiary_link")
	local layer = tonumber(way:Find("layer"))
	if layer == nil then
		layer = 0
	end
	if mz <= 13 then
		way:Layer("streets_med", false)
		way:MinZoom(mz)
		way:Attribute("kind", kind)
		way:AttributeBoolean("link", link)
		way:Attribute("surface", surface)
		way:AttributeBoolean("tunnel", tunnelBool)
		way:AttributeBoolean("bridge", bridgeBool)
		setNameAttributes(way)
		way:Attribute("tracktype", way:Find("tracktype"))
		way:AttributeBoolean("rail", rail)
		way:Attribute("service", way:Find("service"))
		setZOrder(way, rail)
	end
	if mz < inf_zoom then
		way:Layer("streets", false)
		way:MinZoom(mz)
		way:Attribute("kind", kind)
		way:AttributeBoolean("link", link)
		way:Attribute("surface", surface)
		way:Attribute("bicycle", bicycle)
		way:Attribute("horse", horse)
		way:AttributeBoolean("tunnel", tunnelBool)
		way:AttributeBoolean("bridge", bridgeBool)
		setNameAttributes(way)
		way:Attribute("tracktype", way:Find("tracktype"))
		way:AttributeBoolean("rail", rail)
		way:Attribute("service", way:Find("service"))
		setZOrder(way, rail)
	end
	if mz < 9 then
		way:Layer("streets_low", false)
		way:MinZoom(mz)
		way:Attribute("kind", kind)
		setNameAttributes(way)
		way:AttributeBoolean("rail", rail)
		setZOrder(way, rail)
	end
end

function process_street_labels(way)
	local highway = way:Find("highway")
	local ref = way:Find("ref")
	local mz = inf_zoom
	if highway == "motorway" then
		mz = 11
	elseif highway == "trunk" or highway == "primary" then
		mz = 12
	elseif highway == "secondary" or highway == "tertiary" then
		mz = 13
	end
	if ref ~= "" and mz < inf_zoom then
		way:Layer("street_labels", false)
		way:MinZoom(mz)
		way:Attribute("kind", highway)
		way:Attribute("ref", ref)
	end
end

function process_aerialways(way)
	local aerialway = way:Find("aerialway")
	if aerialway == "cable_car" or aerialway == "gondola" or aerialway == "chair_lift" or aerialway == "drag_lift" or aerialway == "t-bar" or aerialway == "j-bar" or aerialway == "platter" or aerialway == "rope_tow" then
		way:Layer("aerialways", false)
		way:MinZoom(12)
		way:Attribute("kind", aerialway)
	end
end

function process_buildings(way)
	local building = way:Find("building")
	if building ~= "no" then
		way:Layer("buildings", true)
		way:MinZoom(14)
		way:AttributeNumeric("dummy", 1)
	end
end

function process_addresses(way, is_area)
	if is_area then
		way:LayerAsCentroid("addresses")
	else
		way:Layer("addresses", false)
	end
	way:MinZoom(14)
	way:Attribute("name", way:Find("addr:housename"))
	way:Attribute("number", way:Find("addr:housenumber"))
end

function way_function(way)
	-- Layers water_polygons, water_polygons_labels
	if way:Holds("waterway") or way:Holds("natural") or way:Holds("landuse") then
		process_water_polygons(way)
	end
	-- Layers water_lines, water_lines_labels
	if way:Holds("waterway") then
		process_water_lines(way)
	end

	-- Layer land
	if way:Holds("landuse") or way:Holds("natural") or way:Holds("wetland") or way:Find("amenity") == "grave_yard" or way:Holds("leisure") or way:Find("man_made") == "pier" then
		process_land(way)
	end

	-- Layer sites
	if way:Holds("amenity") or way:Holds("leisure") or way:Holds("military") or way:Holds("landuse") then
		process_sites(way)
	end

	-- Layer boundaries
	if way:Find("boundary") == "administrative" then
		process_boundary_lines(way)
		process_boundary_labels(way)
	end

	-- Layer streets, street_labels
	if way:Holds("highway")  or way:Holds("railway") or way:Holds("aeroway") then
		process_streets(way)
		process_street_labels(way)
	end
	
	-- Layer aerialways
	if way:Holds("aerialway") then
		process_aerialways(way)
	end

	-- Layer public_transport 
	local railway = way:Find("railway")
	local aeroway = way:Find("aeroway")
	if railway == "station" or railway == "halt" or aeroway == "aerodrome" then
		process_public_transport_layer(way, true)
	end

	-- Layer buildings
	if way:Holds("building") then
		process_buildings(way)
	end

	-- Layer addresses
	local housenumber = way:Find("addr:housenumber")
	local housename = way:Find("addr:housename")
	if (housenumber ~= "" or housename ~= "") then
		process_addresses(way, true)
	end
end
