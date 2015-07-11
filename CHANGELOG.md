## Prepared for the next version

### Added

* New shared examples: `:validating_assertions`, and `:accepting_objects`
  to specify assertions and guards correspondingly (nepalez)

### Internal

* Switched to `ice_nine` gem to freezing objects deeply (nepalez)

[Compare v0.2.1...HEAD](https://github.com/nepalez/assertion/compare/v0.2.1...HEAD)

## v0.2.1 2015-06-23

### Bugs Fixed

* Support any values returned by `Base#check` method, not only boolean ones (nepalez)

### Internal

* `[]` caller method is extracted from `BaseDSL`, `Inverter`, and `GuardDSL` to `DSL::Caller` (nepalez)
* `GuardDSL` is splitted to `DSL::Caller` and `DSL::Attribute` (nepalez)
* `.attribute`, `.attributes` and `#attributes` extracted from `BaseDSL` to `DSL::Attributes` (nepalez)
* `BaseDSL` is splitted to `DSL::Attributes`, `DSL::Caller` and `DSL::Inversion` (nepalez)
* `DSL` is renamed to `DSL::Builder` to follow the convention. `DSL` is reserved for collection of DSLs (nepalez)

[Compare v0.2.0...v0.2.1](https://github.com/nepalez/assertion/compare/v0.2.0...v0.2.1)

## v0.2.0 2015-06-22

### Changed (backward-incompatible!)

* Renamed translation keys from `:right`/`:wrong` to `:truthy`/`:falsey` for consistency (nepalez)

### Internal

* Attributes are added to `Base` and `Guard` at the moment of definition,
  instead of the initializations (addresses efficiency issue #1) (nepalez)
* `Translator` replaced `Messages` and `List`(transproc) to invert dependency
  of `Base` from translations. (nepalez)
* Class-level DSL features are extracted from `Assertion`, `Base` and `Guard`
  to the separate modules `DSL`, `BaseDSL`, `GuardDSL` correspondingly (nepalez)

[Compare v0.1.0...v0.2.0](https://github.com/nepalez/assertion/compare/v0.1.0...v0.2.0)

## v0.1.0 2015-06-20

### Added

* New `Guard` base class for guarding objects (nepalez)
* New `Assertion.guards` builder method to provide specific guards (nepalez)
* Custom `Assertion::InvalidError#inspect` method that shows `#messages` (nepalez)

### Deleted

* Removed `Assertion::NotImplementedError` (use `NoMethodError` instead) (nepalez)
* Removed `Assertion::NameError` (use generic `NameError` instead) (nepalez)

### Internal

* Moved all message-related features to the `Assertion::Messages` (nepalez)
* Removed `Assertion::I18n` (not the part of public API) (nepalez)
* Extracted attribute DSL from `Assertion::Base` to `Assertion::Attributes` (nepalez)

[Compare v0.0.1...v0.1.0](https://github.com/nepalez/assertion/compare/v0.0.1...v0.1.0)
