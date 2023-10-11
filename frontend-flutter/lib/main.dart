import 'package:flutter/material.dart';
import 'pages/auth/login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vendeeimpressyon/pages/navbar.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
  // runApp(
  //   DevicePreview(enabled: !kReleaseMode, builder: (context) => MyApp()),
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,
      // theme: ThemeData.light(),
      // darkTheme: ThemeData.dark(),
      home: LoginPage(),
    );
  }
}
