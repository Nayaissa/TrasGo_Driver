import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/view/screen/home/complaints_page.dart';
import 'package:transport_project/view/screen/home/earnings_page.dart';
import 'package:transport_project/view/screen/home/profile_page.dart';
import 'package:transport_project/view/screen/home/trip_creation_page.dart';
import 'package:transport_project/view/screen/trips/trips_view_screen.dart';


class HomeScreenController extends GetxController {
  int currentPage = 0;

  List<Widget> pages =  [
    TripCreationPage(),
    TripsPage(),
      DriverProfileScreen(),
    ComplaintsPage(),
    EarningsPage(),
  ];

  void changePage(int index) {
    currentPage = index;
    update();
  }
}