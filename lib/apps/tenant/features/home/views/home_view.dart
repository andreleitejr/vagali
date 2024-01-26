import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/landlord/features/parking/models/parking_tag.dart';
import 'package:vagali/apps/landlord/features/parking/models/parking_type.dart';
import 'package:vagali/apps/tenant/features/home/controllers/home_controller.dart';
import 'package:vagali/apps/tenant/features/home/widgets/parking_list_item.dart';
import 'package:vagali/features/item/views/item_list_view.dart';
import 'package:vagali/features/search/views/search_view.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/coolicon.dart';
import 'package:vagali/widgets/search_input.dart';
import 'package:vagali/widgets/shimmer_box.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class HomeView extends StatelessWidget {
  final HomeController _controller = Get.put(HomeController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: TopNavigationBar(
      //   title: '',
      //   showLeading: false,
      // ),
      body: SafeArea(
        child: Obx(() {
          final loading = _controller.loading.value;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                toolbarHeight: 180,
                expandedHeight: 56,
                elevation: 3,
                shadowColor: Colors.black54,
                // forceElevated: true,
                stretch: true,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                pinned: true,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: ShimmerBox(
                    loading: loading,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => Get.to(() => ParkingSearchView()),
                                child: AbsorbPointer(
                                  child: SearchInput(
                                    searchText: '',
                                    hintText: 'O que deseja guardar?',
                                    onSearch: (_) {},
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Coolicon(icon: Coolicons.slider),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    for (final type in parkingTags) ...[
                                      _buildCategoryButton(type),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 24,
                      ),
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
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final parking = _controller.filteredParkings[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ShimmerBox(
                        loading: loading,
                        child: ParkingListItem(parking: parking),
                      ),
                    );
                  },
                  childCount: _controller.filteredParkings.length,
                ),
              ),
            ],
          );
        }),
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
                        borderRadius: BorderRadius.circular(16),
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
                ShimmerBox(
                  loading: loading,
                  child: Container(
                    width: 48,
                    height: 24,
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
}
