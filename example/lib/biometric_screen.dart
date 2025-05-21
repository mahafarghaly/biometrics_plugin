import 'package:app_settings/app_settings.dart';
import 'package:biometrics_plugin/biometrics_plugin.dart';
import 'package:biometrics_plugin/view/widgets/settings_alert.dart';


import 'package:flutter/material.dart';

import 'main.dart';

class BiometricScreen extends StatefulWidget {
  const BiometricScreen({super.key});

  @override
  State<BiometricScreen> createState() => _BiometricScreenState();
}

class _BiometricScreenState extends State<BiometricScreen> with  WidgetsBindingObserver{
  String _authResult = 'Waiting...';

 // final biometricAuth = BiometricAuth();
  final biometricAuth = BiometricAuth();
   BiometricStatus? status;
  bool _dialogShown = false;
  bool _isAuthenticated = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authenticateUser();
    });
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App came back to foreground, re-check biometric status
      authenticateUser();
    }
  }

  Future<void> authenticateUser2() async {

    print("=-----88");
    status = await biometricAuth.authenticate(
      navigatorKey.currentContext,
      localizedReason: "Authenticate to use the appooo",
      userCredentials:{"email":"maha@gmail.com","password":"1234"},
      stickyAuth: false,
    );
    setState(() {
      _authResult = status.toString();
    });
  }
  Future<void> authenticateUser() async {
    if (_isAuthenticated) return;
    print("Authenticating...");
    _dialogShown = false;

    print("=----- Authenticating");

    status = await biometricAuth.authenticate(
      navigatorKey.currentContext,
      localizedReason: "Authenticate to use the appooo",
      userCredentials: {"email": "maha@gmail.com", "password": "1234"},
      stickyAuth: false,
    );

    print("Biometric status: $status");

    setState(() {
      _authResult = status.toString();
    });
    if (status == BiometricStatus.success) {
      _isAuthenticated = true; // ✅ mark success
    }
    if (status == BiometricStatus.biometricNotActivated && !_dialogShown) {
      _dialogShown = true;
      Future.delayed(Duration(milliseconds: 200), () {
        showDialog(
          context: context,
          builder: (context) => SettingsAlert()
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Authentication Result: $_authResult'),
    );
  }
}

