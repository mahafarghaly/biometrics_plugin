import 'package:biometrics_plugin/biometrics_plugin.dart';
import 'package:biometrics_plugin_example/biometric_screen.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late BiometricStatus status;
  @override
  void initState() {
    super.initState();


  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        appBar: AppBar(title: const Text('Biometric Plugin Example')),
        body: BiometricScreen(),
      ),
    );
  }
}
