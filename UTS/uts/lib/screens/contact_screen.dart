import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';

import '../models/contact_model.dart';
import '../theme/cyber_theme.dart';
import '../utils/validators.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({
    super.key,
    required this.contacts,
    required this.onAddContact,
    required this.onUpdateContact,
    required this.onDeleteContact,
  });

  final List<ContactModel> contacts;
  final ValueChanged<ContactModel> onAddContact;
  final void Function(int index, ContactModel updated) onUpdateContact;
  final ValueChanged<int> onDeleteContact;

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  static const Color _defaultContactColor = CyberColors.neonRed;

  DateTime? _selectedDate;
  Color _selectedColor = _defaultContactColor;
  PickedFileData? _selectedFile;
  String? _fileErrorMessage;

  int? _editingIndex;

  final DateFormat _dateFormatter = DateFormat('dd-MM-yyyy');

  @override
  void dispose() {
    _scrollController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _showCyberSnackBar(String message, {required bool isError}) {
    if (!mounted) return;
    final Color accent = isError
        ? CyberColors.neonRedSoft
        : CyberColors.neonGreen;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          backgroundColor: CyberColors.bgCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: accent, width: 1.4),
          ),
          content: Row(
            children: [
              Icon(
                isError
                    ? Icons.warning_amber_rounded
                    : Icons.check_circle_outline_rounded,
                color: accent,
                size: 21,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: CyberColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  Future<void> _pickDate() async {
    FocusScope.of(context).unfocus();
    final DateTime now = DateTime.now();
    final DateTime initial = _selectedDate ?? now;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
      helpText: 'PILIH TANGGAL KONTAK',
      cancelText: 'BATAL',
      confirmText: 'PILIH',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: CyberColors.neonCyan,
              onPrimary: CyberColors.bgVoid,
              surface: CyberColors.bgSurface,
              onSurface: CyberColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _dateFormatter.format(picked);
      });
    }
  }

  Future<void> _pickColor() async {
    FocusScope.of(context).unfocus();
    Color tempColor = _selectedColor;

    final Color? confirmedColor = await showDialog<Color>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(
                    Icons.palette_outlined,
                    color: CyberColors.neonPurple,
                    size: 22,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Pilih Warna Kontak',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: CyberColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: tempColor,
                  onColorChanged: (Color color) {
                    setDialogState(() {
                      tempColor = color;
                    });
                  },
                  enableAlpha: false,
                  hexInputBar: true,
                  labelTypes: const [],
                  pickerAreaHeightPercent: 0.72,
                  pickerAreaBorderRadius: BorderRadius.circular(8),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text(
                    'BATAL',
                    style: TextStyle(color: CyberColors.textSecondary),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(tempColor),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CyberColors.neonRed,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('PILIH WARNA'),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmedColor != null) {
      setState(() {
        _selectedColor = confirmedColor;
      });
    }
  }

  Future<void> _pickFile({bool openAfterPick = false}) async {
    FocusScope.of(context).unfocus();
    try {
      final PlatformFile? result = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result == null) {
        return;
      }

      final String fileName = result.name;
      final String extension = (result.extension ?? _extractExtension(fileName))
          .toLowerCase();
      final bool isPreviewImage =
          extension == 'jpg' || extension == 'jpeg' || extension == 'png';

      if (!isPreviewImage) {
        _showCyberSnackBar(
          'Hanya berkas gambar JPG, JPEG, atau PNG yang diperbolehkan.',
          isError: true,
        );
        return;
      }

      Uint8List? fileBytes;
      String? usablePath = result.path;

      try {
        final Uint8List rawBytes = await result.readAsBytes();
        if (isPreviewImage) {
          fileBytes = rawBytes;
        }
        if (!kIsWeb) {
          final String safeName = fileName.replaceAll(
            RegExp(r'[^\w\.\-]'),
            '_',
          );
          final File cachedFile = File(
            '${Directory.systemTemp.path}/${DateTime.now().millisecondsSinceEpoch}_$safeName',
          );
          await cachedFile.writeAsBytes(rawBytes, flush: true);
          usablePath = cachedFile.path;
        }
      } catch (_) {}

      final PickedFileData pickedData = PickedFileData(
        fileName: fileName,
        extension: extension,
        filePath: usablePath,
        imageBytes: fileBytes,
      );

      setState(() {
        _selectedFile = pickedData;
        _fileErrorMessage = null;
      });

      if (openAfterPick) {
        await _openFileExternal(pickedData);
      }
    } catch (e) {
      _showCyberSnackBar('Gagal memilih berkas: $e', isError: true);
    }
  }

  String _extractExtension(String fileName) {
    final int dotIndex = fileName.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == fileName.length - 1) {
      return '';
    }
    return fileName.substring(dotIndex + 1);
  }

  Future<void> _openFileExternal(PickedFileData fileData) async {
    final String? path = fileData.filePath;
    if (path == null || path.isEmpty) {
      _showCyberSnackBar(
        'Lokasi berkas lokal tidak tersedia untuk dibuka.',
        isError: true,
      );
      return;
    }

    try {
      final OpenResult openResult = await OpenFilex.open(path);
      if (openResult.type != ResultType.done) {
        _showCyberSnackBar(
          'Tidak dapat membuka berkas: ${openResult.message}',
          isError: true,
        );
      }
    } catch (e) {
      _showCyberSnackBar('Gagal membuka berkas: $e', isError: true);
    }
  }

  void _handleSubmit() {
    FocusScope.of(context).unfocus();

    final String? phoneError = ContactValidators.validatePhone(
      _phoneController.text,
    );
    final String? nameError = ContactValidators.validateName(
      _nameController.text,
    );
    final String? dateError = ContactValidators.validateDate(
      _selectedDate,
      _dateController.text,
    );
    final String? fileError = _selectedFile == null
        ? 'Berkas wajib dipilih melalui File Picker.'
        : null;

    _formKey.currentState?.validate();
    setState(() {
      _fileErrorMessage = fileError;
    });

    final List<String> errors = [
      ?phoneError,
      ?nameError,
      ?dateError,
      ?fileError,
    ];

    if (errors.isNotEmpty) {
      _showCyberSnackBar('Validasi gagal: ${errors.first}', isError: true);
      return;
    }

    final String cleanName = ContactValidators.normalizeName(
      _nameController.text,
    );
    final String cleanPhone = _phoneController.text.trim();

    if (_editingIndex == null) {
      final ContactModel newContact = ContactModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: cleanName,
        phoneNumber: cleanPhone,
        date: _selectedDate!,
        color: _selectedColor,
        file: _selectedFile!,
      );
      widget.onAddContact(newContact);
      _showCyberSnackBar(
        'Kontak "$cleanName" berhasil ditambahkan.',
        isError: false,
      );
    } else {
      final int targetIndex = _editingIndex!;
      final ContactModel existing = widget.contacts[targetIndex];
      final ContactModel updatedContact = existing.copyWith(
        name: cleanName,
        phoneNumber: cleanPhone,
        date: _selectedDate!,
        color: _selectedColor,
        file: _selectedFile!,
      );
      widget.onUpdateContact(targetIndex, updatedContact);
      _showCyberSnackBar(
        'Perubahan kontak "$cleanName" berhasil disimpan.',
        isError: false,
      );
    }

    _resetForm();
  }

  void _startEditContact(int index) {
    final ContactModel target = widget.contacts[index];
    setState(() {
      _editingIndex = index;
      _phoneController.text = target.phoneNumber;
      _nameController.text = target.name;
      _selectedDate = target.date;
      _dateController.text = _dateFormatter.format(target.date);
      _selectedColor = target.color;
      _selectedFile = target.file;
      _fileErrorMessage = null;
    });

    _formKey.currentState?.validate();

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _editingIndex = null;
      _phoneController.clear();
      _nameController.clear();
      _dateController.clear();
      _selectedDate = null;
      _selectedColor = _defaultContactColor;
      _selectedFile = null;
      _fileErrorMessage = null;
    });
  }

  Future<void> _confirmDeleteContact(int index) async {
    final ContactModel target = widget.contacts[index];
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.delete_forever_rounded,
                color: CyberColors.neonRedSoft,
                size: 24,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Konfirmasi Hapus',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: CyberColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus kontak "${target.name}" (${target.phoneNumber}) dari daftar?',
            style: const TextStyle(
              color: CyberColors.textSecondary,
              height: 1.45,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(
                'BATAL',
                style: TextStyle(color: CyberColors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: CyberColors.neonRed,
                foregroundColor: Colors.white,
              ),
              child: const Text('HAPUS'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      if (_editingIndex != null) {
        if (_editingIndex == index) {
          _resetForm();
        } else if (_editingIndex! > index) {
          setState(() {
            _editingIndex = _editingIndex! - 1;
          });
        }
      }

      widget.onDeleteContact(index);
      _showCyberSnackBar(
        'Kontak "${target.name}" telah dihapus.',
        isError: false,
      );
    }
  }

  void _showFullImagePreview(ContactModel contact) {
    if (!contact.file.canPreviewImage) return;
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: CyberColors.bgSurface,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: contact.color, width: 1.4),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        contact.file.fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: CyberColors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      icon: const Icon(Icons.close_rounded),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 340),
                    child: Image.memory(
                      contact.file.imageBytes!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = _editingIndex != null;

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CyberSectionHeader(
            subtitle: isEditing
                ? '// EDIT_PROTOCOL_ACTIVE'
                : '// INPUT_TERMINAL',
            title: isEditing ? 'Ubah Data Kontak' : 'Formulir Kontak Baru',
            accentColor: isEditing
                ? CyberColors.neonAmber
                : CyberColors.neonRed,
          ),
          const SizedBox(height: 12),
          if (isEditing) ...[
            _buildEditModeBanner(),
            const SizedBox(height: 12),
          ],
          CyberCard(
            borderColor: isEditing
                ? CyberColors.neonAmber
                : CyberColors.neonRed,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: ContactValidators.validatePhone,
                    style: const TextStyle(
                      fontFamily: 'Oxanium',
                      fontSize: 14.5,
                      color: CyberColors.textPrimary,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Phone Number (Nomor Telepon)',
                      hintText: 'Contoh: 628123456789',
                      prefixIcon: Icon(
                        Icons.phone_android_rounded,
                        color: CyberColors.neonCyan,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: ContactValidators.validateName,
                    style: const TextStyle(
                      fontSize: 14.5,
                      color: CyberColors.textPrimary,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Name (Nama Lengkap)',
                      hintText: 'Contoh: Alif Satria Raghib',
                      prefixIcon: Icon(
                        Icons.person_outline_rounded,
                        color: CyberColors.neonRedSoft,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: _pickDate,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? val) =>
                        ContactValidators.validateDate(_selectedDate, val),
                    style: const TextStyle(
                      fontFamily: 'Oxanium',
                      fontSize: 14,
                      color: CyberColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Date (Tanggal)',
                      hintText: 'Pilih tanggal (dd-MM-yyyy)',
                      prefixIcon: const Icon(
                        Icons.event_note_rounded,
                        color: CyberColors.neonPurple,
                      ),
                      suffixIcon: IconButton(
                        onPressed: _pickDate,
                        tooltip: 'Pilih Tanggal',
                        icon: const Icon(
                          Icons.calendar_month_rounded,
                          color: CyberColors.neonCyan,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _buildColorPickerSection(),
                  const SizedBox(height: 18),
                  _buildFilePickerSection(),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      if (isEditing) ...[
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _resetForm,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: CyberColors.textSecondary,
                              side: const BorderSide(
                                color: CyberColors.borderDim,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: BeveledRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Icon(Icons.close_rounded, size: 18),
                            label: const Text('BATAL'),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isEditing
                                ? CyberColors.neonAmber
                                : CyberColors.neonRed,
                            foregroundColor: isEditing
                                ? CyberColors.bgVoid
                                : Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 5,
                            shadowColor:
                                (isEditing
                                        ? CyberColors.neonAmber
                                        : CyberColors.neonRed)
                                    .withValues(alpha: 0.6),
                          ),
                          icon: Icon(
                            isEditing
                                ? Icons.save_as_rounded
                                : Icons.send_rounded,
                            size: 18,
                          ),
                          label: Text(
                            isEditing ? 'SIMPAN PERUBAHAN' : 'SUBMIT',
                            style: const TextStyle(
                              fontFamily: 'Oxanium',
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                              fontSize: 13.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 26),
          CyberSectionHeader(
            subtitle: '// CONTACT_DATABASE',
            title: 'List Contact (${widget.contacts.length})',
            accentColor: CyberColors.neonCyan,
          ),
          const SizedBox(height: 12),
          if (widget.contacts.isEmpty)
            _buildEmptyContactsState()
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.contacts.length,
              itemBuilder: (BuildContext context, int index) {
                final ContactModel contact = widget.contacts[index];
                final bool isBeingEdited = _editingIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildContactListItem(
                    contact: contact,
                    index: index,
                    isBeingEdited: isBeingEdited,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildEditModeBanner() {
    final String editingName = _editingIndex != null
        ? widget.contacts[_editingIndex!].name
        : '';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: CyberColors.neonAmber.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CyberColors.neonAmber.withValues(alpha: 0.8)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.edit_note_rounded,
            color: CyberColors.neonAmber,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Sedang mengubah kontak: $editingName',
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: CyberColors.neonAmber,
              ),
            ),
          ),
          TextButton(
            onPressed: _resetForm,
            style: TextButton.styleFrom(
              foregroundColor: CyberColors.neonAmber,
              visualDensity: VisualDensity.compact,
            ),
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  Widget _buildColorPickerSection() {
    final String hexCode = CyberColors.toHex(_selectedColor);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Color (Indikator Warna)',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: CyberColors.textPrimary,
              ),
            ),
            Text(
              hexCode,
              style: const TextStyle(
                fontFamily: 'Oxanium',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: CyberColors.neonCyan,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickColor,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            height: 68,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _selectedColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.35),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: _selectedColor.withValues(alpha: 0.45),
                  blurRadius: 14,
                  spreadRadius: 0.5,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: OutlinedButton.icon(
            onPressed: _pickColor,
            style: OutlinedButton.styleFrom(
              foregroundColor: CyberColors.neonPurple,
              backgroundColor: CyberColors.neonPurple.withValues(alpha: 0.1),
              side: const BorderSide(color: CyberColors.neonPurple, width: 1.2),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            icon: const Icon(Icons.color_lens_outlined, size: 18),
            label: const Text(
              'Pick Color',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilePickerSection() {
    final bool hasError = _fileErrorMessage != null;
    final PickedFileData? file = _selectedFile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pick Files (Berkas Gambar: JPG, JPEG, PNG)',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: CyberColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: CyberColors.bgInput,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hasError ? CyberColors.neonRed : CyberColors.borderDim,
              width: hasError ? 1.4 : 1.1,
            ),
          ),
          child: Column(
            children: [
              if (file == null)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.upload_file_rounded,
                        color: CyberColors.textSecondary,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Belum ada berkas dipilih (Wajib diisi)',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: CyberColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Row(
                  children: [
                    if (file.canPreviewImage)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.memory(
                          file.imageBytes!,
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: CyberColors.neonCyan.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: CyberColors.neonCyan.withValues(alpha: 0.5),
                          ),
                        ),
                        child: const Icon(
                          Icons.description_outlined,
                          color: CyberColors.neonCyan,
                        ),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            file.fileName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: CyberColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            file.isImageExtension
                                ? 'Gambar (${file.extension.toUpperCase()}) • Pratinjau aktif'
                                : 'Dokumen (${file.extension.isEmpty ? 'FILE' : file.extension.toUpperCase()})',
                            style: const TextStyle(
                              fontFamily: 'Oxanium',
                              fontSize: 11,
                              color: CyberColors.neonCyan,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (file.filePath != null)
                      IconButton(
                        onPressed: () => _openFileExternal(file),
                        tooltip: 'Buka Berkas',
                        icon: const Icon(
                          Icons.open_in_new_rounded,
                          color: CyberColors.neonCyan,
                          size: 20,
                        ),
                      ),
                  ],
                ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _pickFile(openAfterPick: false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: CyberColors.neonCyan,
                      backgroundColor: CyberColors.neonCyan.withValues(
                        alpha: 0.1,
                      ),
                      side: const BorderSide(
                        color: CyberColors.neonCyan,
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    icon: const Icon(Icons.attach_file_rounded, size: 17),
                    label: const Text(
                      'Pick File',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _pickFile(openAfterPick: true),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: CyberColors.neonRedSoft,
                      backgroundColor: CyberColors.neonRed.withValues(
                        alpha: 0.1,
                      ),
                      side: const BorderSide(
                        color: CyberColors.neonRedSoft,
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    icon: const Icon(Icons.file_open_outlined, size: 17),
                    label: const Text(
                      'Pick and Open File',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 12),
            child: Text(
              _fileErrorMessage!,
              style: const TextStyle(
                color: CyberColors.neonRedSoft,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyContactsState() {
    return CyberCard(
      borderColor: CyberColors.borderDim,
      glowOpacity: 0.04,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      child: const Column(
        children: [
          Icon(
            Icons.contact_mail_outlined,
            size: 42,
            color: CyberColors.textSecondary,
          ),
          SizedBox(height: 10),
          Text(
            'BELUM ADA DATA KONTAK',
            style: TextStyle(
              fontFamily: 'Oxanium',
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: CyberColors.textPrimary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Isi seluruh data pada formulir di atas lalu tekan tombol SUBMIT untuk menambahkan kontak.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              color: CyberColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactListItem({
    required ContactModel contact,
    required int index,
    required bool isBeingEdited,
  }) {
    final String formattedDate = _dateFormatter.format(contact.date);
    final String initial = contact.name.isNotEmpty
        ? contact.name[0].toUpperCase()
        : '?';

    return CyberCard(
      borderColor: isBeingEdited ? CyberColors.neonAmber : contact.color,
      glowOpacity: isBeingEdited ? 0.28 : 0.16,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: contact.file.canPreviewImage
                    ? () => _showFullImagePreview(contact)
                    : null,
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: contact.color.withValues(alpha: 0.2),
                    border: Border.all(color: contact.color, width: 1.6),
                    boxShadow: [
                      BoxShadow(
                        color: contact.color.withValues(alpha: 0.35),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.5),
                    child: contact.file.canPreviewImage
                        ? Image.memory(
                            contact.file.imageBytes!,
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: Text(
                              initial,
                              style: TextStyle(
                                fontFamily: 'Oxanium',
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: contact.color,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      style: const TextStyle(
                        fontFamily: 'Oxanium',
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: CyberColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.call_outlined,
                          size: 13.5,
                          color: CyberColors.neonCyan,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          contact.phoneNumber,
                          style: const TextStyle(
                            fontFamily: 'Oxanium',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: CyberColors.neonCyan,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 13,
                          color: CyberColors.textSecondary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            fontFamily: 'Oxanium',
                            fontSize: 12,
                            color: CyberColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _startEditContact(index),
                    tooltip: 'Ubah Kontak',
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(
                      Icons.edit_rounded,
                      color: CyberColors.neonCyan,
                      size: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _confirmDeleteContact(index),
                    tooltip: 'Hapus Kontak',
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: CyberColors.neonRedSoft,
                      size: 21,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 9,
                  decoration: BoxDecoration(
                    color: contact.color,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: contact.color.withValues(alpha: 0.55),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                CyberColors.toHex(contact.color),
                style: const TextStyle(
                  fontFamily: 'Oxanium',
                  fontSize: 10.5,
                  color: CyberColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: contact.file.filePath != null
                ? () => _openFileExternal(contact.file)
                : null,
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: CyberColors.bgInput,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: CyberColors.borderDim),
              ),
              child: Row(
                children: [
                  Icon(
                    contact.file.isImageExtension
                        ? Icons.image_rounded
                        : Icons.insert_drive_file_rounded,
                    size: 16,
                    color: CyberColors.neonPurple,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      contact.file.fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: CyberColors.textPrimary,
                      ),
                    ),
                  ),
                  if (contact.file.filePath != null) ...[
                    const SizedBox(width: 6),
                    const Text(
                      'BUKA',
                      style: TextStyle(
                        fontFamily: 'Oxanium',
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: CyberColors.neonCyan,
                      ),
                    ),
                    const SizedBox(width: 3),
                    const Icon(
                      Icons.open_in_new_rounded,
                      size: 13,
                      color: CyberColors.neonCyan,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
