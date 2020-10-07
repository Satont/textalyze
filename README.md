# Textalyze

[![Cirrus CI - Base Branch Build Status](https://img.shields.io/cirrus/github/AlexWayfer/textalyze?style=flat-square)](https://cirrus-ci.com/github/AlexWayfer/textalyze)
[![Codecov branch](https://img.shields.io/codecov/c/github/AlexWayfer/textalyze/master.svg?style=flat-square)](https://codecov.io/gh/AlexWayfer/textalyze)
[![Code Climate](https://img.shields.io/codeclimate/maintainability/AlexWayfer/textalyze.svg?style=flat-square)](https://codeclimate.com/github/AlexWayfer/textalyze)
[![Depfu](https://img.shields.io/depfu/AlexWayfer/textalyze?style=flat-square)](https://depfu.com/repos/github/AlexWayfer/textalyze)
[![Inline docs](https://inch-ci.org/github/AlexWayfer/textalyze.svg?branch=master)](https://inch-ci.org/github/AlexWayfer/textalyze)
[![License](https://img.shields.io/github/license/AlexWayfer/textalyze.svg?style=flat-square)](LICENSE.txt)
[![Gem](https://img.shields.io/gem/v/textalyze.svg?style=flat-square)](https://rubygems.org/gems/textalyze)

Text analyze: splitting sentences, matching words, detecting caps.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'textalyze'
```

And then execute:

```shell
bundle install
```

Or install it yourself as:

```shell
gem install textalyze
```

## Usage

```ruby
require 'textalyze'

## Matching words in a single sentence
Textalyze::Text.new('Hello there, dear friend. How are you?')
  .match?(included: %w[hello dear friend])
  # => true

## Exclude words while matching
Textalyze::Text.new('Hello there, bad dear friend. How are you?')
  .match?(included: %w[hello dear friend], excluded: %w[bad ass])
  # => false

## Check if text is capsed
Textalyze::Text.new("HELLO, FRIEnd! how are you? i'm ok.")
  .capsed? # => true
Textalyze::Text.new("It's YAML. That's ALL. Did you HEAR ME?")
  .capsed? # => false

## Pass an allowed caps percentage
Textalyze::Text.new("HELLO, Friend! how are you? i'm ok.")
  .capsed?(50) # => true
Textalyze::Text.new("HELLO, friend! HOW are you? i'm OK.")
  .capsed?(50) # => false
```

## Development

After checking out the repo, run `bundle install` to install dependencies.

Then, run `toys rspec` to run the tests.

To install this gem onto your local machine, run `toys gem install`.

To release a new version, run `toys gem release %version%`.
See how it works [here](https://github.com/AlexWayfer/gem_toys#release).

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/AlexWayfer/textalyze).

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
