import 'package:fida/screens/change_password_screen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14183e), // Arka plan lacivert
      appBar: AppBar(
        backgroundColor: const Color(0xFF14183e),
        elevation: 0,
        title: const Text(
          "Profilim",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            // ----------------- Profil Fotoğrafı -----------------
            CircleAvatar(
              radius: 60,
              backgroundColor: const Color(0xFF9c1132),
              child: const CircleAvatar(
                radius: 55,
                backgroundImage: AssetImage("assets/images/profile.jpg"),
              ),
            ),

            const SizedBox(height: 15),

            // ----------------- İsim -----------------
            const Text(
              "Batuhan Seyrek",
              style: TextStyle(
                fontSize: 23,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "batuhan@example.com",
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),

            const SizedBox(height: 25),

            // ----------------- Kişisel Bilgiler Başlığı -----------------
            _buildSectionTitle("Kişisel Bilgiler"),

            _buildInfoCard(label: "İsim", value: "Batuhan Seyrek"),
            _buildInfoCard(label: "E-posta", value: "batuhan@example.com"),
            _buildInfoCard(label: "Telefon", value: "+90 5XX XXX XX XX"),
            _buildInfoCard(label: "Doğum Tarihi", value: "01.01.2000"),
            _buildInfoCard(label: "Adres", value: "Kırklareli / Türkiye"),

            const SizedBox(height: 30),

            // ----------------- Güvenlik -----------------
            _buildSectionTitle("Güvenlik"),

            _buildPasswordCard(context), // Şifre değiştirme yönlendirmesi
            _buildSimpleCard(Icons.fingerprint, "Güvenlik Ayarları"),

            const SizedBox(height: 30),

            // ----------------- Çıkış butonu -----------------
            _buildLogoutCard(),

            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }

  // --------- BÖLÜM BAŞLIĞI -----------
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 21,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // --------- KİŞİSEL BİLGİ KARTI -----------
  Widget _buildInfoCard({required String label, required String value}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1b2255),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Text(
            "$label:",
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------- ŞİFRE DEĞİŞTİR (TIKLANABİLİR KART) -----------
  Widget _buildPasswordCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1b2255),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Row(
          children: [
            Icon(Icons.lock, color: Colors.white, size: 24),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                "Şifre Değiştir",
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 18),
          ],
        ),
      ),
    );
  }

  // --------- BASİT AYAR KARTI -----------
  Widget _buildSimpleCard(IconData icon, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1b2255),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 17),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 18),
        ],
      ),
    );
  }

  // --------- ÇIKIŞ BUTONU -----------
  Widget _buildLogoutCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF9c1132),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.logout, color: Colors.white, size: 22),
          SizedBox(width: 10),
          Text(
            "Çıkış Yap",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
