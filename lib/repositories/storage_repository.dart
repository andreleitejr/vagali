import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class StorageRepository {
  StorageRepository({
    required this.name,
  });

  final String name;
  final storage = FirebaseStorage.instance;

  final reference = FirebaseStorage.instance.ref();

  Future upload(File image) async {
    final fileName = basename(image.path);

    try {
      final ref = storage.ref(name).child(fileName);
      await ref.putFile(image);
    } catch (e) {
      debugPrint('Storage Repository | Upload Error: $e');
    }
  }

  Future<String?> download(String fileName) async {
    final path = "$name/$fileName";

    try {
      final imageUrl = await reference.child(path).getDownloadURL();
      return imageUrl;
    } catch (e) {
      debugPrint('Storage Repository | Download Error: $e');
      return null;
    }
  }

  Future<String?> uploadAndGetUrl(File file) async {
    await upload(file);
    final downloadUrl = await download(basename(file.path));
    return downloadUrl;
  }
}
