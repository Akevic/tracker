import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import './pages/homePage.dart';
import './app_initializer.dart';
import './dependency_injection.dart';

void main() async {
  DependencyInjection().initialise(Injector.getInjector());
  injector = Injector.getInjector();
  await AppInitializer().initialise(injector);
  runApp(BiscanTracker());
}

Injector injector;

class BiscanTracker extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biscan Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
