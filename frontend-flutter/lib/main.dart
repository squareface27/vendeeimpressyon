import 'package:flutter/material.dart';
import 'package:vendeeimpressyon/pages/vacance_page.dart';
import 'pages/auth/login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:device_preview/device_preview.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final apiUrl = dotenv.env['API_URL_SETTINGS']!;

Future<void> main() async {
  await dotenv.load();
  final response = await http.get(Uri.parse(apiUrl));

  bool isVacationMode = false;

  if (response.statusCode == 200) {
    final data = response.body;
    final jsonData = json.decode(data);

    final vacanceValue = jsonData[0]['vacance'];

    if (vacanceValue is bool) {
      isVacationMode = vacanceValue;
    }
  }

  runApp(MyApp(isVacationMode: isVacationMode));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.isVacationMode});
  final bool isVacationMode;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,
      // theme: ThemeData.light(),
      // darkTheme: ThemeData.dark(),
      home: isVacationMode ? const Vacance() : LoginPage(),
    );
  }
}
