import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vendeeimpressyon/pages/shop/product.dart';

class SousCategorie {
  final String name;
  final double prix;
  final String image;
  final String categorieid;

  SousCategorie(this.name, this.prix, this.image, this.categorieid);
}

class SousCategoriePage extends StatefulWidget {
  final String categoryName;
  final String email;

  SousCategoriePage(this.categoryName, this.email);

  @override
  _SousCategoriePageState createState() => _SousCategoriePageState();
}

class _SousCategoriePageState extends State<SousCategoriePage> {
  List<SousCategorie> souscategories = [];
  List<SousCategorie> selectedCategoryArticles = [];

  final apiUrl = dotenv.env['API_URL_GET_SOUSCATEGORIES']!;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final categoryName = widget.categoryName;
      final filteredArticles = List<SousCategorie>.from(data.map((item) =>
          SousCategorie(item['name'], item['unitprice'].toDouble(),
              item['image'], item['categorieid'])));

      selectedCategoryArticles = filteredArticles
          .where((article) => article.categorieid == categoryName)
          .toList();

      setState(() {
        souscategories = selectedCategoryArticles;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryName = widget.categoryName;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendée Impress\'Yon'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Nos produits',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
          Expanded(
            child: GridView.extent(
              maxCrossAxisExtent: 180,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: selectedCategoryArticles.map((article) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProductPage(
                          name: article.name,
                          prix: article.prix,
                          image: article.image,
                          categorieid: article.categorieid,
                          email: widget.email,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Image.network(
                          article.image,
                          fit: BoxFit.cover,
                          height: 150.0,
                        ),
                        Text(
                          article.name,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
