## Prepared for the next version

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

[Compare v0.0.1...HEAD](https://github.com/nepalez/assertion/compare/v0.0.1...HEAD)
