import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uts/main.dart';
import 'package:uts/models/contact_model.dart';
import 'package:uts/screens/contact_screen.dart';
import 'package:uts/utils/validators.dart';

// Sampel gambar PNG 1x1 transparan yang valid untuk menguji pratinjau gambar
final Uint8List _samplePngBytes = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
);

void main() {
  group('Validasi Nama (Ketentuan 3b)', () {
    test('Menolak nama kosong atau hanya spasi', () {
      expect(ContactValidators.validateName(''), isNotNull);
      expect(ContactValidators.validateName('   '), isNotNull);
    });

    test('Menolak nama kurang dari dua kata termasuk spasi tepi', () {
      expect(ContactValidators.validateName('Alif'), isNotNull);
      expect(ContactValidators.validateName('  Alif  '), isNotNull);
    });

    test('Menolak angka atau karakter khusus', () {
      expect(ContactValidators.validateName('Alif Satria 123'), isNotNull);
      expect(ContactValidators.validateName('Alif-Satria'), isNotNull);
    });

    test('Menolak kata yang tidak dimulai huruf kapital', () {
      expect(ContactValidators.validateName('alif satria'), isNotNull);
      expect(ContactValidators.validateName('Alif satria'), isNotNull);
    });

    test('Menerima nama valid minimal 2 kata berawalan kapital', () {
      expect(ContactValidators.validateName('Alif Satria'), isNull);
      expect(ContactValidators.validateName('  Alif Satria Raghib  '), isNull);
    });
  });

  group('Validasi Nomor Telepon (Ketentuan 3c)', () {
    test('Menolak tanda +, huruf, dan awalan selain 62', () {
      expect(ContactValidators.validatePhone('+62812345678'), isNotNull);
      expect(ContactValidators.validatePhone('08123456789'), isNotNull);
      expect(ContactValidators.validatePhone('62812abc789'), isNotNull);
    });

    test('Menolak panjang di luar rentang 8-13 digit', () {
      expect(ContactValidators.validatePhone('6281234'), isNotNull); // 7 digit
      expect(
        ContactValidators.validatePhone('62812345678901'),
        isNotNull,
      ); // 14 digit
    });

    test('Menerima nomor telepon valid 8-13 digit berawalan 62', () {
      expect(ContactValidators.validatePhone('62812345'), isNull); // 8 digit
      expect(
        ContactValidators.validatePhone('6281234567890'),
        isNull,
      ); // 13 digit
    });
  });

  testWidgets('Menampilkan halaman Home dengan Nama & NPM serta navigasi', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // Pastikan Nama dan NPM tampil pada halaman Home (Ketentuan 1a)
    expect(find.text('Alif Satria Raghib'), findsOneWidget);
    expect(find.text('NPM: 714240005'), findsOneWidget);

    // Pindah ke halaman Daftar Kontak melalui BottomNavigationBar
    await tester.tap(find.text('Daftar Kontak'));
    await tester.pumpAndSettle();

    expect(find.text('Formulir Kontak Baru'), findsOneWidget);
    expect(find.text('SUBMIT'), findsOneWidget);

    // Submit dalam keadaan kosong wajib memunculkan SnackBar validasi (Ketentuan 3a)
    await tester.ensureVisible(find.text('SUBMIT'));
    await tester.tap(find.text('SUBMIT'));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('Menampilkan ListView, Ubah kontak, dan Dialog Konfirmasi Hapus', (
    WidgetTester tester,
  ) async {
    final List<ContactModel> contacts = <ContactModel>[
      ContactModel(
        id: '1',
        name: 'Budi Santoso',
        phoneNumber: '628123456789',
        date: DateTime(2026, 11, 7),
        color: const Color(0xFFFF1744),
        file: PickedFileData(
          fileName: 'avatar.png',
          extension: 'png',
          imageBytes: _samplePngBytes,
        ),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Scaffold(
              body: ContactScreen(
                contacts: contacts,
                onAddContact: (ContactModel c) => setState(() => contacts.add(c)),
                onUpdateContact: (int i, ContactModel c) =>
                    setState(() => contacts[i] = c),
                onDeleteContact: (int i) => setState(() => contacts.removeAt(i)),
              ),
            );
          },
        ),
      ),
    );

    // Ketentuan 2a: Menampilkan nama, telepon, tanggal dd-MM-yyyy, berkas, & pratinjau gambar
    expect(find.text('Budi Santoso'), findsOneWidget);
    expect(find.text('628123456789'), findsOneWidget);
    expect(find.text('07-11-2026'), findsOneWidget);
    expect(find.text('avatar.png'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);

    // Ketentuan 2c: Tekan tombol Ubah -> nilai dimuat ke form & simpan tanpa duplikasi
    await tester.ensureVisible(find.byTooltip('Ubah Kontak'));
    await tester.tap(find.byTooltip('Ubah Kontak'));
    await tester.pumpAndSettle();

    expect(find.text('SIMPAN PERUBAHAN'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Name (Nama Lengkap)'),
      'Budi Pratama',
    );
    await tester.ensureVisible(find.text('SIMPAN PERUBAHAN'));
    await tester.tap(find.text('SIMPAN PERUBAHAN'));
    await tester.pumpAndSettle();

    expect(contacts.length, 1);
    expect(find.text('Budi Pratama'), findsOneWidget);

    // Ketentuan 2d: Tekan tombol Hapus -> wajib tampil dialog konfirmasi
    await tester.ensureVisible(find.byTooltip('Hapus Kontak'));
    await tester.tap(find.byTooltip('Hapus Kontak'));
    await tester.pumpAndSettle();

    expect(find.text('Konfirmasi Hapus'), findsOneWidget);
    await tester.tap(find.text('HAPUS'));
    await tester.pumpAndSettle();

    expect(contacts, isEmpty);
    expect(find.text('BELUM ADA DATA KONTAK'), findsOneWidget);
  });
}
