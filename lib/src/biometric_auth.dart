import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'biometric_status.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class BiometricAuth {
  final LocalAuthentication auth = LocalAuthentication();
  final storage = FlutterSecureStorage();

  Future<BiometricStatus> authenticate({
    String? localizedReason,
    Map<dynamic, dynamic>? userCredentials,
    bool biometricOnly = false,
    bool useErrorDialogs = false,
    bool sensitiveTransaction = true,
    bool stickyAuth = true,
  }
  ) async {
    try {
      if (userCredentials != null && userCredentials.isNotEmpty) {
        final jsonString = jsonEncode(userCredentials);
        await storage.write(key: "userCredentials", value: jsonString);
        print("Credentials saved.");
      } else {
        final storedData = await storage.read(key: "userCredentials");
        if (storedData == null) {
          print("No credentials found in secure storage.");
          return BiometricStatus.dataNotFound;
        }
        print("Credentials loaded from secure storage: $storedData");
      }

      bool canCheckBiometrics = await auth.canCheckBiometrics;
      bool isDeviceSupported = await auth.isDeviceSupported();
      List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();
      if (!canCheckBiometrics || !isDeviceSupported) {
        return BiometricStatus.deviceNotSupported;
      }
      print("availableBiometrics$availableBiometrics");
      late bool authStatus;
      if (availableBiometrics.isEmpty) {
        return BiometricStatus.biometricNotActivated;
      }
      authStatus = await auth.authenticate(
        localizedReason: localizedReason ?? 'Please Authenticate',
        options: AuthenticationOptions(
          biometricOnly: biometricOnly,
          useErrorDialogs: useErrorDialogs,
          stickyAuth: stickyAuth,
          sensitiveTransaction: sensitiveTransaction,
        ),
      );

      if (authStatus) {
        return BiometricStatus.success;
      } else {
        print("...User failed authentication or canceled.");
        return BiometricStatus.userCancelBiometric;
      }
    } on PlatformException catch (e) {
      print("PlatformException: ${e.code}");
      switch (e.code) {
        case auth_error.passcodeNotSet:
          return BiometricStatus.passcodeNotSet;
        case auth_error.notEnrolled:
          return BiometricStatus.biometricNotActivated;
        case auth_error.lockedOut:
        case auth_error.permanentlyLockedOut:
          return BiometricStatus.biometricLockedOut;
        default:
          return BiometricStatus.deviceNotSupported;
      }
    }
  }
}
