import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_di_container_provider/simple_di_container_provider.dart';

class MyServicesContainer1 extends Mock implements ServicesContainer {
  MyServicesContainer1();
}

class MyServicesContainer2 extends Mock implements ServicesContainer {
  MyServicesContainer2();
}

void main() {
  testWidgets(
    '''ServicesContainerProvider
Verify MyServicesContainer1 instance is in context
''',
    (WidgetTester tester) async {
      await tester.pumpWidget(ServicesContainerProvider<MyServicesContainer1>(
        servicesContainerBuilder: () => MyServicesContainer1(),
        autoDispose: false,
        autoInit: false,
        child: const MaterialApp(
            home: Scaffold(body: Center(child: Text('MyServicesContainer')))),
      ));
      final context = tester.element(find.byType(Center));
      final servicesContainer =
          ServicesContainerProvider.of<MyServicesContainer1>(context);
      expect(servicesContainer, isA<MyServicesContainer1>());
    },
  );

  testWidgets(
    '''ServicesContainerProvider
Verify init called once
Verify dispose never called
''',
    (WidgetTester tester) async {
      final container = MyServicesContainer1();
      when(() => container.init()).thenAnswer((_) async {});
      when(() => container.dispose()).thenAnswer((_) async {});
      await tester.pumpWidget(ServicesContainerProvider<MyServicesContainer1>(
        servicesContainerBuilder: () => container,
        autoDispose: true,
        autoInit: true,
        child: const MaterialApp(
            home: Scaffold(body: Center(child: Text('MyServicesContainer')))),
      ));

      await tester.pumpAndSettle();
      verify(() => container.init()).called(1);
      verifyNever(() => container.dispose());
    },
  );

  testWidgets(
    '''ServicesContainerProvider
Verify both of containers are in context
''',
    (WidgetTester tester) async {
      final container1 = MyServicesContainer1();
      final container2 = MyServicesContainer2();
      await tester.pumpWidget(ServicesContainerProvider<MyServicesContainer1>(
        servicesContainerBuilder: () => container1,
        autoDispose: false,
        autoInit: false,
        child: ServicesContainerProvider<MyServicesContainer2>(
          servicesContainerBuilder: () => container2,
          autoDispose: false,
          autoInit: false,
          child: const MaterialApp(
              home: Scaffold(body: Center(child: Text('MyServicesContainer')))),
        ),
      ));
      final context1 = tester.element(find.byType(Center));
      final context2 = tester.element(find.byType(Center));
      final servicesContainer1 =
          ServicesContainerProvider.of<MyServicesContainer1>(context1);
      final servicesContainer2 =
          ServicesContainerProvider.of<MyServicesContainer2>(context2);
      expect(servicesContainer1, isA<MyServicesContainer1>());
      expect(servicesContainer2, isA<MyServicesContainer2>());
    },
  );
}
