import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

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
            print("go to settings");
            await AppSettings.openAppSettings(type: AppSettingsType.security);
            print("return from settings");
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
