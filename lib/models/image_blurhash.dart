class ImageBlurHash {
  final String image;
  final String blurHash;

  ImageBlurHash({required this.image, required this.blurHash});

  ImageBlurHash.fromMap(Map<String, dynamic> map)
      : image = map['image'],
        blurHash = map['blurhash'];

  Map<String, dynamic> toMap() => {'image': image, 'blurhash': blurHash};
}
