import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vendeeimpressyon/colors.dart';
import 'package:restart_app/restart_app.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextStyle headingStyle =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: blue);

  void _navigateToLogin(BuildContext context) {
    Restart.restartApp();
  }

  bool lockAppSwitchVal = true;
  bool changePassSwitchVal = true;

  TextStyle headingStyleIOS = const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: CupertinoColors.inactiveGray,
  );
  TextStyle descStyleIOS = const TextStyle(color: CupertinoColors.inactiveGray);

  @override
  Widget build(BuildContext context) {
    return (Platform.isAndroid)
        ? MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: blue,
                secondary: blue,
              ),
            ),
            home: Scaffold(
              appBar: AppBar(
                title: const Text("Paramètres"),
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Compte", style: headingStyle),
                        ],
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.exit_to_app),
                        title: const Text("Se Déconnecter"),
                        onTap: () {
                          _navigateToLogin(context);
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Sécurité", style: headingStyle),
                        ],
                      ),
                      const Divider(),
                      const ListTile(
                        leading: Icon(Icons.lock),
                        title: Text("Changer de Mot de Passe"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Autre", style: headingStyle),
                        ],
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.file_open_outlined),
                        title: const Text("Conditions Générales de Vente"),
                        onTap: () {
                          final cgvUrl = Uri.parse(dotenv.env['CGV_URL']!);
                          launchUrl(cgvUrl);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: const Text("Nous contacter"),
                        onTap: () {
                          final cgvUrl = Uri(scheme: 'tel', path: '0251980858');
                          launchUrl(cgvUrl);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : CupertinoApp(
            debugShowCheckedModeBanner: false,
            home: CupertinoPageScaffold(
              navigationBar: const CupertinoNavigationBar(
                backgroundColor: CupertinoColors.activeBlue,
                middle: Text("Paramètres"),
              ),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: CupertinoColors.extraLightBackgroundGray,
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    //Account
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 12),
                        Text(
                          "Compte",
                          style: headingStyleIOS,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      color: CupertinoColors.white,
                      child: Column(
                        children: [
                          const Divider(),
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 38,
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                          ),
                          const Divider(),
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 38,
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 12),
                                Icon(
                                  Icons.exit_to_app,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 12),
                                Text("Se Déconnecter"),
                                Spacer(),
                                Icon(
                                  CupertinoIcons.right_chevron,
                                  color: CupertinoColors.inactiveGray,
                                ),
                                SizedBox(width: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Security
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 12),
                        Text(
                          "Sécurité",
                          style: headingStyleIOS,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      color: CupertinoColors.white,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 38,
                          ),
                          const Divider(),
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 38,
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                          ),
                          const Divider(),
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 38,
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 12),
                                Icon(
                                  Icons.lock,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 12),
                                Text("Changer de Mot de Passe"),
                                SizedBox(width: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Misc
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 12),
                        Text(
                          "Autre",
                          style: headingStyleIOS,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      color: CupertinoColors.white,
                      child: Column(
                        children: [
                          const Divider(),
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 38,
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 12),
                                Icon(
                                  Icons.file_copy_sharp,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 12),
                                Text("Conditions générales de vente"),
                                Spacer(),
                                Icon(
                                  CupertinoIcons.right_chevron,
                                  color: CupertinoColors.inactiveGray,
                                ),
                                SizedBox(width: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
