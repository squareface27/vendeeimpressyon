import 'package:flutter/material.dart';
import 'dart:core';
import 'package:vendeeimpressyon/components/button.dart';
import 'package:vendeeimpressyon/components/textfield.dart';
import 'package:vendeeimpressyon/pages/auth/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vendeeimpressyon/colors.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  // text editing controllers
  final mailController = TextEditingController();

  final apiUrlResetPassword = dotenv.env['API_URL_RESET_PASSWORD']!;

  void showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Information"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // mot de passe oublié
  void ResetPassword(BuildContext context) async {
    final String mail = mailController.text;

    final response = await http.post(
      Uri.parse(apiUrlResetPassword),
      body: {
        'mail': mail,
      },
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
                Image.asset(
                  'lib/assets/images/logo.png',
                  width: 300,
                  height: 300,
                ),

                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: bluegrey,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Text(
                    "Saisissez votre adresse mail, si elle correspond à un compte déjà existant, nous vous enverrons la procédure de réinitialisation par mail",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // mail textfield
                MyTextField(
                  controller: mailController,
                  hintText: 'E-mail',
                  obscureText: false,
                ),

                const SizedBox(height: 20),

                // button
                MyButtonResetPassword(onTap: () {
                  ResetPassword(context);
                }),

                const SizedBox(height: 50),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Retourner à la page de ',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: const Text(
                        'connexion',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
