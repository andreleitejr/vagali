import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/landlord/features/parking/models/parking.dart';
import 'package:vagali/apps/landlord/features/parking/models/parking_tag.dart';
import 'package:vagali/apps/landlord/features/parking/models/parking_type.dart';
import 'package:vagali/apps/landlord/features/parking/models/price.dart';
import 'package:vagali/apps/tenant/features/home/controllers/home_controller.dart';
import 'package:vagali/apps/tenant/features/home/widgets/parking_list_item.dart';
import 'package:vagali/apps/tenant/features/home/widgets/parking_list_tile.dart';
import 'package:vagali/features/address/models/address.dart';
import 'package:vagali/features/reservation/models/reservation_type.dart';
import 'package:vagali/models/image_blurhash.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/carousel_image_slider.dart';
import 'package:vagali/widgets/coolicon.dart';
import 'package:vagali/widgets/search_input.dart';
import 'package:vagali/widgets/shimmer_box.dart';

class HomeView extends StatelessWidget {
  final HomeController _controller = Get.put(HomeController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(
          () {
            final loading = _controller.loading.value;

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  toolbarHeight: _controller.searchText.isEmpty ? 180 : 76,
                  expandedHeight: 56,
                  elevation: 3,
                  shadowColor: Colors.black54,
                  stretch: true,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  pinned: true,
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 12),
                    child: ShimmerBox(
                      loading: loading,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  child: SearchInput(
                                    searchText: _controller.searchText.value,
                                    hintText:
                                        'Busque por rua, bairro, cidade...',
                                    onSearch: _controller.searchText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_controller.searchText.isEmpty) ...[
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 88,
                              child: ListView.builder(
                                padding: const EdgeInsets.only(left: 24),
                                scrollDirection: Axis.horizontal,
                                itemCount: parkingTags.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final tag = parkingTags[index];
                                  return _buildCategoryButton(
                                    tag,
                                  );
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _controller.searchText.isEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(24, 0, 16, 16),
                              child: ShimmerBox(
                                loading: loading,
                                child: const Text(
                                  'Próximos de você',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (loading) {
                        return ShimmerBox(
                          loading: loading,
                          child: parkingListShimmerItem(context),
                        );
                      }
                      final parking = _controller.filteredParkings[index];
                      return _controller.searchText.isEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: ParkingListItem(parking: parking),
                            )
                          : ParkingListTile(parking: parking);
                    },
                    childCount:
                        loading ? 4 : _controller.filteredParkings.length,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryButton(ParkingTag? tag) {
    return Obx(
      () {
        var category = _controller.category;
        final isSelected = category == tag!;

        final loading = _controller.loading.value;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ShimmerBox(
                  loading: loading,
                  child: GestureDetector(
                    onTap: () {
                      category.value = tag;
                    },
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected
                            ? ThemeColors.primary
                            : ThemeColors.grey1,
                      ),
                      child: Center(
                        child: Coolicon(
                          icon: tag.icon,
                          color: isSelected ? Colors.white : ThemeColors.grey4,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 48,
                  height: 24,
                  color: Colors.white.withOpacity(0.00005),
                  child: ShimmerBox(
                    loading: loading,
                    child: Text(
                      tag.name,
                      style: ThemeTypography.regular10,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
          ],
        );
      },
    );
  }

  Widget parkingListShimmerItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxHeight: 326),
            height: MediaQuery.of(context).size.width - 56,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 14,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 14,
                  width: MediaQuery.of(context).size.width * 0.6,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          )
        ],
      ),
    );
  }
}
