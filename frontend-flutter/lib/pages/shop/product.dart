import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  final String name;
  final String prix;
  final String image;
  final String description;

  ProductPage({
    required this.name,
    required this.prix,
    required this.image,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  height: 200.0,
                ),
              ),
              Text(
                'Prix: $prix',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
