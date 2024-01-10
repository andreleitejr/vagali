import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:get/get.dart';
import 'package:vagali/models/image_blurhash.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/widgets/coolicon.dart';

class ImageGalleryDialog extends StatelessWidget {
  final List<ImageBlurHash> images;
  final int initialIndex;

  ImageGalleryDialog({required this.images, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black.withOpacity(0.75),
      insetPadding: EdgeInsets.zero,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Coolicon(
                  onTap: () => Get.back(),
                  icon: Coolicons.close,
                  color: Colors.white,

                ),
              ),
            ],
          ),
          Expanded(child: Container()),
          Container(
            height: MediaQuery.of(context).size.width,
            child: PageView.builder(
              itemCount: images.length,
              controller: PageController(initialPage: initialIndex),
              itemBuilder: (context, index) {
                final image = images[index];
                return BlurHash(
                  imageFit: BoxFit.fitWidth,
                  image: image.image,
                  hash: image.blurHash,
                );
              },
            ),
          ),
          const SizedBox(height: 64),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
