import 'package:biometrics_plugin/biometrics_plugin.dart';
import 'package:biometrics_plugin_example/biometric_screen.dart';
import 'package:flutter/material.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Biometric Plugin')),
        body: BiometricScreen(),
      ),
    );
  }
}
