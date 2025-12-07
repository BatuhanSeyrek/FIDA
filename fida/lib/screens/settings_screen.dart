import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF14183e),
      appBar: AppBar(
        backgroundColor: Color(0xFF14183e),
        title: Text("Ayarlar", style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Text("Ayarlar Sayfası", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
