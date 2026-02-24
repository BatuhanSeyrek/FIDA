import 'package:fida/providers/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF14183e),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  children: [
                    const Text(
                      'YENİ HESAP',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),

                    _inputBox(_nameController, 'Kullanıcı Adı', Icons.person),
                    const SizedBox(height: 15),
                    _inputBox(_emailController, 'Email', Icons.email),
                    const SizedBox(height: 15),
                    _inputBox(_phoneController, 'Telefon', Icons.phone),
                    const SizedBox(height: 15),
                    _inputBox(
                      _passController,
                      'Şifre',
                      Icons.lock,
                      isPass: true,
                    ),

                    const SizedBox(height: 30),

                    GestureDetector(
                      onTap:
                          auth.isLoading
                              ? null
                              : () async {
                                bool success = await auth.register(
                                  _nameController.text,
                                  _emailController.text,
                                  _passController.text,
                                  _phoneController.text,
                                );
                                if (success && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Kayıt Başarılı!"),
                                    ),
                                  );
                                  Navigator.pop(context); // Login'e geri dön
                                }
                              },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9c1132),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child:
                              auth.isLoading
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : const Text(
                                    'KAYIT OL',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _inputBox(
    TextEditingController ctrl,
    String hint,
    IconData icon, {
    bool isPass = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: ctrl,
        obscureText: isPass,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFF14183e)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
        ),
      ),
    );
  }
}
