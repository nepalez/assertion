Assertion
=========

[![Gem Version](https://img.shields.io/gem/v/assertion.svg?style=flat)][gem]
[![Build Status](https://img.shields.io/travis/nepalez/assertion/master.svg?style=flat)][travis]
[![Dependency Status](https://img.shields.io/gemnasium/nepalez/assertion.svg?style=flat)][gemnasium]
[![Code Climate](https://img.shields.io/codeclimate/github/nepalez/assertion.svg?style=flat)][codeclimate]
[![Coverage](https://img.shields.io/coveralls/nepalez/assertion.svg?style=flat)][coveralls]
[![Inline docs](http://inch-ci.org/github/nepalez/assertion.svg)][inch]

[codeclimate]: https://codeclimate.com/github/nepalez/assertion
[coveralls]: https://coveralls.io/r/nepalez/assertion
[gem]: https://rubygems.org/gems/assertion
[gemnasium]: https://gemnasium.com/nepalez/assertion
[travis]: https://travis-ci.org/nepalez/assertion
[inch]: https://inch-ci.org/github/nepalez/assertion

Immutable assertions and validations for PORO.

Synopsis
--------

The primary goal of the gem is to decouple assertions about the objects, and their validations, from the data.

No `ActiveSupport`, no mutation of any instances.

### Basic Usage

Define the assertion by inheriting it from the `Assertion::Base` class with attributes to which it should be applied.
Then implement the method `check` that should return the boolean value.

You can do it either in a classic style:

```ruby
class IsAdult < Assertion::Base
  attribute :age, :name

  def check
    age >= 18
  end
end
```

or using a builder for verbosity with the same result:

```ruby
IsAdult = Assertion.about :age, :name do
  age >= 18
end
```

Define translations for both the *right* and *wrong* states of the assertion.

All the declared attributes are available (that's why we declared a `name` as an attribute):

```yaml
# config/locales/en.yml
---
en:
  assertion:
    is_adult:
      right: "%{name} is already an adult (age %{age})"
      wrong: "%{name} is a child yet (age %{age})"
```

Check a state of a assertion for some argument(s), using class method `[]`:

```ruby
john = { name: 'John', age: 10, gender: :male }

state = IsAdult[john]
# => #<Assertion::State @state=false, @messages=["John is a child yet (age 10)"]>
```

The state supports `valid?`, `invalid?`, `messages` and `validate!` methods:

```ruby
state.valid?    # => false
state.invalid?  # => true
state.messages  # => ["John is a child yet (age 10)"]
state.validate! # => #<Assertion::InvalidError @messages=["John is a child yet (age 10)"]>
```

### Assertion Inversion

Use the `.not` *class* method to negate a assertion:

```ruby
jack = { name: 'Jack', age: 21, gender: :male }

IsAdult.not[jack]
# => #<Assertion::State @state=false, @messages=["Jack is already an adult (age 21)"]>
```

### Composition of States

You can compose assertion states (results):

```ruby
IsMale = Assertion.about :name, :gender do
  gender == :male
end
```

```yaml
# config/locales/en.yml
---
en:
  assertion:
    is_male:
      right: "%{name} is a male"
      wrong: "%{name} is a female"
```

Use method `&` (or its aliases `+` or `>>`) to compose assertion states:

```ruby
jane = { name: 'Jane', age: 16, gender: :female }

state = IsAdult[jane] & IsMale[jane]
# => #<Assertion::State @state=false, @messages=["Jane is a child yet (age 16)", "Jane is a female"]>
```

Object Validation
-----------------

If you are used to "rails style" validations, provide a validator from assertions:

```ruby
class User
  include Virtus.model

  attribute :name, String
  attribute :age, Integer
  attribute :gender, Symbol
end

class Women < User
  def validate!
    state.validate!
  end

  def state
    IsAdult[attributes] & IsMale.not[attributes]
  end
end

judy = Women.new(name: "Judy", age: 15, gender: :female)
judy.valdate!
# => #<Assertion::InvalidError @messages=["Judy is a child yet (age 15)"]>
```

Edge Cases
----------

You're expected to declare the `check` method for the assertion before applying it to some data.

Otherwise `Assertion::NotImplementedError` is raised:

```ruby
IsAdult = Assertion.about :name, :age

IsAdult[name: "Jane", age: 10]
# => #<Assertion::NotImplementedError @message="IsAdult#check method not implemented">
```

You cannot define attributes with names, that are already used as an istance methods:

```ruby
IsAdult = Assertion.about :check, :call
# => #<Assertion::NameError @message="Wrong name(s) for attribute(s): check, call">
```

Installation
------------

Add this line to your application's Gemfile:

```ruby
# Gemfile
gem "assertion"
```

Then execute:

```
bundle
```

Or add it manually:

```
gem install assertion
```

Compatibility
-------------

Tested under rubies [compatible to MRI 1.9+](.travis.yml).

Uses [RSpec] 3.0+ for testing and [hexx-suit] for dev/test tools collection.

[RSpec]: http://rspec.org
[hexx-suit]: https://github.com/nepalez/hexx-suit

Contributing
------------

* Read the [STYLEGUIDE](config/metrics/STYLEGUIDE)
* [Fork the project](https://github.com/nepalez/assertion)
* Create your feature branch (`git checkout -b my-new-feature`)
* Add tests for it (please, use [mutant] to verify the coverage!)
* Commit your changes (`git commit -am '[UPDATE] Add some feature'`)
* Push to the branch (`git push origin my-new-feature`)
* Create a new Pull Request

[mutant]: https://github.com/mbj/mutant

License
-------

See the [MIT LICENSE](LICENSE).
