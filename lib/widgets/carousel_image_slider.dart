import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:get/get.dart';
import 'package:vagali/models/image_blurhash.dart';
import 'package:vagali/theme/theme_colors.dart';

class CarouselImageSliderController extends GetxController {
  final carouselController = CarouselController();
  var currentCarouselImage = 0.obs;
}

class CarouselImageSlider extends StatelessWidget {
  final List<ImageBlurHash> images;

  CarouselImageSlider({super.key, required this.images});

  final CarouselImageSliderController controller =
      Get.put(CarouselImageSliderController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          items: images.map((image) {
            return BlurHash(
              imageFit: BoxFit.cover,
              image: image.image,
              hash: image.blurHash,
            );
          }).toList(),
          options: CarouselOptions(
            pageSnapping: true,
            height: MediaQuery.of(context).size.width * 0.75,
            enableInfiniteScroll: false,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              controller.currentCarouselImage(index);
            },
          ),
          carouselController: controller.carouselController,
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            children: [
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: images.map((url) {
                    int index = images.indexOf(url);
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: controller.currentCarouselImage.value == index
                            ? ThemeColors.primary
                            : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16)
            ],
          ),
        ),
      ],
    );
  }
}
