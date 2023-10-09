import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class Settings extends StatefulWidget {
  Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isSwitched = false;

  // Fonction pour changer l'état de l'empreinte digitale
  void toggleFingerprint(bool value) {
    setState(() {
      isSwitched = value;
    });
  }

  void changeLanguage(BuildContext context) {}

  void changeTheme(BuildContext context) {}

  void changePassword(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SettingsList(
      sections: [
        SettingsSection(
          title: const Text('Common'),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: const Icon(Icons.language),
              title: const Text('Langue'),
              value: const Text('English'),
            ),
            SettingsTile.switchTile(
              onToggle: (value) {},
              initialValue: true,
              leading: Icon(Icons.format_paint),
              title: Text('Enable custom theme'),
            ),
          ],
        ),
      ],
    ));
  }
}
