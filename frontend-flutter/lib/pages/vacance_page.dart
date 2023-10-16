import 'package:flutter/material.dart';
import 'package:vendeeimpressyon/colors.dart';

class Vacance extends StatelessWidget {
  const Vacance({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Le mode vacance est activé !",
                style: TextStyle(
                  color: blue,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
