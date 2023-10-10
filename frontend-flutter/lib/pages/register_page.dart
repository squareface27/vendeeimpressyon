import 'package:flutter/material.dart';
import 'package:vendeeimpressyon/components/button.dart';
import 'package:vendeeimpressyon/components/textfield.dart';
import 'package:vendeeimpressyon/pages/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class Etablissement {
  final String nom;
  final String ville;

  Etablissement(this.nom, this.ville);
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  String? selectedEtablissement;
  List<Etablissement> etablissements = [];

  @override
  void initState() {
    super.initState();
    fetchEtablissements();
  }

  // Désérialisation du JSON des établissements
  Future<void> fetchEtablissements() async {
    final response = await http.get(Uri.parse(apiUrlGetEtablissement));
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as List<dynamic>;
      final etablissementsList = responseData.map((item) {
        final nom = item["nom"].toString();
        final ville = item["ville"].toString();
        return Etablissement(nom, ville);
      }).toList();
      setState(() {
        etablissements = etablissementsList;
      });
    }
  }

  final apiUrlRegister = dotenv.env['API_URL_REGISTER']!;
  final apiUrlGetMail = dotenv.env['API_URL_GET_MAIL']!;
  final apiUrlGetEtablissement = dotenv.env['API_URL_GET_ETABLISSEMENT']!;

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

  // Désérialisation du fichier JSON des adresses-mail
  Future<bool> isEmailAlreadyRegistered(String email) async {
    final response = await http.get(
      Uri.parse('$apiUrlGetMail?email=$email'),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as List<dynamic>;

      final existsValue = responseData.any((item) {
        if (item is Map<String, dynamic> && item.containsKey("mail")) {
          final mailValue = item["mail"] as String;
          return mailValue == email;
        }
        return false;
      });

      if (existsValue) {
        return true;
      }
    }
    return false;
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

    // Check mail
    final isEmailExists = await isEmailAlreadyRegistered(mail);
    if (isEmailExists) {
      showErrorMessage(context, "L'adresse mail est déjà utilisée");
      return;
    }

    final response = await http.post(
      Uri.parse(apiUrlRegister),
      body: {
        'mail': mail,
        'password': password,
        'confirm_password': passwordconfirm,
        'etablissement': selectedEtablissement,
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

                const SizedBox(height: 10),

                DropdownButton<String>(
                  value:
                      etablissements.isNotEmpty ? selectedEtablissement : null,
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text("Sélectionnez un établissement"),
                    ),
                    ...etablissements.map((etablissement) {
                      final concatene =
                          "${etablissement.nom} ${etablissement.ville}";
                      return DropdownMenuItem<String>(
                        value: concatene,
                        child: Text(concatene),
                      );
                    }).toList(),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedEtablissement = value;
                    });
                  },
                ),

                const SizedBox(height: 15),

                // sign in button
                MyButtonRegister(
                  onTap: () {
                    registerUserIn(context);
                  },
                ),

                const SizedBox(height: 15),

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
