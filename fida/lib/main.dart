import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // 1. Yeni ekranı içeri aktar

void main() {
  runApp(const FidaApp());
}

class FidaApp extends StatelessWidget {
  const FidaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fida',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Finans için koyu teal (Zümrüt yeşili/Mavi karışımı) çok profesyonel durur
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00695C), // Profesyonel Fintech Rengi
        ),
        useMaterial3: true,
      ),
      home: LoginPage(), // 2. AnaSayfa yerine LoginScreen başlasın
    );
  }
}
