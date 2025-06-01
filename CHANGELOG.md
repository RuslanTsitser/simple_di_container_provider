# Changelog

## [0.0.1] - 2025-06-01

### Added

- Initial release of Simple DI Container Provider
- Basic `ServicesContainer` interface with `init()` and `dispose()` methods
- `ServicesContainerProvider` widget for managing service containers in the widget tree
- Support for automatic initialization and disposal of services
- Type-safe service access through `ServicesContainerProvider.of<T>()`
- Support for multiple service containers in the widget tree
- Customizable initialization and disposal behavior
- Loading widget support during container initialization
