import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:vendeeimpressyon/pages/shop/success_page.dart';

class ResumePage extends StatefulWidget {
  final String productName;
  final String pdfFileName;
  final int numberOfPages;
  final int numberOfCopies;
  final double unitPrice;
  final bool isRectoVerso;
  final double reliurePrice;
  final double premierepagePrice;
  final double finitionPrice;
  final double couverturePrice;
  final double couleurCouverturePrice;
  final String premierepageName;
  final String couleurCouvertureName;
  final String reliureName;
  final String finitionName;
  final String couvertureName;
  final String couverturePapierName;
  final String selectedPdfPath;
  double totalPrice;
  final String email;
  final String categorieid;

  ResumePage({
    required this.productName,
    required this.pdfFileName,
    required this.numberOfPages,
    required this.numberOfCopies,
    required this.unitPrice,
    required this.isRectoVerso,
    required this.reliurePrice,
    required this.premierepagePrice,
    required this.finitionPrice,
    required this.couverturePrice,
    required this.couleurCouverturePrice,
    required this.couleurCouvertureName,
    required this.totalPrice,
    required this.email,
    required this.reliureName,
    required this.premierepageName,
    required this.finitionName,
    required this.couvertureName,
    required this.couverturePapierName,
    required this.selectedPdfPath,
    required this.categorieid,
  });

  @override
  _ResumePageState createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  Map<String, dynamic>? paymentIntent;
  Map<String, dynamic> fraisData = {};

  String errorMessage = "";
  String successMessage = "";

  double montantReduction = 0.0;
  double reductionCommandeInternet = 0.0;
  double fraisGestion = 0.0;

  int paymentCount = 0;

  bool isAllFieldsFilled() {
    return widget.numberOfPages > 0 && widget.pdfFileName.isNotEmpty;
  }

  final apiUrl = dotenv.env['API_URL_GET_CODEPROMO']!;
  final stripeBearerToken = dotenv.env['STRIPE_BEARER_TOKEN']!;

  final apiUrlCommandeInfos = dotenv.env['API_URL_POST_COMMANDE_INFOS']!;
  final apiUrlPdf = dotenv.env['API_URL_POST_PDF']!;

  TextEditingController codePromoController = TextEditingController();
  String promoCode = "";

  bool promoApplied = false;

  String currentPromoCode = "";
  double currentPromoAmount = 0;

  Future<void> fetchFraisData() async {
    final apiUrl = dotenv.env['API_URL_GET_FRAIS']!;
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> fraisList = json.decode(response.body);

      for (var frais in fraisList) {
        final String nom = frais['nom'];
        final double montant = frais['montant'].toDouble();
        fraisData[nom] = montant;
      }

      setState(() {
        reductionCommandeInternet = (widget.totalPrice *
                (fraisData["Réduction Commande Internet"] / 100))
            .toDouble();
        fraisGestion = fraisData["Frais de Gestion"].toDouble();
        widget.totalPrice =
            widget.totalPrice - reductionCommandeInternet + fraisGestion;
      });
    }
  }

  Future<void> uploadPdfToBackend() async {
    final pdfName = widget.pdfFileName;
    final selectedPdfPath = widget.selectedPdfPath;

    final data = {
      'pdfName': pdfName,
    };

    final jsonData = jsonEncode(data);

    if (selectedPdfPath.isNotEmpty) {
      try {
        var request = http.MultipartRequest('POST', Uri.parse(apiUrlPdf));
        request.fields['pdfName'] = pdfName;
        request.files.add(
          await http.MultipartFile.fromPath(
            'pdf',
            selectedPdfPath,
          ),
        );

        var response = await request.send();
        if (response.statusCode == 200) {
          print('Fichier PDF envoyé avec succès');
        } else {
          print(
              'Échec de l\'envoi du fichier PDF avec statut ${response.statusCode}');
          // Afficher le contenu de la réponse (pour débogage)
          final responseString = await response.stream.bytesToString();
          print('Réponse : $responseString');
        }
      } catch (e) {
        print('Erreur lors de l\'envoi du fichier PDF : $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    errorMessage = "";
    successMessage = "";

    fetchFraisData();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Produit : ${widget.productName}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Nombre de Pages : ${widget.numberOfPages} pages",
                      ),
                      Text(
                        "Recto/Verso : ${widget.isRectoVerso ? 'Oui' : 'Non'}",
                      ),
                      Text(
                        "Type de Reliure : ${widget.reliurePrice}€",
                      ),
                      Text(
                        "Type de 1ère Page : ${widget.premierepagePrice}€",
                      ),
                      Text(
                        "Type de Finition : ${widget.finitionPrice}€",
                      ),
                      Text(
                        "Type de Couverture : ${widget.couvertureName} ${widget.couverturePrice}€",
                      ),
                      Text(
                        "Couleur de Couverture : ${widget.couleurCouverturePrice}€",
                      ),
                      Text(
                        "Nombre d'exemplaires : ${widget.numberOfCopies}",
                      ),
                      Text(
                        "Fichier PDF : ${widget.pdfFileName}",
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Code promo ${currentPromoCode.toUpperCase()} : ${(-montantReduction).toStringAsFixed(2)}€",
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: codePromoController,
                              decoration: const InputDecoration(
                                  labelText: 'Code Promo'),
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
                        style:
                            const TextStyle(color: Colors.red, fontSize: 12.0),
                      ),
                      Text(
                        successMessage,
                        style: const TextStyle(
                            color: Colors.green, fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Réduction Commande Internet (${fraisData["Réduction Commande Internet"]}%) : -${reductionCommandeInternet.toStringAsFixed(2)}€",
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Frais de Gestion (${fraisData["Frais de Gestion"]}€)",
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Prix Total : ${widget.totalPrice.toStringAsFixed(2)}€",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: isAllFieldsFilled()
                            ? () async {
                                await makePayment();
                              }
                            : null,
                        child: const Text("Commander et Payer"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      final totalPriceString = (widget.totalPrice * 100).toStringAsFixed(0);
      paymentIntent = await createPaymentIntent(totalPriceString, 'EUR');

      var gpay = const PaymentSheetGooglePay(
          merchantCountryCode: "FR", currencyCode: "EUR", testEnv: true);

      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Vendée Impress\'Yon',
                  googlePay: gpay))
          .then((value) {});

      displayPaymentSheet();
    } catch (err) {
      print(err);
    }
  }

  void resetPaymentCount() {
    setState(() {
      paymentCount = 0;
    });
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => PaymentSuccessPage(
              email: widget.email,
              categorieid: widget.categorieid,
            ),
          ),
        );
        uploadPdfToBackend();
        paymentCount++;
        final pdfName = widget.pdfFileName;
        final productName = widget.productName;
        final totalPrice = widget.totalPrice;
        final nombreExemplaire = widget.numberOfCopies;
        final email = widget.email;
        final reliureName = widget.reliureName;
        final couleurCouvertureName = widget.couleurCouvertureName;
        final premierepageName = widget.premierepageName;
        final finitionName = widget.finitionName;
        final couvertureName = widget.couvertureName;
        final couverturePapierName = widget.couverturePapierName;
        final numberOfPages = widget.numberOfPages;
        final dateTimeNow =
            DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());

        final paymentInfo = {
          'id': paymentCount,
          'email': email,
          'productName': productName,
          'totalPrice': totalPrice,
          'date': dateTimeNow,
          'quantite': nombreExemplaire,
          'nombrePage': numberOfPages,
          'reliureName': reliureName,
          'couleurCouvertureName': couleurCouvertureName,
          'premierepageName': premierepageName,
          'finitionName': finitionName,
          'couvertureName': couvertureName,
          'couverturePapierName': couverturePapierName,
          'pdfName': pdfName,
        };

        final jsonData = json.encode(paymentInfo);

        final response = await http.post(Uri.parse(apiUrlCommandeInfos),
            headers: {'Content-Type': 'application/json'}, body: jsonData);

        if (response.statusCode == 200) {
          print('Données envoyées avec succès à votre API.');
        } else {
          print('Échec de l\'envoi des données à votre API.');
        }
      });
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $stripeBearerToken',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}
