import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24.0),
      child: Column(
        children: [
          Text(
            'Settings Page',
            style: TextStyle(
                fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 100,
          ),
          CircleAvatar(
            radius: 70,
            child: Icon(
              Icons.settings,
              size: 120,
            ),
          ),
          SizedBox(
            height: 100,
          ),
          Text(
            'Settings Page Content',
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
