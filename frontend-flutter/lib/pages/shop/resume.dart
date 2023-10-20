import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class ResumePage extends StatefulWidget {
  final String productName;
  final String pdfFileName;
  final int numberOfPages;
  final double unitPrice;
  final bool isRectoVerso;
  final double reliurePrice;
  final double premierepagePrice;
  final double finitionPrice;
  final double couverturePrice;
  double totalPrice;

  ResumePage({
    required this.productName,
    required this.pdfFileName,
    required this.numberOfPages,
    required this.unitPrice,
    required this.isRectoVerso,
    required this.reliurePrice,
    required this.premierepagePrice,
    required this.finitionPrice,
    required this.couverturePrice,
    required this.totalPrice,
  });

  @override
  _ResumePageState createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  String errorMessage = "";
  String successMessage = "";

  double montantReduction = 0.0;

  bool isAllFieldsFilled() {
    return widget.numberOfPages > 0 && widget.pdfFileName.isNotEmpty;
  }

  final apiUrl = dotenv.env['API_URL_GET_CODEPROMO']!;

  TextEditingController codePromoController = TextEditingController();
  String promoCode = "";

  bool promoApplied = false;

  String currentPromoCode = "";
  double currentPromoAmount = 0;

  @override
  void initState() {
    super.initState();
    errorMessage = "";
    successMessage = "";
  }

  void applyPromoCode() async {
    errorMessage = "";
    successMessage = "";

    promoCode = codePromoController.text.toLowerCase();

    if (promoCode == currentPromoCode) {
      setState(() {
        widget.totalPrice = widget.totalPrice / (1 - currentPromoAmount);
      });

      currentPromoCode = "";
      currentPromoAmount = 0;

      codePromoController.clear();

      errorMessage = "Code promo supprimé.";
    } else if (currentPromoCode.isEmpty) {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> promoCodes = json.decode(response.body);

        final promo = promoCodes.firstWhere(
          (promo) => promo['code'].toLowerCase() == promoCode,
          orElse: () => null,
        );

        if (promo != null) {
          final double reduction = promo['montant'] / 100;
          montantReduction = widget.totalPrice * reduction;

          if (reduction > 0) {
            if (widget.totalPrice > 0) {
              final double montantReduction = widget.totalPrice * reduction;

              if (montantReduction < widget.totalPrice) {
                currentPromoCode = promoCode;
                currentPromoAmount = reduction;

                setState(() {
                  widget.totalPrice = widget.totalPrice - montantReduction;
                });

                codePromoController.clear();

                successMessage =
                    "Code promo appliqué: ${promo['code']} - Réduction de ${promo['montant']}%";
              } else {
                errorMessage = "La réduction est supérieure au prix total.";
              }
            } else {
              errorMessage = "Le prix total est nul ou négatif.";
            }
          }
        } else {
          errorMessage = "Code promo invalide";
        }
      } else {
        errorMessage = "Erreur lors de la requête API";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Résumé de la Commande"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Produit : ${widget.productName}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text("Fichier PDF : ${widget.pdfFileName}",
                  textAlign: TextAlign.center),
              Text("Nombre de Pages : ${widget.numberOfPages} pages",
                  textAlign: TextAlign.center),
              Text("Recto/Verso : ${widget.isRectoVerso ? 'Oui' : 'Non'}",
                  textAlign: TextAlign.center),
              Text("Type de Reliure : ${widget.reliurePrice}€",
                  textAlign: TextAlign.center),
              Text("Type de 1ère Page : ${widget.premierepagePrice}€",
                  textAlign: TextAlign.center),
              Text("Type de Finition : ${widget.finitionPrice}€",
                  textAlign: TextAlign.center),
              Text("Type de Couverture : ${widget.couverturePrice}€",
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                "Code promo ${currentPromoCode.toUpperCase()} : ${(-montantReduction).toStringAsFixed(2)}€",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "Prix Total : ${widget.totalPrice.toStringAsFixed(2)}€",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: codePromoController,
                      decoration:
                          const InputDecoration(labelText: 'Code Promo'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: applyPromoCode,
                    child: const Text("Appliquer"),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 12.0),
              ),
              Text(
                successMessage,
                style: const TextStyle(color: Colors.green, fontSize: 12.0),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: isAllFieldsFilled() ? () {} : null,
                child: const Text("Commander et Payer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
