import 'package:fida/providers/AuthProvider.dart';
import 'package:fida/providers/expense_provider.dart';
import 'package:fida/providers/ExpenseProvider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 1. Provider paketini ekledik
import 'screens/login_screen.dart';

void main() {
  runApp(
    // 3. MultiProvider ile uygulamayı sarmalıyoruz ki Consumer hata vermesin
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseeProvider()),
      ],
      child: const FidaApp(),
    ),
  );
}

class FidaApp extends StatelessWidget {
  const FidaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fida',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00695C)),
        useMaterial3: true,
      ),
      // Uygulama artık LoginPage ile başlıyor ve yukarıdaki AuthProvider'ı görüyor
      home: const LoginPage(),
    );
  }
}
