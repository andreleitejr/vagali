import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/landlord/features/parking/models/parking_type.dart';
import 'package:vagali/features/home/tenant/controllers/home_controller.dart';
import 'package:vagali/features/home/tenant/widgets/parking_list_item.dart';
import 'package:vagali/features/home/tenant/widgets/parking_list_tile.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/coolicon.dart';
import 'package:vagali/widgets/search_input.dart';
import 'package:vagali/widgets/shimmer_box.dart';

class HomeView extends StatelessWidget {
  final HomeController _controller = Get.put(HomeController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final loading = _controller.loading.value;
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              toolbarHeight: 96,
              expandedHeight: 56,
              stretch: true,
              backgroundColor: Colors.white,
              pinned: true,
              flexibleSpace: Padding(
                padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
                child: ShimmerBox(
                    loading: loading,
                    child: Row(
                      children: [
                        Expanded(
                          child: SearchInput(
                            searchText: _controller.searchText.value,
                            hintText: 'Onde deseja estacionar?',
                            onSearch: _controller.searchText,
                          ),
                        ),
                        // const SizedBox(
                        //   width: 16,
                        // ),
                        // const Coolicon(icon: Coolicons.slider),
                      ],
                    )),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  if (_controller.searchText.isEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (final type in parkingTypes) ...[
                                  _buildCategoryButton(type),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ShimmerBox(
                            loading: loading,
                            child: const Text(
                              'Próximos de você',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 250,
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(16),
                        scrollDirection: Axis.horizontal,
                        itemCount: _controller.filteredParkings.length,
                        itemBuilder: (context, index) {
                          final parking = _controller.filteredParkings[index];
                          return Row(
                            children: [
                              ShimmerBox(
                                loading: loading,
                                child: ParkingListItem(parking: parking),
                              ),
                              const SizedBox(width: 16),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ShimmerBox(
                        loading: loading,
                        child: const Text(
                          'Recomendados',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ] else ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Resultado da busca:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final parking = _controller.searchText.isEmpty
                      ? _controller.nearbyParkings[index]
                      : _controller.filteredParkings[index];
                  return ParkingListTile(
                    loading: loading,
                    parking: parking,
                  );
                },
                childCount: _controller.searchText.isEmpty
                    ? _controller.nearbyParkings.length
                    : _controller.filteredParkings.length,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCategoryButton(ParkingType? type) {
    return Obx(() {
      final selectedCategories = _controller.selectedCategories;
      final isSelected = selectedCategories.contains(type?.type);

      final loading = _controller.loading.value;

      return Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ShimmerBox(
                loading: loading,
                child: GestureDetector(
                  onTap: () {
                    selectedCategories.clear();
                    selectedCategories.add(type!.type);
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: ThemeColors.grey2,
                      gradient: isSelected ? ThemeColors.gradient : null,
                    ),
                    child: Center(
                      child: Coolicon(
                        icon: type?.icon ?? Coolicons.compass,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ShimmerBox(
                loading: loading,
                child: Text(
                  type?.name ?? 'Not found',
                  style: ThemeTypography.semiBold12,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
        ],
      );
    });
  }
}
