import 'package:flutter/material.dart';

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
  final double totalPrice;

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
  bool isAllFieldsFilled() {
    return widget.numberOfPages > 0 && widget.pdfFileName.isNotEmpty;
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
              const SizedBox(height: 16),
              Text(
                "Prix Total : ${widget.totalPrice.toStringAsFixed(2)}€",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
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
