This gem is no longer needed in Ruby 2.5+, as Ruby already implements this method.

## Description

Implements a much needed `Pathname#glob` method.

To install run `gem install pathname-glob`, and then `require "pathname-glob"` in your code.

## Usage

It supports similar interface to `Dir.glob` and `Pathname::glob`.

```ruby
Pathname("foo").glob("*.txt")
Pathname("foo").glob("*.txt", File::FNM_DOTMATCH)
Pathname("foo").glob(["*.txt", "*.html"])
Pathname("foo").glob("*.txt") do |path|
  # yields Pathname objects
end # returns nil
```

## What's the advantage over other globbing methods?

For simple case these are equivalent:

```ruby
Pathname("/foo/bar").glob("*.txt")
Pathname.glob("/foo/bar/*.txt")
Dir.glob("/foo/bar/*.txt").map{|path| Pathname(path)}
```

However in addition to greater convenience, `Pathname#glob` is the only one that can handle special characters in folder name:

```ruby
Pathname("very*special*folder/{real} [special] ? yes!").glob("*.txt")
```

`Dir.glob` and `Pathname.glob` inherently can't as they don't know where folder name ends and pattern begins.

If you're dealing with user data, running into special characters like that is pretty much guaranteed.
