import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/view/screen/home/earnings_page.dart';
import 'package:transport_project/view/screen/home/profile_page.dart';
import 'package:transport_project/view/screen/home/trip_creation_page.dart';
import 'package:transport_project/view/screen/home/trips_page.dart';

class HomeScreenController extends GetxController {
  int currentPage = 0;

  final List<Widget> pages = [
    TripCreationPage(),
    const TripsPage(),
    const ProfilePage(),
    const EarningsPage(),
  ];

  void changePage(int index) {
    currentPage = index;
    update();
  }
}
