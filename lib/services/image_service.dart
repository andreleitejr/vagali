import 'dart:io';

import 'package:blurhash/blurhash.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vagali/models/image_blurhash.dart';
import 'package:vagali/repositories/storage_repository.dart';

class ImageService {
  Future<XFile?> pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

    if (pickedImage != null) {
      // final compressedImage = _compressImage(pickedImage);
      return pickedImage;
    } else {
      // Nenhum arquivo de imagem selecionado
      return null;
    }
  }

  Future<String?> uploadImage(String fileName, XFile file) async {
    try {
      // final compressedFile = await _compressImage(file);

      final reference =
          FirebaseStorage.instance.ref().child('user_images/$fileName.jpg');
      await reference.putFile(File(file.path));
      final imageUrl = await reference.getDownloadURL();
      return imageUrl;
    } catch (e) {
      debugPrint('Erro ao fazer upload da imagem: $e');
      return null;
    }
  }

  Future<List<File>> pickImages() async {
    final pickedImages = await ImagePicker().pickMultiImage();

    if (pickedImages.isNotEmpty) {
      final compressedImages = <File>[];
      for (final image in pickedImages) {
        compressedImages.add(File(image.path));
      }
      final files =
          compressedImages.map((compressed) => File(compressed.path)).toList();

      return files;
    } else {
      print('Nenhuma imagem foi selecionada.');
      return [];
    }
  }

  Future<List<String>> uploadImages(List<File> files, String folderName) async {
    final storage = FirebaseStorage.instance;
    final imageUrls = <String>[];

    for (final file in files) {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final reference = storage.ref().child('$folderName/$fileName.jpg');
      await reference.putFile(file);
      final imageUrl = await reference.getDownloadURL();
      imageUrls.add(imageUrl);
    }

    return imageUrls;
  }

  // Future<XFile> _compressImage(XFile file) async {
  //   final result = await FlutterImageCompress.compressAndGetFile(
  //     file.path,
  //     file.path.replaceFirst(".jpg", "_compressed.jpg"),
  //     quality: 75,
  //     minHeight: 512,
  //     minWidth: 512,
  //   );
  //   return result!;
  // }

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

  Future<ImageBlurHash?> buildImageBlurHash(
      XFile xfile, String repositoryName) async {
    try {
      final storage = StorageRepository(name: repositoryName);
      // TESTAR COMPRESSAO
      // final compressedFile = await _compressImage(xfile);
      final file = File(xfile.path);
      final blurHash = await encode(file);
      if (blurHash.isNotEmpty) {
        debugPrint('Image de Blurhash codificada com sucesso...');
        final url = await storage.uploadAndGetUrl(file);
        if (url != null && url.isNotEmpty) {
          debugPrint('Upload de Image de Blurhash realizado com sucesso...');
          return ImageBlurHash(image: url, blurHash: blurHash);
        }
      }
      return null;
    } catch (e) {
      debugPrint('Erro ao fazer upload de Blurhash no Firebase Storage: $e');
      return null;
    }
  }

  Future<List<XFile>> downloadAndSaveImagesToLocal(List<ImageBlurHash> imageUrls) async {
    final List<XFile> localImages = [];

    for (final url in imageUrls) {
      try {
        final response = await Dio().get<List<int>>(url.image,
            options: Options(responseType: ResponseType.bytes));

        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

        await File(filePath).writeAsBytes(response.data!);
        localImages.add(XFile(filePath));
      } catch (e) {
        debugPrint('Erro ao baixar e salvar imagem: $e');
      }
    }

    return localImages;
  }
}
