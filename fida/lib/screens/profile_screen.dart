import 'package:fida/core/secure_stroge.dart';
import 'package:fida/models/UserModel.dart';
import 'package:fida/providers/UserProvider.dart';
import 'package:fida/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const colorBg = Color(0xFF14183e);
  static const colorPrimary = Color(0xFF9c1132);

  @override
  void initState() {
    super.initState();
    _initUserData();
  }

  Future<void> _initUserData() async {
    final token = await SecureStorage().readToken();
    if (token != null && mounted) {
      context.read<UserProvider>().loadUserData(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;

    return Scaffold(
      backgroundColor: colorBg,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.5, -0.6),
                radius: 1.3,
                colors: [Color(0xFF1E2452), colorBg],
              ),
            ),
          ),
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorPrimary.withOpacity(0.08),
              ),
            ),
          ),
          SafeArea(
            child:
                userProvider.isLoading && user == null
                    ? const Center(
                      child: CircularProgressIndicator(color: colorPrimary),
                    )
                    : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          _buildProfileHeader(user),
                          const SizedBox(height: 40),
                          _sectionTitle("KİŞİSEL BİLGİLER"),
                          const SizedBox(height: 15),
                          _buildEditableItem(
                            icon: Icons.person_outline_rounded,
                            label: "Kullanıcı Adı",
                            value: user?.userName ?? "Yükleniyor...",
                            onTap:
                                () => _showEditSheet(
                                  "Kullanıcı Adı",
                                  user?.userName,
                                  (v) => _handleUpdate(name: v),
                                ),
                          ),
                          _buildEditableItem(
                            icon: Icons.email_outlined,
                            label: "E-posta Adresi",
                            value: user?.email ?? "Yükleniyor...",
                            onTap:
                                () => _showEditSheet(
                                  "E-posta",
                                  user?.email,
                                  (v) => _handleUpdate(email: v),
                                ),
                          ),
                          _buildEditableItem(
                            icon: Icons.phone_android_rounded,
                            label: "Telefon Numarası",
                            value: user?.phoneNumber ?? "Belirtilmemiş",
                            onTap:
                                () => _showEditSheet(
                                  "Telefon",
                                  user?.phoneNumber,
                                  (v) => _handleUpdate(phone: v),
                                ),
                          ),
                          const SizedBox(height: 30),
                          _sectionTitle("GÜVENLİK VE AYARLAR"),
                          const SizedBox(height: 15),
                          _buildActionItem(
                            Icons.lock_reset_rounded,
                            "Şifreyi Değiştir",
                            () => _showEditSheet(
                              "Yeni Şifre",
                              "",
                              (v) => _handleUpdate(password: v),
                              isPassword: true,
                            ),
                          ),
                          _buildActionItem(
                            Icons.logout_rounded,
                            "Çıkış Yap",
                            () => _handleLogout(),
                            isDestructive: true,
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  // --- Widget Metotları ---

  Widget _buildProfileHeader(UserModel? user) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: colorPrimary.withOpacity(0.5), width: 2),
          ),
          child: const CircleAvatar(
            radius: 55,
            backgroundColor: Color(0xFF1b2255),
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
        ),
        const SizedBox(height: 15),
        Text(
          user?.userName ?? "",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          user?.email ?? "",
          style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildEditableItem({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Icon(icon, color: colorPrimary, size: 22),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.edit_note_rounded,
              color: Colors.white.withOpacity(0.2),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color:
              isDestructive
                  ? colorPrimary.withOpacity(0.1)
                  : Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isDestructive
                    ? colorPrimary.withOpacity(0.3)
                    : Colors.white.withOpacity(0.05),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? colorPrimary : Colors.white,
              size: 22,
            ),
            const SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                color: isDestructive ? colorPrimary : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right_rounded,
              color: isDestructive ? colorPrimary : Colors.white24,
            ),
          ],
        ),
      ),
    );
  }

  // --- Mantıksal Fonksiyonlar ---

  void _handleUpdate({
    String? name,
    String? email,
    String? phone,
    String? password,
  }) async {
    final provider = context.read<UserProvider>();
    final token = await SecureStorage().readToken();
    if (provider.user != null && token != null) {
      final updated = UserModel(
        id: provider.user!.id,
        userName: name ?? provider.user!.userName,
        email: email ?? provider.user!.email,
        phoneNumber: phone ?? provider.user!.phoneNumber,
        password: password, // Şifre artık sadece nesne içinde gidiyor
      );

      bool success = await provider.updateUserInfo(updated, token);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profil Güncellendi"),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _handleLogout() async {
    await SecureStorage().deleteToken();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  void _showEditSheet(
    String title,
    String? initialValue,
    Function(String) onSave, {
    bool isPassword = false,
  }) {
    final controller = TextEditingController(
      text: isPassword ? "" : initialValue,
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 25,
              left: 25,
              right: 25,
              top: 25,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF1b2255),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$title Güncelle",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller,
                  autofocus: true,
                  obscureText: isPassword,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    hintText: isPassword ? "Yeni şifre girin..." : null,
                    hintStyle: const TextStyle(color: Colors.white24),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorPrimary,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    onSave(controller.text);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "KAYDET",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white.withOpacity(0.3),
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
        ),
      ),
    );
  }
}
