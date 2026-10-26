import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String nama;
  final String npm;

  const DetailScreen({super.key, required this.nama, required this.npm});

  final List<String> galleryImages = const [
    'images/gallery1.webp',
    'images/gallery2.webp',
    'images/gallery3.webp',
    'images/gallery4.jpg',
    'images/gallery5.jpg',
    'images/gallery6.webp',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Profil'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'images/profile.webp',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      nama,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Bangers',
                        fontSize: 28,
                        letterSpacing: 1.2,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'NPM: $npm',
                        style: TextStyle(
                          fontFamily: 'Bangers',
                          fontSize: 18,
                          letterSpacing: 1.0,
                          color: Colors.indigo.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Card Deskripsi Singkat: Minat & Hobi
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person_pin,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Tentang Saya & Minat',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    const Text(
                      'Alif Satria Raghib atau akrab di panggil Leaf adalah mahasiswa Universitas Logistik dan Bisnis Internasional (ULBI) yang menempuh program studi D4 Teknik Informatika. Sekarang ia sudah menempuh semester 5. Ia memiliki hobi bermain game, coding, menjelajah dunia anime dan manga, serta cosplay.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Hobi & Minat:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildChip(Icons.sports_esports_outlined, 'Gaming'),
                        _buildChip(Icons.code, 'Coding'),
                        _buildChip(Icons.tv_outlined, 'Anime & Manga'),
                        _buildChip(Icons.theater_comedy, 'Cosplay'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.photo_library_outlined,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Gallery Aktivitas',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: 170,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: galleryImages.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                galleryImages[index],
                                width: 150,
                                height: 170,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text(
                'Kembali',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Colors.indigo, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 16, color: Colors.indigo),
      label: Text(label),
      backgroundColor: Colors.indigo.shade50,
      side: BorderSide(color: Colors.indigo.shade100),
      labelStyle: TextStyle(
        fontSize: 12,
        color: Colors.indigo.shade900,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
