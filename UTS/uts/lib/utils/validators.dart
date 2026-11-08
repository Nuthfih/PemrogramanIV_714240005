class ContactValidators {
  ContactValidators._();

  static String? validateName(String? value) {
    final String trimmed = (value ?? '').trim();

    if (trimmed.isEmpty) {
      return 'Nama wajib diisi.';
    }

    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(trimmed)) {
      return 'Nama hanya boleh mengandung huruf dan spasi.';
    }

    final List<String> words = trimmed.split(RegExp(r'\s+'));
    if (words.length < 2) {
      return 'Nama harus terdiri dari minimal 2 kata.';
    }

    final bool allStartWithCapital = words.every(
      (String word) => word.isNotEmpty && RegExp(r'^[A-Z]').hasMatch(word),
    );
    if (!allStartWithCapital) {
      return 'Setiap kata pada nama harus diawali huruf kapital.';
    }

    return null;
  }

  static String normalizeName(String value) {
    return value.trim().split(RegExp(r'\s+')).join(' ');
  }

  static String? validatePhone(String? value) {
    final String input = value ?? '';

    if (input.trim().isEmpty) {
      return 'Nomor telepon wajib diisi.';
    }

    if (input.startsWith('+')) {
      return 'Gunakan awalan 62 tanpa tanda + (contoh: 628123456789).';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(input)) {
      return 'Nomor telepon hanya boleh berisi digit angka 0-9.';
    }

    if (!input.startsWith('62')) {
      return 'Nomor telepon harus diawali dengan 62.';
    }

    if (input.length < 8 || input.length > 13) {
      return 'Panjang nomor telepon harus 8-13 digit (saat ini ${input.length} digit).';
    }

    return null;
  }

  static String? validateDate(DateTime? selectedDate, String? textValue) {
    if (selectedDate == null || (textValue ?? '').trim().isEmpty) {
      return 'Tanggal wajib dipilih melalui Date Picker.';
    }
    return null;
  }
}
