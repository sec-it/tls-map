# Installation

## Production

### Install from rubygems.org

```plaintext
$ gem install tls-map
```

Gem: [tls-map](https://rubygems.org/gems/tls-map)

### Install from BlackArch

From the repository:

```plaintext
# pacman -S tls-map
```

PKGBUILD: [tls-map](https://github.com/BlackArch/blackarch/blob/master/packages/tls-map/PKGBUILD)

### Install from Pentoo

From the repository:

```plaintext
# emerge TODO/tls-map
```

## Development

It's better to use [rbenv](https://github.com/rbenv/rbenv) or [asdf](https://github.com/asdf-vm/asdf) to have latests version of ruby and to avoid trashing your system ruby.

### Install from rubygems.org

```plaintext
$ gem install --development tls-map
```

### Build from git

Just replace `x.x.x` with the gem version you see after `gem build`.

```plaintext
$ git clone https://github.com/sec-it/tls-map.git tls-map
$ cd tls-map
$ gem install bundler
$ bundler install
$ gem build tls-map.gemspec
$ gem install tls-map-x.x.x.gem
```

Note: if an automatic install is needed you can get the version with `$ gem build tls-map.gemspec | grep Version | cut -d' ' -f4`.

### Run without installing the gem

From local file:

```plaintext
$ irb -Ilib -rtls_map
```

Same for the CLI tool:

```plaintext
$ ruby -Ilib -rtls_map bin/tls-map
```
