import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:vendeeimpressyon/pages/shop/souscategorie.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductPage extends StatefulWidget {
  final String name;
  final double prix;
  final String image;
  final String description;
  final String categorieid;

  ProductPage({
    required this.name,
    required this.prix,
    required this.image,
    required this.description,
    required this.categorieid,
  });

  @override
  _ProductPageState createState() => _ProductPageState();
}

class ProductOptions {
  final String name;
  final double prix;
  final String categorieoptionname;
  final String categorieid;

  ProductOptions(
      this.name, this.prix, this.categorieoptionname, this.categorieid);
}

class _ProductPageState extends State<ProductPage> {
  List<ProductOptions> productoptions = [];

  String? selectedOption;
  String? selectedReliureOption;
  String? selectedPremierePageOption;
  String? selectedFinitionOption;

  bool isRectoVerso = false;

  bool isCouvertureCouleur = false;

  final apiUrl = dotenv.env['API_URL_GET_PRODUCTOPTIONS']!;

  @override
  void initState() {
    super.initState();
    fetchProductOptions();
  }

  Future<void> fetchProductOptions() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        productoptions = List<ProductOptions>.from(data
            .where((item) => item['categorieid'] == widget.categorieid)
            .map((item) => ProductOptions(
                "${item['name']} - +${item['prix']}€",
                item['prix'].toDouble(),
                item['categorieOptionName'],
                item['categorieid'])));
        productoptions.insert(
            0,
            ProductOptions(
                'Sélectionner un type de reliure', 0.0, 'Reliure', 'Rapport'));

        productoptions.insert(
            1,
            ProductOptions('Sélectionner un type de 1ère page', 0.0, '1erePage',
                'Rapport'));

        productoptions.insert(
            2,
            ProductOptions(
                'Sélectionner un type de finition', 0.0, 'Finition', 'Cours'));

        selectedOption = productoptions[0].name;
      });
    }
  }

  String selectedPdfPath = "";
  late PDFViewController pdfViewController;
  bool isPdfSelected = false;
  String selectedPdfFileName = "";

  TextEditingController numberOfPagesController = TextEditingController();
  double totalPrice = 0.0;
  double reliurePrice = 0.0;
  double premierepagePrice = 0.0;
  double finitionPrice = 0.0;

  double couvertureCouleurPrice = 9.0;
  double couvertureNoirEtBlancPrice = 7.0;
  double couverturePrice = 0.0;

  Future<void> pickAndProcessPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'odt'],
    );

    if (result != null) {
      String pdfPath = result.files.single.path!;
      setState(() {
        selectedPdfPath = pdfPath;
        isPdfSelected = pdfPath.endsWith('.pdf') ||
            pdfPath.endsWith('.docx') ||
            pdfPath.endsWith('.odt');
        selectedPdfFileName = selectedPdfPath.split('/').last;
      });
    }
  }

  void validateOrder() {}

  Widget buildDropdownReliure() {
    final filteredOptions = productoptions
        .where((option) =>
            option.categorieoptionname == "Reliure" &&
            option.categorieid == widget.categorieid)
        .toList();

    if (filteredOptions.isNotEmpty) {
      return DropdownButton<String>(
        value: selectedReliureOption ?? "Sélectionner un type de reliure",
        onChanged: (newOption) {
          setState(() {
            selectedReliureOption = newOption;
            final selectedProductOption = filteredOptions.firstWhere(
              (option) => option.name == newOption,
              orElse: () => ProductOptions("", 0.0, "", ""),
            );

            reliurePrice = selectedProductOption.prix;
          });
        },
        items: filteredOptions
            .map((option) => DropdownMenuItem<String>(
                  value: option.name,
                  child: Text(option.name),
                ))
            .toList(),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildDropdownPremierePage() {
    final filteredOptions = productoptions
        .where((option) =>
            option.categorieoptionname == "1erePage" &&
            option.categorieid == widget.categorieid)
        .toList();

    if (filteredOptions.isNotEmpty) {
      return DropdownButton<String>(
        value:
            selectedPremierePageOption ?? "Sélectionner un type de 1ère page",
        onChanged: (newOption) {
          setState(() {
            selectedPremierePageOption = newOption;
            final selectedProductOption = filteredOptions.firstWhere(
              (option) => option.name == newOption,
              orElse: () => ProductOptions("", 0.0, "", ""),
            );

            premierepagePrice = selectedProductOption.prix;
          });
        },
        items: filteredOptions
            .map((option) => DropdownMenuItem<String>(
                  value: option.name,
                  child: Text(option.name),
                ))
            .toList(),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildDropdownFinition() {
    final filteredOptions = productoptions
        .where((option) =>
            option.categorieoptionname == "Finition" &&
            option.categorieid == widget.categorieid)
        .toList();

    if (filteredOptions.isNotEmpty) {
      return DropdownButton<String>(
        value: selectedFinitionOption ?? "Sélectionner un type de finition",
        onChanged: (newOption) {
          setState(() {
            selectedFinitionOption = newOption;
            final selectedProductOption = filteredOptions.firstWhere(
              (option) => option.name == newOption,
              orElse: () => ProductOptions("", 0.0, "", ""),
            );

            reliurePrice = selectedProductOption.prix;
          });
        },
        items: filteredOptions
            .map((option) => DropdownMenuItem<String>(
                  value: option.name,
                  child: Text(option.name),
                ))
            .toList(),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget radioCouverture() {
    if (!isCouvertureCouleur) {
      couverturePrice = couvertureNoirEtBlancPrice;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Couverture n/b 7€"),
        Radio(
          value: false,
          groupValue: isCouvertureCouleur,
          onChanged: (value) {
            setState(() {
              isCouvertureCouleur = false;
              couverturePrice = couvertureNoirEtBlancPrice;
            });
          },
        ),
        const Text("Couverture couleur 9€"),
        Radio(
          value: true,
          groupValue: isCouvertureCouleur,
          onChanged: (value) {
            setState(() {
              isCouvertureCouleur = true;
              couverturePrice = couvertureCouleurPrice;
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.network(
                  widget.image,
                  fit: BoxFit.cover,
                  height: 175.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.description,
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Visibility(
                            visible: isPdfSelected,
                            child: ElevatedButton(
                              onPressed: pickAndProcessPdf,
                              child: const Text("Sélectionner un PDF"),
                            ),
                          ),
                        ),
                        if (isPdfSelected)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PdfViewPage(selectedPdfPath),
                                  ),
                                );
                              },
                              child: const Text("Voir le PDF"),
                            ),
                          ),
                        if (!isPdfSelected)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                pickAndProcessPdf();
                              },
                              child: const Text("Sélectionner un fichier"),
                            ),
                          ),
                      ],
                    ),
                    if (isPdfSelected)
                      Text(
                        "Fichier sélectionné : $selectedPdfFileName",
                        style: const TextStyle(fontSize: 12),
                      ),
                  ],
                ),
              ),
              TextField(
                controller: numberOfPagesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Nombre de pages",
                ),
                onChanged: (value) {
                  setState(() {
                    int numberOfPages = int.tryParse(value) ?? 0;
                    double unitPrice = widget.prix;
                    totalPrice = numberOfPages * unitPrice;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Recto"),
                  Radio(
                    value: false,
                    groupValue: isRectoVerso,
                    onChanged: (value) {
                      setState(() {
                        isRectoVerso = false;
                      });
                    },
                  ),
                  const Text("Recto/Verso"),
                  Radio(
                    value: true,
                    groupValue: isRectoVerso,
                    onChanged: (value) {
                      setState(() {
                        isRectoVerso = true;
                      });
                    },
                  ),
                ],
              ),
              if (productoptions
                  .any((option) => option.categorieoptionname == "Reliure"))
                buildDropdownReliure(),
              if (productoptions
                  .any((option) => option.categorieoptionname == "1erePage"))
                buildDropdownPremierePage(),
              if (productoptions
                  .any((option) => option.categorieoptionname == "Finition"))
                buildDropdownFinition(),
              if (productoptions
                  .any((option) => option.categorieid == "Thèses & Mémoires"))
                radioCouverture(),
              Text(
                "Prix total = ${(totalPrice + reliurePrice + premierepagePrice + finitionPrice + couverturePrice).toStringAsFixed(2)}€",
                style: const TextStyle(fontSize: 16),
              ),
              ElevatedButton(
                onPressed: validateOrder,
                child: const Text("Valider la commande"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PdfViewPage extends StatelessWidget {
  final String pdfPath;

  PdfViewPage(this.pdfPath);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Visualisation du PDF"),
      ),
      body: PDFView(
        filePath: pdfPath,
        onViewCreated: (PDFViewController vc) {},
      ),
    );
  }
}
