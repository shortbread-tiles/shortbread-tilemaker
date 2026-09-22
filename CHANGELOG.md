# Changelog of the Tilemaker implementation of the Shortbread vector tile schema

## 1.0.1 (2026-09-22)

This version implements Shortbread schema version 1.0 and contains lots of bug fixes on top of implementation version 1.0.0.

* Fix spelling of `convenience` and `optician` (@yetzt, [#15](https://github.com/shortbread-tiles/shortbread-tilemaker/pull/15)).
* Fix maxzoom of layer `streets_low` ([b9ce012](https://github.com/shortbread-tiles/shortbread-tilemaker/commit/b9ce012a575fa214eb23bae9af2f6fac3beca8ce)).
* Add missing layers `street_polygons`, `streets_polygons_labels`, `ferries` and `pois` to tilestats.json file ([c922c7f](https://github.com/shortbread-tiles/shortbread-tilemaker/commit/c922c7fd6030c4d41d560de7b4f10fccf01178cd)).
* Upgrade to Lua API of Tilemaker 3.0 ([#26](https://github.com/shortbread-tiles/shortbread-tilemaker/pull/26)).
* Export `waterway=riverbank` and `water=river` both as `kind=river` ([#25](https://github.com/shortbread-tiles/shortbread-tilemaker/pull/25)).
* Updated URL of admin-points (@amandasaurus, [#27](https://github.com/shortbread-tiles/shortbread-tilemaker/pull/27)).
* get-shapefiles doesn't print warning on first run (@amandasaurus, [#28](https://github.com/shortbread-tiles/shortbread-tilemaker/pull/28)).
* Move `artwork` from `historic=*` to `tourism` (@joto, [fb78906](https://github.com/shortbread-tiles/shortbread-tilemaker/commit/fb789064f307c6f0ddab84e8891748def080393b)).
* Create `boundary_labels` layer from OSM data directly, not from shape file because Tilemaker >= 3.0 uses the pole of inaccessibility instead of the centroid to label a multipolygon. Previously, we used the shape file `admin_points.shp` created from a PostgreSQL database in the past. The new approach requires Tilemaker 3.0 or newer (@astridx, [#37](https://github.com/shortbread-tiles/shortbread-tilemaker/pull/37)).
* Fix typo in bridge handling condition, correct office value check in `process_pois` function. (@MichaelKreil, [#46](https://github.com/shortbread-tiles/shortbread-tilemaker/pull/46)).
* Use new Tilemaker function `Attribute(name, value, minzoom)` and therefore remove the layers `streets_low` and `streets_med` (@Nakaner, [#54](https://github.com/shortbread-tiles/shortbread-tilemaker/pull/54)).
* Remove buggy surface mapping not permitted by specification. Specification instructs that values of `surface=*` are written to the vector tiles without any modification (@Nakaner, [#55](https://github.com/shortbread-tiles/shortbread-tilemaker/pull/55)).



## 1.0.0 (2023-03-28)

* initial release
