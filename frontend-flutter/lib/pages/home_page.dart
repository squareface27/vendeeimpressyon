import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Category {
  final String name;
  final String image;

  Category(this.name, this.image);
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Category> categories = [];

  final apiUrl = dotenv.env['API_URL_GET_CATEGORIES']!;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        categories = List<Category>.from(
            data.map((item) => Category(item['name'], item['image'])));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendée Impress\'Yon'),
      ),
      body: GridView.extent(
        maxCrossAxisExtent: 180,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        children: categories.map((category) {
          return Card(
            child: Column(
              children: [
                Image.network(
                  category.image,
                  fit: BoxFit.cover,
                  height: 150.0,
                ),
                Text(
                  category.name,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
