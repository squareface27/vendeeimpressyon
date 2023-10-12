import 'package:flutter/material.dart';

class SousCategorie extends StatelessWidget {
  final String categoryName;

  SousCategorie(this.categoryName);

  @override
  Widget build(BuildContext context) {
    // Ici, vous devrez récupérer les articles de la catégorie sélectionnée
    // depuis votre API et les afficher dans un GridView, de manière similaire à votre page d'accueil.
    // Vous pouvez utiliser une méthode similaire à `fetchCategories` pour récupérer les articles de la catégorie.
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: Center(
        child: Text('Liste des articles de la catégorie $categoryName'),
      ),
    );
  }
}
