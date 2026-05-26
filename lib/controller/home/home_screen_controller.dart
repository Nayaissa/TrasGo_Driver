import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/view/screen/home/earnings_page.dart';

import 'package:transport_project/view/screen/home/trip_creation_page.dart';
import 'package:transport_project/view/screen/trips/bookings_details_view.dart';
import 'package:transport_project/view/screen/trips/trips_view_screen.dart';

class HomeScreenController extends GetxController {
  int currentPage = 0;

  final List<Widget> pages = [
    TripCreationPage(),
    TripsPage(),
    RideDetailsScreen(),
    const EarningsPage(),
  ];

  void changePage(int index) {
    currentPage = index;
    update();
  }
}
