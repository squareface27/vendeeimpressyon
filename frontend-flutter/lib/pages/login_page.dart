import 'package:flutter/material.dart';
import 'dart:core';
import 'package:vendeeimpressyon/components/button.dart';
import 'package:vendeeimpressyon/components/textfield.dart';
import 'package:vendeeimpressyon/pages/register_page.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vendeeimpressyon/pages/home_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // text editing controllers
  final mailController = TextEditingController();
  final passwordController = TextEditingController();

  final apiUrl = dotenv.env['API_URL_LOGIN']!;

  void showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Erreur"),
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

  // sign user in method
  void signUserIn(BuildContext context) async {
    final String mail = mailController.text;
    final String password = passwordController.text;
    final bool isValid = EmailValidator.validate(mail);

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'username': mail,
        'password': password,
      },
    );

    if (isValid == true) {
      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        showErrorMessage(context, "Le mot de passe ou l'email est incorrect.");
      }
    } else {
      showErrorMessage(context, "Le format de l'email est incorrect");
    }
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
                const SizedBox(height: 0),

                // logo
                Image.asset(
                  'lib/assets/images/logo.png',
                  width: 300,
                  height: 300,
                ),

                const SizedBox(height: 0),

                // mail textfield
                MyTextField(
                  controller: mailController,
                  hintText: 'E-mail',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Mot de passe',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Mot de passe oublié ?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // sign in button
                MyButtonLogin(
                  onTap: () {
                    signUserIn(context);
                  },
                ),

                const SizedBox(height: 50),

                // or continue with
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'ou',
                          style: TextStyle(color: Colors.grey[700]),
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

                const SizedBox(height: 50),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Vous n\'avez pas de compte ?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()),
                        );
                      },
                      child: const Text(
                        'Créer un compte',
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
