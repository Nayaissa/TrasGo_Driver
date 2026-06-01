import 'package:get/get.dart';

class PassengerProfileController extends GetxController {
  final String name = "Elena Richardson";
  final String memberSince = "PREMIUM MEMBER SINCE 2022";

  final double rating = 4.92;
  final int bookings = 128;
  final int cancelled = 2;

  final List<ActivityModel> activities = [
    ActivityModel(
      title: "Downtown Central",
      date: "Oct 24 • 14:20 PM",
      price: "\$34.50",
      status: "COMPLETED",
      icon: "location",
      completed: true,
    ),
    ActivityModel(
      title: "International Airport",
      date: "Oct 22 • 09:15 AM",
      price: "\$58.00",
      status: "COMPLETED",
      icon: "plane",
      completed: true,
    ),
    ActivityModel(
      title: "Grand Plaza Mall",
      date: "Oct 19 • 18:45 PM",
      price: "\$12.20",
      status: "CANCELLED",
      icon: "bag",
      completed: false,
    ),
  ];
}

class ActivityModel {
  final String title;
  final String date;
  final String price;
  final String status;
  final String icon;
  final bool completed;

  ActivityModel({
    required this.title,
    required this.date,
    required this.price,
    required this.status,
    required this.icon,
    required this.completed,
  });
}