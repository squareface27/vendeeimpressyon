import 'package:flutter/material.dart';
import 'package:vendeeimpressyon/colors.dart';

class Vacance extends StatelessWidget {
  const Vacance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Image.asset(
              'lib/assets/images/vacance.png',
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
            ),
            const Positioned(
              top: 0,
              bottom: -350,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "L'application est indisponible",
                  style: TextStyle(
                    color: black,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
