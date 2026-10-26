import 'package:flutter/material.dart';

import 'detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final String nama = 'Alif Satria Raghib';
  final String npm = '714240005';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tugas Pertemuan 5'), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 32.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'images/profile.webp',
                      width: 170,
                      height: 170,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    nama,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Bangers',
                      fontSize: 30,
                      letterSpacing: 1.5,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'NPM: $npm',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailScreen(nama: nama, npm: npm),
                        ),
                      );
                    },
                    icon: const Icon(Icons.account_circle_outlined),
                    label: const Text(
                      'Lihat Detail Profil',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      elevation: 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
