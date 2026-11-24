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

### Error messages

If languages.lua has a syntax error, it will be logged (once per
thread!) as:

```
Warning: Failed to load languages.lua, setting name attribute only.
error loading module 'languages' from file './languages.lua':
        ./languages.lua:20: '}' expected (to close '{' at line 19) near '='
```

If languages.lua does not exist (not found), it will be logged (once per
thread!) as following and Tilemaker will continue to process vector tiles for
you:

```
Warning: Failed to load languages.lua, setting name attribute only.
module 'languages' not found:
        no field package.preload['languages']
        no file './languages.lua'
        no file '/usr/share/luajit-2.1/languages.lua'
        no file '/usr/local/share/lua/5.1/languages.lua'
        no file '/usr/local/share/lua/5.1/languages/init.lua'
        no file '/usr/share/lua/5.1/languages.lua'
        no file '/usr/share/lua/5.1/languages/init.lua'
        no file './languages.so'
        no file '/usr/local/lib/lua/5.1/languages.so'
        no file '/usr/lib/x86_64-linux-gnu/lua/5.1/languages.so'
        no file '/usr/local/lib/lua/5.1/loadall.so'
```

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

