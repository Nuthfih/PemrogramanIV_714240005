import 'package:flutter_test/flutter_test.dart';
import 'package:p5_2_714240005/main.dart';

void main() {
  testWidgets('Mini Profile Card smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that AppBar title is rendered.
    expect(find.text('Tugas Pertemuan 5'), findsOneWidget);

    // Verify that student name and navigation button exist.
    expect(find.text('Alif Satria Raghib'), findsOneWidget);
    expect(find.text('Lihat Detail Profil'), findsOneWidget);
  });
}
