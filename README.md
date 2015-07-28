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

Standalone PORO assertions and validations.

The primary goal of the gem is to make standalone assertions about objects and validate them.

No monkey patching, no dependency from ActiveSupport, no mutable instances of any class.

[About](https://github.com/mbj/mutant/issues/356) 100% [mutant]-covered.

Synopsis
--------

### Make an Assertion

Define an assertion by inheriting it from the `Assertion::Base` class with attributes to which it should be applied.
Then implement the method `check` to describe if the assertion is truthy or falsey.

You can do it either in the classic style:

```ruby
class IsAdult < Assertion::Base
  attribute :age, :name

  def check
    age.to_i >= 18
  end
end
```

or with more expressive builder:

```ruby
IsAdult = Assertion.about :age, :name do
  age.to_i >= 18
end
```

### Add Messages

Define translations to describe both the *truthy* and *falsey* states of the assertion.

All the attributes are available in translations (that's why we declared the `name` as an attribute):

```yaml
# config/locales/en.yml
---
en:
  assertion:
    is_adult:
      truthy: "%{name} is already an adult (age %{age})"
      falsey: "%{name} is a child yet (age %{age})"
```

If you don't need to translate messages, define them for `truthy` and `falsey` states as methods:

```ruby
class IsAdult < Assertion::Base
  attribute :age, :name

  def check
    age.to_i >= 18
  end

  def truthy
    "#{name} is already an adult (age #{age})"
  end

  def falsey
    "#{name} is a child yet (age #{age})"
  end
end
```

### Check a State

Check a state of an assertion for some argument(s), using class method `[]`:

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

Inversion
---------

Use the `.not` *class* method to negate the assertion:

```ruby
jack = { name: 'Jack', age: 21, gender: :male }

IsAdult.not[jack]
# => #<Assertion::State @state=false, @messages=["Jack is already an adult (age 21)"]>
```

Composition
-----------

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
      truthy: "%{name} is a male"
      falsey: "%{name} is a female"
```

Use method `&` (or its aliases `+` or `>>`) to compose assertion states:

```ruby
jane = { name: 'Jane', age: 16, gender: :female }

state = IsAdult[jane] & IsMale[jane]
# => #<Assertion::State @state=false, @messages=["Jane is a child yet (age 16)", "Jane is a female"]>
```

Guards
------

The guard class is a lean wrapper around the state of its object.

It defines the `#state` for the object and checks if the state is valid:

```ruby
class VoterOnly < Assertion::Guard
  alias_method :user, :object

  def state
    IsAdult[user.attributes] & IsCitizen[user.attributes]
  end
end
```

Or using the builder `Assertion.guards`:

```ruby
VoterOnly = Assertion.guards :user do
  IsAdult[user.attributes] & IsCitizen[user.attributes]
end
```

When the guard is called for some object, its calls `#validate!` and then returns the source object. That simple.

```ruby
jack = OpenStruct.new(name: "Jack", age: 15, citizen: true)
john = OpenStruct.new(name: "John", age: 34, citizen: true)

voter = VoterOnly[jack]
# => #<Assertion::InvalidError @messages=["Jack is a child yet (age 15)"]

voter = VoterOnly[john]
# => #<OpenStruct @name="John", @age=34>
```

Naming Convention
-----------------

This is not necessary, but for verbosity you could follow the rules:

* use the prefixex `Is` (`Are`) for assertions (like `IsAdult`, `AreConsistent` etc.)
* use the suffix `Only` for guards (like `AdultOnly`)

Edge Cases
----------

You cannot define attributes with names already defined as istance methods,
or reserved by `Base#check` and `Guard#state`:

```ruby
IsAdult = Assertion.about :check
# => #<Assertion::NameError @message="IsAdult#check is already defined">

AdultOnly = Assertion.guards :state
# => #<Assertion::NameError @message="AdultOnly#state is already defined">
```

Testing
-------

The gem provides two sets of RSpec shared examples to specify assertions and guards in the expressive way.
To include them, require `assertion/rspec`.

### Assertions

Use `:validating_attributes` example:

```ruby
require "spec_helper"
require "assertion/rspec"

describe IsAdult do # defines described_class
  it_behaves_like :validating_attributes do
    let(:attributes) { { name: "Joe", age: 10 } }
    let(:locale)     { :fr                      } # :en by default

    subject(:valid)   { false                        } # false by default
    subject(:message) { "Joe est un enfant (10 ans)" } # can be skipped
  end
end
```

If the spec description doesn't declare `described_class` implicitly, you should define `assertion` explicitly:

```ruby
it_behaves_like :validating_attributes do
  let(:assertion) { IsAdult }
  # ...
end
```

### Guards

Use `:accepting_object` example:

```ruby
require "spec_helper"
require "assertion/rspec"

describe IsAdult do # defines described_class
  it_behaves_like :accepting_object do
    let(:object) { { name: "Joe", age: 10 } }
    let(:locale) { :fr                      } # :en by default

    subject(:accepted) { false                        } # false by default
    subject(:message)  { "Joe est un enfant (10 ans)" } # can be skipped
  end
end
```

If the spec description doesn't declare `described_class` implicitly, you should define `guard` explicitly:

```ruby
it_behaves_like :accepting_object do
  let(:guard) { AdultOnly }
  # ...
end
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
