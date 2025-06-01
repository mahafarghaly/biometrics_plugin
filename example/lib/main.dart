import 'package:app_settings/app_settings.dart';
import 'package:biometrics_plugin/biometrics_plugin.dart';
import 'package:flutter/material.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Biometric Plugin')),
        body: BiometricScreen(),
      ),
    );
  }
}

class BiometricScreen extends StatefulWidget {
  const BiometricScreen({super.key});

  @override
  State<BiometricScreen> createState() => _BiometricScreenState();
}

class _BiometricScreenState extends State<BiometricScreen>
    with WidgetsBindingObserver {
  String _authResult = 'Waiting...';
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

  Future<void> authenticateUser() async {
    if (_isAuthenticated) return;
    _dialogShown = false;
    status = await biometricAuth.authenticate(
      localizedReason: "Authenticate to use the app",
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
        showDialog(context: context, builder: (context) => SettingsAlert());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Authentication Result: $_authResult'));
  }
}
class SettingsAlert extends StatelessWidget {
  const SettingsAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      title: Text('Biometric Status'),
      content: Text('Biometric is not activated'),
      actions: [
        TextButton(
          onPressed: () async {
            await AppSettings.openAppSettings(type: AppSettingsType.security);
            Navigator.of(context).pop();
          },
          child: Text('Open Settings'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Dismiss'),
        ),
      ],
    );
  }
}