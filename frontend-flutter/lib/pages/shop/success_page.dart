import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:vendeeimpressyon/pages/shop/home_page.dart';

class PaymentSuccessPage extends StatefulWidget {
  final String email;
  final String categorieid;

  PaymentSuccessPage({
    required this.email,
    required this.categorieid,
  });

  @override
  _PaymentSuccessPageState createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
  String dureeRealisation = "";

  @override
  void initState() {
    super.initState();

    if (widget.categorieid == "Thèses & Mémoires") {
      dureeRealisation = "72 heures maximum, jour ouvré.";
    } else {
      dureeRealisation = "24 heures maximum, jour ouvré.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paiement réussi'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            width: 150,
            height: 150,
            child: Center(
              child: Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100,
              ),
            ),
          ),
          const SizedBox(height: 20),
          AnimatedTextKit(
            animatedTexts: [
              TyperAnimatedText('Paiement effectué avec succès!',
                  textStyle: const TextStyle(fontSize: 20)),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Estimation du temps pour réaliser la commande: $dureeRealisation',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                            email: widget.email,
                          )));
            },
            child: const Text("Retour à l'accueil"),
          ),
        ],
      ),
    );
  }
}
