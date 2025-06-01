import 'package:flutter/material.dart';

import 'services_container.dart';

/// A widget that provides a [ServicesContainer] to its descendants.
/// - [autoDispose] - if true, the [ServicesContainer] will be disposed when the widget is disposed.
/// - [autoInit] - if true, the [ServicesContainer] will be initialized when the widget is initialized.
/// - [initWidgetBuilder] - a widget to build when the [ServicesContainer] is initializing.
class ServicesContainerProvider<T extends ServicesContainer>
    extends StatefulWidget {
  const ServicesContainerProvider({
    super.key,
    required this.child,
    required this.servicesContainerBuilder,
    this.autoDispose = true,
    this.autoInit = true,
    this.initWidgetBuilder,
  });

  final Widget child;

  /// A builder for the [ServicesContainer].
  final T Function() servicesContainerBuilder;

  /// If true, the [ServicesContainer] will be disposed when the widget is disposed.
  final bool autoDispose;

  /// If true, the [ServicesContainer] will be initialized when the widget is initialized.
  final bool autoInit;

  /// A widget to build when the [ServicesContainer] is initializing.
  final Widget Function(BuildContext context)? initWidgetBuilder;

  /// Returns the [ServicesContainer] from the context.
  /// It uses [getInheritedWidgetOfExactType] to get the [ServicesContainer] from the context.
  /// It is safe to call this method from build method or from any other method.
  static T of<T extends ServicesContainer>(BuildContext context) {
    final ServicesContainerInherited? result =
        context.getInheritedWidgetOfExactType<ServicesContainerInherited<T>>();
    if (result == null) {
      throw Exception('ServicesContainerInherited not found in context');
    }
    final servicesContainer = result.servicesContainer;
    if (servicesContainer is! T) {
      throw Exception('ServicesContainerInherited is not of type $T');
    }
    return servicesContainer;
  }

  @override
  State<ServicesContainerProvider<T>> createState() =>
      _ServicesContainerProviderState<T>();
}

class _ServicesContainerProviderState<T extends ServicesContainer>
    extends State<ServicesContainerProvider<T>> {
  late T _servicesContainer;
  late bool _isInitialized;

  @override
  void initState() {
    super.initState();
    _servicesContainer = widget.servicesContainerBuilder();
    if (widget.autoInit) {
      _init();
    } else {
      _isInitialized = true;
    }
  }

  Future<void> _init() async {
    _isInitialized = false;
    await _servicesContainer.init();
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    if (widget.autoDispose) {
      _servicesContainer.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return widget.initWidgetBuilder?.call(context) ?? const SizedBox.shrink();
    }
    return ServicesContainerInherited(
      servicesContainer: _servicesContainer,
      child: widget.child,
    );
  }
}

/// A widget that provides a [ServicesContainer] to its descendants.
/// Use it only once in the widget tree.
class ServicesContainerInherited<T extends ServicesContainer>
    extends InheritedWidget {
  const ServicesContainerInherited({
    super.key,
    required super.child,
    required this.servicesContainer,
  });

  final T servicesContainer;

  @override
  bool updateShouldNotify(ServicesContainerInherited oldWidget) {
    return false;
  }
}
