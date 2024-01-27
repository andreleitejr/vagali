import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/reservation/controllers/reservation_list_controller.dart';
import 'package:vagali/features/reservation/widgets/last_reservation_widget.dart';
import 'package:vagali/features/reservation/widgets/reservation_history_item.dart';
import 'package:vagali/features/reservation/widgets/reservation_item.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/loader.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class ReservationListView extends StatelessWidget {
  final ReservationListController _controller =
      Get.put(ReservationListController());

  ReservationListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopNavigationBar(
        showLeading: false,
        title: 'Minhas reservas',
      ),
      body: Obx(() {
        if (_controller.loading.isTrue) {
          return const Loader();
        }

        if (_controller.reservationsInProgress.isEmpty) {
          return Center(
            child: Text('Nenhuma reserva encontrada'),
          );
        }
        return DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                unselectedLabelColor: Colors.red,
                indicatorColor: ThemeColors.primary,
                tabs: [
                  Tab(
                    icon: Text(
                      'Em andamento',
                      style: ThemeTypography.medium16.apply(
                        color: ThemeColors.grey3,
                      ),
                    ),
                  ),
                  Tab(
                    icon: Text(
                      'Finalizadas',
                      style: ThemeTypography.medium16.apply(
                        color: ThemeColors.grey3,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    inProgress(),
                    done(),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget inProgress() {
    return Column(
      children: [
        if (_controller.currentReservation.value != null)
          LastReservationWidget(
            reservation: _controller.currentReservation.value!,
            onReservationChanged: () =>
                _controller.verifyStatusAndUpdateReservation(
              _controller.currentReservation.value!,
            ),
          ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _controller.reservationsInProgress.length,
            itemBuilder: (BuildContext context, int index) {
              final reservation = _controller.reservationsInProgress[index];

              if (reservation == _controller.currentReservation.value) {
                return Container();
              }
              return ReservationHistoryItem(
                reservation: reservation,
                onReservationChanged: () =>
                    _controller.verifyStatusAndUpdateReservation(reservation),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget done() {
    return ListView.builder(
      itemCount: _controller.reservationsDone.length,
      itemBuilder: (BuildContext context, int index) {
        final reservation = _controller.reservationsDone[index];

        return ReservationItem(reservation: reservation);
      },
    );
  }
}
