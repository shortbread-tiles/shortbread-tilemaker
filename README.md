# Shortbread Vector Tiles – Tilemaker Configuration

This Git repository contains the Tilemaker configuration files in order to produce
vector tiles in the Shortbread schema.

* [Instructions](https://shortbread-tiles.org/make-vectortiles/)
* [Schema documentation](https://shortbread-tiles.org/schema/)

## Supported Languages

Starting with version 1.1 Shortbread specification says that any object which
has a `name` tag written as attribute `name` to the vectortiles may have
additional languages as `name_xx` attributes. They represent the value of
`name:xx=*` tags in OSM. The specification do not prescribe which languages to
support. Language support itself is optional.

When you create vector tiles using this implementation, you may decide
yourself which languages you would like to include. By default, no
additional languages are enabled. You can provide a languages.lua file
where you define the languages to support and rules for fallback if they
are absent. See `languages.lua.sample` for details of configuration and examples.

## Authors

This set of configuration files has been created for Geofabrik by Michael Reichert 
and Amanda McCann before it was put on Github. Further contributors may be visible 
in the git history.

## License and Copyright

Because this set of configuration files is intended to go with the tilemaker software,
it is released under the same license as tilemaker itself, the [FTWPL license](./LICENCE.txt).

