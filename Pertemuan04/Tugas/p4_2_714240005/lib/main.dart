import 'package:flutter/material.dart';

void main() {
  runApp(const BoxApp());
}

class BoxApp extends StatelessWidget {
  const BoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas Pertemuan 4',
      theme: ThemeData(useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const double gap = 16;
  static const double smallBoxWidth = 140;
  static const double smallBoxHeight = 180;
  static const double bigBoxWidth = smallBoxWidth * 2 + gap;
  static const double bigBoxHeight = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: const Text(
          'Tugas Pertemuan 4',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: bigBoxWidth,
              height: bigBoxHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Text(
                'Box 1',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: gap),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: smallBoxWidth,
                  height: smallBoxHeight,
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 4),
                  ),
                  child: const Text(
                    'Box 2',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: gap),

                Container(
                  width: smallBoxWidth,
                  height: smallBoxHeight,
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Box 3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}