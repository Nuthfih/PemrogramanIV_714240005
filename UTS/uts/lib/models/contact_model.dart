import 'dart:typed_data';
import 'package:flutter/material.dart';

class PickedFileData {
  const PickedFileData({
    required this.fileName,
    required this.extension,
    this.filePath,
    this.imageBytes,
  });

  final String fileName;
  final String extension;
  final String? filePath;
  final Uint8List? imageBytes;

  bool get isImageExtension {
    final String ext = extension.toLowerCase();
    return ext == 'jpg' || ext == 'jpeg' || ext == 'png';
  }

  bool get canPreviewImage => isImageExtension && imageBytes != null;
}

class ContactModel {
  const ContactModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.date,
    required this.color,
    required this.file,
  });

  final String id;
  final String name;
  final String phoneNumber;
  final DateTime date;
  final Color color;
  final PickedFileData file;

  ContactModel copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    DateTime? date,
    Color? color,
    PickedFileData? file,
  }) {
    return ContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      date: date ?? this.date,
      color: color ?? this.color,
      file: file ?? this.file,
    );
  }
}
