import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/contact_model.dart';
import '../theme/cyber_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.contacts,
    required this.onNavigateToContacts,
  });

  final List<ContactModel> contacts;
  final VoidCallback onNavigateToContacts;

  static const String studentName = 'Alif Satria Raghib';
  static const String studentNpm = '714240005';
  static const String studentClass = '3A – D4 Teknik Informatika';

  @override
  Widget build(BuildContext context) {
    final int totalContacts = contacts.length;
    final int imageContacts = contacts
        .where((ContactModel c) => c.file.isImageExtension)
        .length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildUlbiHeroBanner(),
          const SizedBox(height: 18),
          const CyberSectionHeader(
            subtitle: '// OPERATOR_IDENTITY',
            title: 'Profil Mahasiswa',
            accentColor: CyberColors.neonCyan,
          ),
          const SizedBox(height: 10),
          _buildStudentIdentityCard(),
          const SizedBox(height: 20),
          const CyberSectionHeader(
            subtitle: '// LIVE_TELEMETRY',
            title: 'Status Data Kontak',
            accentColor: CyberColors.neonPurple,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  label: 'TOTAL KONTAK',
                  value: '$totalContacts',
                  icon: Icons.contacts_rounded,
                  accentColor: CyberColors.neonRed,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatTile(
                  label: 'GAMBAR (JPG/PNG)',
                  value: '$imageContacts',
                  icon: Icons.image_outlined,
                  accentColor: CyberColors.neonCyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const CyberSectionHeader(
            subtitle: '// SYSTEM_MODULES',
            title: 'Akses Cepat & Fitur',
            accentColor: CyberColors.neonRed,
          ),
          const SizedBox(height: 10),
          _buildSystemModulesCard(),
        ],
      ),
    );
  }

  Widget _buildUlbiHeroBanner() {
    return CyberCard(
      borderColor: CyberColors.neonRed,
      cutSize: 14,
      glowOpacity: 0.22,
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 3.5,
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
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: CyberColors.neonRed,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: CyberColors.neonRed.withValues(alpha: 0.35),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(4),
                      child: ClipOval(
                        child: Image.asset(
                          'image/logo_ulbi.jpg',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.hub_rounded,
                            color: CyberColors.neonRedSoft,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'ULBI',
                                style: TextStyle(
                                  fontFamily: 'Oxanium',
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2.5,
                                  color: CyberColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: CyberColors.neonGreen.withValues(
                                    alpha: 0.12,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: CyberColors.neonGreen.withValues(
                                      alpha: 0.7,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'SYS.ONLINE',
                                  style: TextStyle(
                                    fontFamily: 'Oxanium',
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: CyberColors.neonGreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Universitas Logistik dan Bisnis Internasional',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: CyberColors.neonRedSoft,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CyberColors.bgInput.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: CyberColors.borderDim),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat Datang di ULBI Cyber Contact Hub',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: CyberColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Aplikasi pengelolaan daftar kontak berbasis Flutter untuk Asesmen Tengah Semester Pemrograman IV dengan antarmuka Neon Futuristic.',
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.45,
                          color: CyberColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentIdentityCard() {
    return CyberCard(
      borderColor: CyberColors.neonCyan,
      cutSize: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 58,
                height: 58,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(
                      color: CyberColors.neonCyan,
                      width: 1.3,
                    ),
                  ),
                ),
                child: Image.asset(
                  'image/profil.webp',
                  width: 58,
                  height: 58,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    decoration: ShapeDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          CyberColors.neonRed.withValues(alpha: 0.85),
                          CyberColors.neonPurple.withValues(alpha: 0.85),
                        ],
                      ),
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'ASR',
                      style: TextStyle(
                        fontFamily: 'Oxanium',
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'NAMA MAHASISWA',
                      style: TextStyle(
                        fontFamily: 'Oxanium',
                        fontSize: 10,
                        letterSpacing: 1.4,
                        color: CyberColors.neonCyan,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      studentName,
                      style: TextStyle(
                        fontFamily: 'Oxanium',
                        fontSize: 18.5,
                        fontWeight: FontWeight.w800,
                        color: CyberColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: CyberColors.neonRed.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: CyberColors.neonRed.withValues(alpha: 0.8),
                        ),
                      ),
                      child: const Text(
                        'NPM: $studentNpm',
                        style: TextStyle(
                          fontFamily: 'Oxanium',
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                          color: CyberColors.neonRedSoft,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: CyberColors.borderDim, height: 1),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(
                child: _IdentityMetaItem(
                  icon: Icons.school_outlined,
                  label: 'KELAS / PRODI',
                  value: studentClass,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _IdentityMetaItem(
                  icon: Icons.code_rounded,
                  label: 'MATA KULIAH',
                  value: 'Pemrograman IV',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSystemModulesCard() {
    final ContactModel? latestContact = contacts.isNotEmpty
        ? contacts.last
        : null;

    return CyberCard(
      borderColor: CyberColors.neonPurple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _CyberChip(label: 'CRUD Kontak', color: CyberColors.neonRedSoft),
              _CyberChip(label: 'Validasi Ketat', color: CyberColors.neonCyan),
              _CyberChip(
                label: 'Date & Color Picker',
                color: CyberColors.neonPurple,
              ),
              _CyberChip(
                label: 'File Picker & Preview',
                color: CyberColors.neonGreen,
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (latestContact != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CyberColors.bgInput,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: latestContact.color.withValues(alpha: 0.7),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 36,
                    decoration: BoxDecoration(
                      color: latestContact.color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'KONTAK TERAKHIR DITAMBAHKAN',
                          style: TextStyle(
                            fontFamily: 'Oxanium',
                            fontSize: 10,
                            color: CyberColors.neonCyan,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${latestContact.name} • ${latestContact.phoneNumber}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: CyberColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Tanggal: ${DateFormat('dd-MM-yyyy').format(latestContact.date)} | Berkas: ${latestContact.file.fileName}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: CyberColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ] else ...[
            const Text(
              'Belum ada kontak dalam sesi ini. Buka halaman Daftar Kontak untuk menambahkan data baru melalui formulir.',
              style: TextStyle(
                fontSize: 12.5,
                color: CyberColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onNavigateToContacts,
              style: ElevatedButton.styleFrom(
                backgroundColor: CyberColors.neonRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                shadowColor: CyberColors.neonRed.withValues(alpha: 0.6),
              ),
              icon: const Icon(Icons.contact_phone_rounded, size: 19),
              label: const Text(
                'BUKA HALAMAN DAFTAR KONTAK',
                style: TextStyle(
                  fontFamily: 'Oxanium',
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IdentityMetaItem extends StatelessWidget {
  const _IdentityMetaItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: CyberColors.neonCyan),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Oxanium',
                  fontSize: 9.5,
                  letterSpacing: 1.1,
                  color: CyberColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: CyberColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return CyberCard(
      borderColor: accentColor,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      cutSize: 8,
      glowOpacity: 0.12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Oxanium',
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: CyberColors.textPrimary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Oxanium',
              fontSize: 9.5,
              letterSpacing: 0.6,
              color: CyberColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CyberChip extends StatelessWidget {
  const _CyberChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color.withValues(alpha: 0.55)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
