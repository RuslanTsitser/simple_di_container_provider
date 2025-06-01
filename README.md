<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Simple DI Container Provider

A lightweight and simple dependency injection container provider for Flutter applications. This package provides an easy way to manage and access services throughout your Flutter widget tree.

## Features

- 🚀 Simple and lightweight implementation
- 🔄 Automatic initialization and disposal of services
- 🎯 Type-safe service access
- 🌳 Widget tree integration
- ⚡️ Support for multiple service containers
- 🛠️ Customizable initialization and disposal behavior

## Getting started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  simple_di_container_provider: ^0.0.1
```

## Usage

1. Create your services container by implementing the `ServicesContainer` interface:

```dart
class MyServicesContainer implements ServicesContainer {
  const MyServicesContainer({required this.name});
  final String name;

  @override
  Future<void> init() async {
    // Initialize your services here
  }

  @override
  Future<void> dispose() async {
    // Clean up your services here
  }
}
```

2. Wrap your app with `ServicesContainerProvider`:

```dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ServicesContainerProvider<MyServicesContainer>(
      servicesContainerBuilder: () => const MyServicesContainer(name: 'MyServicesContainer'),
      child: const MaterialApp(home: MyHomePage()),
    );
  }
}
```

3. Access your services container from any widget:

```dart
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final servicesContainer = ServicesContainerProvider.of<MyServicesContainer>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(servicesContainer.name),
      ),
      // ... rest of your widget
    );
  }
}
```

### Configuration Options

The `ServicesContainerProvider` widget accepts the following parameters:

- `servicesContainerBuilder`: A function that creates your services container instance
- `autoDispose` (default: true): Whether to automatically dispose the container when the provider is disposed
- `autoInit` (default: true): Whether to automatically initialize the container when the provider is created
- `initWidgetBuilder`: A widget to display while the container is initializing

## Additional information

### Multiple Containers

You can use multiple service containers in your widget tree:

```dart
ServicesContainerProvider<Container1>(
  servicesContainerBuilder: () => Container1(),
  child: ServicesContainerProvider<Container2>(
    servicesContainerBuilder: () => Container2(),
    child: const MyApp(),
  ),
)
```

### Manual Initialization

If you need more control over the initialization process, you can set `autoInit` to false and initialize the container manually:

```dart
ServicesContainerProvider<MyServicesContainer>(
  servicesContainerBuilder: () => const MyServicesContainer(name: 'MyServicesContainer'),
  autoInit: false,
  child: const MyApp(),
)
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
