# Changelog of the Tilemaker implementation of the Shortbread vector tile schema

## 1.1.0 (2026-11-24)

This version implements Shortbread schema version 1.1. The bug fixes which do not change the schema are also included in version version 1.0.2 (see below).

* Correct minimum zoom level of `water_lines_labels` in config.json (@Nakaner, [4147262](https://github.com/shortbread-tiles/shortbread-tilemaker/commit/414726247dddd969fda61d844c3af191d6ffd142))
* Use Visvalingam algorithm for simplification of some polygon layers. (@Nakaner, [203a92d](https://github.com/shortbread-tiles/shortbread-tilemaker/commit/203a92d9a7fd396ed09c18974e9d6ae975e1d2d4))
* Remove `highway=road/platform` from Z-level calculation code (@Nakaner, [d1bafac](https://github.com/shortbread-tiles/shortbread-tilemaker/commit/d1bafac78056cc7e40f3f83b84a4496227f62508), issue [#23](https://github.com/shortbread-tiles/shortbread-tilemaker/issues/23))
* Correct minimum zoom level for `highway=service` (@Nakaner, [72b5144](https://github.com/shortbread-tiles/shortbread-tilemaker/commit/72b514491ebad9d06067a4dcade528aa85a4b15b), issue [#22](https://github.com/shortbread-tiles/shortbread-tilemaker/issues/22))
* Improve script `add_geometry_type.py`:
  * Allow to update metadata instead of writing it to stdout (@Nakaner, [5b0bc69](https://github.com/shortbread-tiles/shortbread-tilemaker/commit/5b0bc69a66ad103fd63387edd707fda0bf00d672))
  * add support for MBTiles as input, remove deprecated argparse.FileType (@Nakaner, [aa53afc](https://github.com/shortbread-tiles/shortbread-tilemaker/commit/aa53afc2a26779d7c3bcb7dae2e731cf75d1c722))
* Create label for `place=island` from areas (@oberhamsi, [#44](https://github.com/shortbread-tiles/shortbread-tilemaker/pull/44))
* Handle exceptions thrown by Centroid() (@Nakaner, [2bc3b0f](https://github.com/shortbread-tiles/shortbread-tilemaker/commit/2bc3b0f00f823afc1489d4208f40271541a79e68))
* Fix wrong minzoom for water polygons and their labels (@Nakaner, [7d87098](https://github.com/shortbread-tiles/shortbread-tilemaker/commit/7d870982a268971da975980035296743c301c22c), issue [#50](https://github.com/shortbread-tiles/shortbread-tilemaker/issues/50))
* Add language support according to Shortbread 1.1 specification (@Nakaner, [9ec0098](https://github.com/shortbread-tiles/shortbread-tilemaker/commit/9ec009826b49b71bb1481a1c28c3681766c600e3))
* Add extended access tag support as required by Shortbread 1.1 (@Nakaner, [b82523f](https://github.com/shortbread-tiles/shortbread-tilemaker/commit/b82523f32a40c16a1e67de7c28206e6fa4d279bc))
* Add new POI categories required by Shortbread version 1.1 (@Nakaner, [db24828](https://github.com/shortbread-tiles/shortbread-tilemaker/commit/db24828da62e7e8fb42c6b3d37c801de7434cbb5))

## 1.0.2 (2026-11-24)

This version implements Shortbread schema version 1.0 and contains lots of bug fixes on top of implementation version 1.0.1.

* Correct minimum zoom level of `water_lines_labels` in config.json (@oberhamsi, [b3a38d2](https://github.com/shortbread-tiles/shortbread-tilemaker/commit/b3a38d2ece6046c0185980f9791684fb493f4ad6), [#45](https://github.com/shortbread-tiles/shortbread-tilemaker/pull/45))
* Use Visvalingam algorithm for simplification of some polygon layers. (@Nakaner, [d5b67f3](https://github.com/shortbread-tiles/shortbread-tilemaker/commit/d5b67f36eecbb408b7c033b512d3f6af665dcd63))
* Remove `highway=road/platform` from Z-level calculation code (@Nakaner, [347b48a](https://github.com/shortbread-tiles/shortbread-tilemaker/commit/347b48ab16bb6a2da6b9829006e1e528ba7b5a06), issue [#23](https://github.com/shortbread-tiles/shortbread-tilemaker/issues/23))
* Correct minimum zoom level for `highway=service` (@Nakaner, [a3e5189](https://github.com/shortbread-tiles/shortbread-tilemaker/commit/a3e5189ce70d035a9de45debcb27568373ee894a), issue [#22](https://github.com/shortbread-tiles/shortbread-tilemaker/issues/22))
* Improve script `add_geometry_type.py`:
  * Allow to update metadata instead of writing it to stdout (@Nakaner, [68fa605](https://github.com/shortbread-tiles/shortbread-tilemaker/commit/68fa60571569f3dbb46922709ad568d9312d5127))
  * add support for MBTiles as input, remove deprecated argparse.FileType (@Nakaner, [ca22c9b](https://github.com/shortbread-tiles/shortbread-tilemaker/commit/ca22c9b5c65cacca74b6401876dc98c447336864))
* Create label for `place=island` from areas (@oberhamsi, [#44](https://github.com/shortbread-tiles/shortbread-tilemaker/pull/44))
* Handle exceptions thrown by Centroid() (@Nakaner, [1ae5c48](https://github.com/shortbread-tiles/shortbread-tilemaker/commit/1ae5c48949374a85bc17922a50db7273cb6bed25))
* Fix wrong minzoom for water polygons and their labels (@Nakaner, [59abaaf](https://github.com/shortbread-tiles/shortbread-tilemaker/commit/59abaaf57fbb090a24c8f3513aa7cefed86271a5), issue [#50](https://github.com/shortbread-tiles/shortbread-tilemaker/issues/50))


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
