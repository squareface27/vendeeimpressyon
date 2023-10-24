import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:vendeeimpressyon/pages/shop/resume.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';

class ProductPage extends StatefulWidget {
  final String name;
  final double prix;
  final String image;
  final String categorieid;

  ProductPage({
    required this.name,
    required this.prix,
    required this.image,
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
  bool isAllFieldsFilled() {
    return (selectedPdfFileName.isNotEmpty &&
        numberOfPagesController.text.isNotEmpty);
  }

  List<ProductOptions> productoptions = [];

  String? selectedOption;
  String? selectedReliureOption;
  String? selectedPremierePageOption;
  String? selectedFinitionOption;
  String? selectedCouleurCouvertureOption;

  bool isRectoVerso = false;

  bool isCouvertureCouleur = false;

  bool isCouverturePapierIvoire = false;

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
            ProductOptions('Sélectionner une couleur de couverture', 0.0,
                'CouleurCouverture', 'Rapport'));

        productoptions.insert(
            2,
            ProductOptions('Sélectionner un type de 1ère page', 0.0, '1erePage',
                'Rapport'));

        productoptions.insert(
            3,
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
  TextEditingController numberOfCopiesController = TextEditingController();

  double totalPrice = 0.0;
  double reliurePrice = 0.0;
  double premierepagePrice = 0.0;
  double finitionPrice = 0.0;
  double couleurCouverturePrice = 0.0;

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

            finitionPrice = selectedProductOption.prix;
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

  Widget buildDropdownCouleurCouverture() {
    final filteredOptions = productoptions
        .where((option) =>
            option.categorieoptionname == "CouleurCouverture" &&
            option.categorieid == widget.categorieid)
        .toList();

    if (filteredOptions.isNotEmpty) {
      return DropdownButton<String>(
        value: selectedCouleurCouvertureOption ??
            "Sélectionner une couleur de couverture",
        onChanged: (newOption) {
          setState(() {
            selectedCouleurCouvertureOption = newOption;
            final selectedProductOption = filteredOptions.firstWhere(
              (option) => option.name == newOption,
              orElse: () => ProductOptions("", 0.0, "", ""),
            );

            couleurCouverturePrice = selectedProductOption.prix;
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

  Widget radioPapierCouverture() {
    const Text("Le papier de couverture est inclus");
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Papier blanc (défaut)"),
        Radio(
          value: false,
          groupValue: isCouverturePapierIvoire,
          onChanged: (value) {
            setState(() {
              isCouverturePapierIvoire = false;
            });
          },
        ),
        const Text("Papier Ivoire"),
        Radio(
          value: true,
          groupValue: isCouverturePapierIvoire,
          onChanged: (value) {
            setState(() {
              isCouverturePapierIvoire = true;
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
                  height: 160.0,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Nombre de pages : ",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: SizedBox(
                      width: 50,
                      child: TextField(
                        controller: numberOfPagesController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          hintText: "1",
                        ),
                        onChanged: (value) {
                          setState(() {
                            int numberOfPages = int.tryParse(value) ?? 0;
                            double unitPrice = widget.prix;
                            totalPrice = numberOfPages * unitPrice;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Recto",
                      style: TextStyle(
                        fontSize: 16,
                      )),
                  Radio(
                    value: false,
                    groupValue: isRectoVerso,
                    onChanged: (value) {
                      setState(() {
                        isRectoVerso = false;
                      });
                    },
                  ),
                  const Text("Recto/Verso",
                      style: TextStyle(
                        fontSize: 16,
                      )),
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
              buildDropdownCouleurCouverture(),
              if (productoptions
                  .any((option) => option.categorieoptionname == "1erePage"))
                buildDropdownPremierePage(),
              if (productoptions
                  .any((option) => option.categorieoptionname == "Finition"))
                buildDropdownFinition(),
              if (productoptions
                  .any((option) => option.categorieid == "Thèses & Mémoires"))
                radioCouverture(),
              if (productoptions
                  .any((option) => option.categorieid == "Thèses & Mémoires"))
                radioPapierCouverture(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Nombre d'exemplaires : ",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: SizedBox(
                      width: 50,
                      child: TextField(
                        controller: numberOfCopiesController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          hintText: "1",
                        ),
                        enabled: numberOfPagesController.text.isNotEmpty,
                        onChanged: (value) {
                          setState(() {
                            int numberOfPages =
                                int.tryParse(numberOfPagesController.text) ?? 0;
                            int numberOfCopies = int.tryParse(value) ?? 0;
                            double unitPrice = widget.prix;
                            if (numberOfCopies < 1) {
                              numberOfCopies = 1;
                              numberOfCopiesController.text = "1";
                            }
                            totalPrice =
                                numberOfPages * unitPrice * numberOfCopies;

                            if (numberOfPagesController.text.isEmpty) {
                              numberOfPages = 1;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                "Prix total = ${(totalPrice + reliurePrice + premierepagePrice + finitionPrice + couverturePrice).toStringAsFixed(2)}€",
                style: const TextStyle(fontSize: 16),
              ),
              ElevatedButton(
                onPressed: isAllFieldsFilled()
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResumePage(
                              productName: widget.name,
                              pdfFileName: selectedPdfFileName,
                              numberOfPages:
                                  int.tryParse(numberOfPagesController.text) ??
                                      0,
                              unitPrice: widget.prix,
                              isRectoVerso: isRectoVerso,
                              reliurePrice: reliurePrice,
                              numberOfCopies:
                                  int.tryParse(numberOfCopiesController.text) ??
                                      0,
                              premierepagePrice: premierepagePrice,
                              finitionPrice: finitionPrice,
                              couverturePrice: couverturePrice,
                              totalPrice: totalPrice +
                                  reliurePrice +
                                  premierepagePrice +
                                  finitionPrice +
                                  couverturePrice,
                            ),
                          ),
                        );
                      }
                    : null,
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
