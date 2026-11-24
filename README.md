# Shortbread Vector Tiles – Tilemaker Configuration

This Git repository contains the Tilemaker configuration files in order to produce
vector tiles in the Shortbread schema.

* [Instructions](https://shortbread-tiles.org/make-vectortiles/)
* [Schema documentation](https://shortbread-tiles.org/schema/)

## Branches and versioning

This repository contains the implementation for different version of the
Shortbread schema on different branches:

* [main](https://github.com/shortbread-tiles/shortbread-tilemaker/tree/main) for 1.1
* [shortbread-1.0](https://github.com/shortbread-tiles/shortbread-tilemaker/tree/shortbread-1.0) for 1.0

Pull requests should be made against the `main` branch except if they fix
a issue present in an older implementation only. Backports will be made by the maintainer
if necessary.

The major and minor number of a version number match the version of the schema.

## Authors

This set of configuration files has been created for Geofabrik by Michael Reichert 
and Amanda McCann before it was put on Github. Further contributors may be visible 
in the git history.

## License and Copyright

Because this set of configuration files is intended to go with the tilemaker software,
it is released under the same license as tilemaker itself, the [FTWPL license](./LICENCE.txt).

