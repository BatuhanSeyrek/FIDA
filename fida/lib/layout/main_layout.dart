import 'package:fida/screens/add_expense_screen.dart';
import 'package:fida/screens/chat_bot_screen.dart';
import 'package:fida/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/account_screen.dart';
import '../screens/settings_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  static const colorDarkBlue = Color(0xFF14183e);
  static const colorBordo = Color(0xFF9c1132);
  static const colorDarkBordo = Color(0xFF821034);

  final List<Widget> pages = [
    const HomeScreen(), // 0
    AddExpenseScreen(), // 1
    AccountScreen(), // 2
    const ChatBotScreen(), // 3 <- ÖZEL YENİ SAYFA
    const ProfileScreen(), // 4
    SettingsScreen(), // 5
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorDarkBlue,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: colorDarkBlue,
          currentIndex: _currentIndex,
          selectedItemColor: colorBordo,
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed,

          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 12),

          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },

          items: [
            BottomNavigationBarItem(
              icon: _navIcon(Icons.home, 0),
              label: "Ana Sayfa",
            ),
            BottomNavigationBarItem(
              icon: _navIcon(Icons.add_circle_outline, 1),
              label: "Harcama",
            ),
            BottomNavigationBarItem(
              icon: _navIcon(Icons.account_balance_wallet, 2),
              label: "Hesap",
            ),

            /// 📌 ÖZEL CHATBOT BUTONU
            BottomNavigationBarItem(
              icon: _navIcon(Icons.smart_toy_outlined, 3),
              label: "Asistan",
            ),

            BottomNavigationBarItem(
              icon: _navIcon(Icons.person, 4),
              label: "Profil",
            ),
          ],
        ),
      ),
    );
  }

  Widget _navIcon(IconData icon, int index) {
    bool isSelected = _currentIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? colorBordo.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        size: isSelected ? 30 : 26,
        color: isSelected ? colorBordo : Colors.white70,
      ),
    );
  }
}
