import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vagali/features/map/controllers/map_controller.dart';
import 'package:vagali/features/parking/views/parking_details_view.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/flat_button.dart';
import 'package:vagali/widgets/image_gallery_dialog.dart';
import 'package:vagali/widgets/loader.dart';
import 'package:vagali/widgets/tag_list.dart';

class MapView extends StatefulWidget {
  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final _controller = Get.put(MapController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (_controller.loading.isTrue) {
          return const Loader(
            message: 'Carregando mapa',
          );
        }

        final currentLocation = _controller.userCurrentLocation.value!;

        final latitude = currentLocation.latitude;
        final longitude = currentLocation.longitude;

        return Stack(
          children: [
            Obx(
              () => GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    latitude,
                    longitude,
                  ),
                  zoom: _controller.zoom.value,
                ),
                // ignore: invalid_use_of_protected_member
                markers: _controller.markers.value,
                onMapCreated: (GoogleMapController controller) {
                  _controller.googleMapController = controller;
                  _controller.loadMapStyle(controller);
                },
              ),
            ),
            Obx(() {
              if (_controller.selectedParking.value != null) {
                return Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      _controller.selectedParking.value = null;
                    },
                    child: ColoredBox(
                      color: Colors.black.withOpacity(0.15),
                    ),
                  ),
                );
              }
              return Container();
            }),
            Obx(() {
              if (_controller.selectedParking.value != null) {
                return Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _parkingCard(),
                );
              }
              return Container();
            }),
          ],
        );
      }),
    );
  }

  Widget _parkingCard() {
    return Container(
      // color: Colors.white,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      // padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Text(
              _controller.selectedParking.value!.name,
              style: ThemeTypography.semiBold14,
            ),
          ),
          const SizedBox(height: 16),
          TagList(
            tags: _controller.selectedParking.value!.tags,
          ),
          // const SizedBox(height: 16),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: UserCard(user: _controller.selectedParking.value!.owner!),
          // ),
          const SizedBox(height: 16),
          _parkingImages(),
          const SizedBox(height: 16),
          _description(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: FlatButton(
              actionText: 'Ver Estacionamento',
              onPressed: () => Get.to(
                () => ParkingDetailsView(
                  parking: _controller.selectedParking.value!,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _parkingImages() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _controller.selectedParking.value!.images.length,
        itemBuilder: (context, index) {
          final image = _controller.selectedParking.value!.images[index];
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ImageGalleryDialog(
                    images: _controller.selectedParking.value!.images,
                    initialIndex: index,
                  );
                },
              );
            },
            child: Container(
              height: 80,
              width: 80,
              margin: const EdgeInsets.only(right: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: BlurHash(
                  imageFit: BoxFit.cover,
                  image: image.image,
                  hash: image.blurHash,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _description() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Descrição',
            style: ThemeTypography.semiBold14,
          ),
          SizedBox(height: 8),
          Text(
            _controller.selectedParking.value!.description,
            style: ThemeTypography.regular12,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.selectedParking.value = null;
    super.dispose();
  }
}
