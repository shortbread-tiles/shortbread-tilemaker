# Geofabrik Basic Vector Tiles - Tilemaker Configuration

## Installation

Install tilemaker as normal.

Run `./get-shapefiles.sh` once to download external shapefiles.

## Generating tiles

	tilemaker --input path/to/data.osm.pbf --output output.mbtiles

## Dependencies

For administrative boundaries, this tile generation mechanism currently depends
on individual OSM ways being tagged with minimum admin_level of all boundary=administrative
relations they are a member of. This is in order to be able to render boundaries
based on ways not polygons, to avoid simplification artefacts along land boundaries. 
There is a separate piece of software that will pre-process a planet file and add these
tags where they are missing, as well as pre-simplifying them (see link below). Medium-term it is expected 
that this functionality will be part of tilemaker (potentially following in the footsteps 
of https://github.com/systemed/tilemaker/pull/292), and hence pre-processing will not be required any more.

## See also

* [Tilemaker](https://github.com/systemed/tilemaker)
* [Geofabrik Basic Vector Tile documentation](https://github.com/geofabrik/geofabrik-basicvt-docs)
* [Admin Boundary Simplification](https://github.com/geofabrik/admin-polygon-simplify)

## Authors

This set of configuration files has been created for Geofabrik by Michael Reichert 
and Amanda McCann before it was put on Github. Further contributors may be visible 
in the git history.

## License and Copyright

Because this set of configuration files is intended to go with the tilemaker software,
it is released under the same license as tilemaker itself, the FTWPL license.

