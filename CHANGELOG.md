## Prepared for v0.2.1

### Bugs Fixed

* Support any values returned by `Base#check` method, not only boolean ones (nepalez)

### Internal

* `[]` caller method is extracted from `BaseDSL`, `Inverter`, and `GuardDSL` to `DSL::Caller` (nepalez)
* `GuardDSL` is splitted to `DSL::Caller` and `DSL::Attribute` (nepalez)

[Compare v0.2.0...HEAD](https://github.com/nepalez/assertion/compare/v0.2.0...HEAD)

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
