import 'package:flutter/material.dart';
import 'package:vendeeimpressyon/components/button.dart';
import 'package:vendeeimpressyon/components/textfield.dart';
import 'package:vendeeimpressyon/pages/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  final apiUrl = dotenv.env['API_URL_REGISTER']!;

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
  void registerUserIn(BuildContext context) async {
    final String mail = usernameController.text;
    final String password = passwordController.text;
    final String passwordconfirm = passwordConfirmController.text;
    final bool isValid = EmailValidator.validate(mail);

    if (isValid == false) {
      showErrorMessage(context, "Le format du mail est invalide");
      return;
    }

    if (password.isEmpty || passwordconfirm.isEmpty) {
      showErrorMessage(context,
          "Le champ mot de passe et la confirmation du mot de passe ne peuvent pas être vides");
      return;
    }

    if (password != passwordconfirm) {
      showErrorMessage(context, "Les mots de passe ne correspondent pas");
      return;
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'username': mail,
        'password': password,
        'confirm_password': passwordconfirm,
      },
    );

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      return;
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

                const SizedBox(height: 5),

                // email textfield
                MyTextField(
                  controller: usernameController,
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

                // password textfield
                MyTextField(
                  controller: passwordConfirmController,
                  hintText: 'Confirmer votre mot de passe',
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                // sign in button
                MyButtonRegister(
                  onTap: () {
                    registerUserIn(context);
                  },
                ),

                const SizedBox(height: 25),

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

                const SizedBox(height: 25),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Vous avez déjà un compte ?',
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
                        'Se connecter',
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
