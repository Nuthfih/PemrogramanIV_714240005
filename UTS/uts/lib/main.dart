import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/contact_model.dart';
import 'screens/contact_screen.dart';
import 'screens/home_screen.dart';
import 'theme/cyber_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: CyberColors.bgSurface,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UTS Pemrograman IV - CyberContact',
      debugShowCheckedModeBanner: false,
      theme: CyberTheme.darkTheme,
      home: const MainShellScreen(),
    );
  }
}

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _selectedIndex = 0;
  final List<ContactModel> _contacts = <ContactModel>[];

  void _addContact(ContactModel contact) {
    setState(() {
      _contacts.add(contact);
    });
  }

  void _updateContact(int index, ContactModel updatedContact) {
    setState(() {
      _contacts[index] = updatedContact;
    });
  }

  void _deleteContact(int index) {
    setState(() {
      _contacts.removeAt(index);
    });
  }

  void _switchTab(int index) {
    if (_selectedIndex == index) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool onHome = _selectedIndex == 0;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: CyberColors.neonRed.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: CyberColors.neonRed),
              ),
              child: const Text(
                'UTS',
                style: TextStyle(
                  fontFamily: 'Oxanium',
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: CyberColors.neonRedSoft,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                onHome ? 'Cyber Hub // Home' : 'Daftar Kontak',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Oxanium',
                  fontSize: 17.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: CyberColors.neonCyan.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: CyberColors.neonCyan.withValues(alpha: 0.55),
                  ),
                ),
                child: Text(
                  '${_contacts.length} Kontak',
                  style: const TextStyle(
                    fontFamily: 'Oxanium',
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: CyberColors.neonCyan,
                  ),
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(
            height: 2,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  CyberColors.neonRed,
                  CyberColors.neonPurple,
                  CyberColors.neonCyan,
                ],
              ),
            ),
          ),
        ),
      ),
      body: CyberGridBackground(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            HomeScreen(
              contacts: _contacts,
              onNavigateToContacts: () => _switchTab(1),
            ),
            ContactScreen(
              contacts: _contacts,
              onAddContact: _addContact,
              onUpdateContact: _updateContact,
              onDeleteContact: _deleteContact,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: CyberColors.bgSurface,
          border: const Border(
            top: BorderSide(color: CyberColors.borderDim, width: 1.2),
          ),
          boxShadow: [
            BoxShadow(
              color: CyberColors.neonRed.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _switchTab,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: CyberColors.neonRedSoft,
          unselectedItemColor: CyberColors.textSecondary,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'Oxanium',
            fontWeight: FontWeight.w800,
            fontSize: 12,
            letterSpacing: 0.5,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Oxanium',
            fontSize: 11.5,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contact_page_outlined),
              activeIcon: Icon(Icons.contact_page_rounded),
              label: 'Daftar Kontak',
            ),
          ],
        ),
      ),
    );
  }
}
