# Geofabrik Basic Vector Tiles - Tilemaker Configuration

## Installation

* Install [tilemaker](https://tilemaker.org/) as normal.
* Install the Geofabrik [Admin Boundary Simplification](https://github.com/geofabrik/admin-polygon-simplify) tool.
* Run `./get-shapefiles.sh` once to download external shapefiles.

## Generating tiles

* Preprocess OSM Data to improve admin border ways:

	  osm_admin_level_rels2ways path/to/originaldata.osm.pbf processeddata.osm.pbf

* Generate Vector Tiles:

	  tilemaker --input processeddata.osm.pbf --output output.mbtiles

[Documentation on tile schema](https://github.com/geofabrik/geofabrik-basicvt-docs)

## Dependencies

For administrative boundaries, this tile generation mechanism currently depends
on individual OSM ways being tagged with minimum `admin_level` of all
`boundary=administrative` relations they are a member of. This is in order to
be able to render boundaries based on ways not polygons, to avoid
simplification artefacts along land boundaries.  There is a separate piece of
software that will pre-process a planet file and add these tags where they are
missing, as well as pre-simplifying them ([Admin Boundary
Simplification](https://github.com/geofabrik/admin-polygon-simplify)).
Medium-term it is expected that this functionality will be part of tilemaker
(potentially following in the footsteps of [this proposed tilemaker feature
change](https://github.com/systemed/tilemaker/pull/292)), and hence
pre-processing will not be required any more.

## See also

* [Tilemaker](https://tilemaker.org/)
* [Tilemaker source code](https://github.com/systemed/tilemaker)
* [Geofabrik Basic Vector Tile documentation](https://github.com/geofabrik/geofabrik-basicvt-docs)
* [Admin Boundary Simplification](https://github.com/geofabrik/admin-polygon-simplify)

## Authors

This set of configuration files has been created for Geofabrik by Michael Reichert 
and Amanda McCann before it was put on Github. Further contributors may be visible 
in the git history.

## License and Copyright

Because this set of configuration files is intended to go with the tilemaker software,
it is released under the same license as tilemaker itself, the [FTWPL license](./LICENCE.txt).

