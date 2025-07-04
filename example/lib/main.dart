import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:simple_di_container_provider/simple_di_container_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyServicesContainer implements ServicesContainer {
  const MyServicesContainer({required this.name});
  final String name;

  @override
  Future<void> init() async {
    log('MyServicesContainer init');
  }

  @override
  Future<void> dispose() async {
    log('MyServicesContainer dispose');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ServicesContainerProvider<MyServicesContainer>(
      servicesContainerBuilder: () =>
          const MyServicesContainer(name: 'MyServicesContainer'),
      child: const MaterialApp(home: MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final servicesContainer = ServicesContainerProvider.of<MyServicesContainer>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(servicesContainer.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
