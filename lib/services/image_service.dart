import 'dart:io';
import 'dart:typed_data';

import 'package:blurhash/blurhash.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart'
    as img; // Importa a biblioteca de manipulação de imagens
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vagali/models/image_blurhash.dart';
import 'package:vagali/repositories/storage_repository.dart';

class ImageService {
  static const double _maxHeight = 512;
  static const double _maxWidth = 512;
  static const _quality = 50;

  Future<XFile?> pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(
      source: source,
      maxHeight: _maxHeight,
      maxWidth: _maxWidth,
      imageQuality: _quality,
    );

    return pickedImage;
  }

  Future<String?> uploadImage(XFile file, String folderName) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final reference =
          FirebaseStorage.instance.ref().child('$folderName/$fileName.jpg');
      await reference.putFile(File(file.path));
      final imageUrl = await reference.getDownloadURL();
      return imageUrl;
    } catch (e) {
      debugPrint('Erro ao fazer upload da imagem: $e');
      return null;
    }
  }

  Future<List<File>> pickImages() async {
    final pickedImages = await ImagePicker().pickMultiImage(
      maxHeight: _maxHeight,
      maxWidth: _maxWidth,
      imageQuality: _quality,
    );

    if (pickedImages.isNotEmpty) {
      return pickedImages.map((pickedImage) => File(pickedImage.path)).toList();
    } else {
      print('Nenhuma imagem foi selecionada.');
      return [];
    }
  }

  Future<List<String>> uploadImages(List<File> files, String folderName) async {
    final storage = FirebaseStorage.instance;
    final imageUrls = <String>[];

    // Envio paralelo das imagens
    await Future.wait(files.map((file) async {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final reference = storage.ref().child('$folderName/$fileName.jpg');

      // Comprime a imagem antes do upload
      final compressedFile = await _compressImage(file);

      // Envio da imagem comprimida
      await reference.putFile(compressedFile);
      final imageUrl = await reference.getDownloadURL();
      imageUrls.add(imageUrl);
    }));

    return imageUrls;
  }

  Future<File> _compressImage(File file) async {
    final image = img.decodeImage(file.readAsBytesSync())!;

    final compressedImage = img.encodeJpg(image, quality: 55);

    final directory = await getTemporaryDirectory();
    final compressedFilePath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}_compressed.jpg';

    File(compressedFilePath).writeAsBytesSync(compressedImage);

    return File(compressedFilePath);
  }

  Future<String> encode(File file) async {
    Uint8List pixels = await file.readAsBytes();
    final blurHash = await BlurHash.encode(pixels, 4, 3);
    return blurHash;
  }

  Future<File?> decode(String blurHash) async {
    Uint8List? imageDataBytes;
    try {
      imageDataBytes = await BlurHash.decode(blurHash, 20, 12);
      final file = File.fromRawPath(imageDataBytes!);
      return file;
    } on PlatformException catch (e) {
      debugPrint(e.message);
      return null;
    }
  }

  Future<String?> getBlurhash(XFile xfile) async {
    try {
      final file = File(xfile.path);
      final blurHash = await encode(file);

      if (blurHash.isNotEmpty) {
        debugPrint('Imagem Blurhash codificada com sucesso...');
        return blurHash;
      }
      return null;
    } catch (e) {
      debugPrint('Erro ao fazer upload de Blurhash no Firebase Storage: $e');
      return null;
    }
  }

  // final storage = StorageRepository(name: repositoryName);
  // final url = await storage.uploadAndGetUrl(file);
  //
  // if (url != null && url.isNotEmpty) {
  // debugPrint('Upload de Imagem Blurhash realizado com sucesso...');
  // return ImageBlurHash(image: url, blurHash: blurHash);
  // }

  Future<List<XFile>> downloadAndSaveImagesToLocal(
      List<ImageBlurHash> imageUrls) async {
    final List<XFile> localImages = [];

    // Envio paralelo das imagens
    await Future.wait(imageUrls.map((url) async {
      try {
        final response = await Dio().get<List<int>>(
          url.image,
          options: Options(responseType: ResponseType.bytes),
        );

        final directory = await getTemporaryDirectory();
        final filePath =
            '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

        await File(filePath).writeAsBytes(response.data!);
        localImages.add(XFile(filePath));
      } catch (e) {
        debugPrint('Erro ao baixar e salvar imagem: $e');
      }
    }));

    return localImages;
  }
}
