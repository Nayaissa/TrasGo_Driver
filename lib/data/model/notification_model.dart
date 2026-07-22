import 'package:flutter/material.dart';

class DriverNotificationModel {
  final bool success;
  final String message;
  final List<DriverNotificationItem> items;

  DriverNotificationModel({
    required this.success,
    required this.message,
    required this.items,
  });

  factory DriverNotificationModel.fromJson(Map<String, dynamic> json) {
    final data = json["data"];
    final items = data is Map ? data["items"] : [];

    return DriverNotificationModel(
      success: json["success"] == true,
      message: json["message"]?.toString() ?? "",
      items: items is List
          ? items
              .map(
                (item) => DriverNotificationItem.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : [],
    );
  }
}

class DriverNotificationItem {
  final int userNotificationId;
  final int notificationId;
  final String title;
  final String body;
  final String notificationType;
  bool isRead;
  final String createdAt;

  DriverNotificationItem({
    required this.userNotificationId,
    required this.notificationId,
    required this.title,
    required this.body,
    required this.notificationType,
    required this.isRead,
    required this.createdAt,
  });

  factory DriverNotificationItem.fromJson(Map<String, dynamic> json) {
    return DriverNotificationItem(
      userNotificationId: _toInt(json["user_notification_id"]),
      notificationId: _toInt(json["notification_id"]),
      title: json["title"]?.toString() ?? "",
      body: json["body"]?.toString() ?? "",
      notificationType: json["notification_type"]?.toString() ?? "",
      isRead: json["is_read"] == true,
      createdAt: json["created_at"]?.toString() ?? "",
    );
  }

  String get badgeText {
    if (notificationType.contains("trip")) return "TRIP";
    if (notificationType.contains("reminder")) return "REMINDER";
    if (notificationType.contains("admin")) return "ADMIN";
    return "NOTIFICATION";
  }

  Color get color {
    if (notificationType.contains("trip")) return const Color(0xFF4CAF50); // كمثال AppColor.thirdColor
    if (notificationType.contains("reminder")) return const Color(0xFFFFB86B);
    if (notificationType.contains("admin")) return const Color(0xFF29B6F6);
    return Colors.white54;
  }

  IconData get icon {
    if (notificationType.contains("trip")) {
      return Icons.local_taxi_outlined;
    }
    if (notificationType.contains("reminder")) {
      return Icons.access_time_outlined;
    }
    if (notificationType.contains("admin")) {
      return Icons.admin_panel_settings_outlined;
    }
    return Icons.notifications_none_rounded;
  }

  String get timeText {
    if (createdAt.isEmpty) return "";

    try {
      final date = DateTime.parse(createdAt);
      final diff = DateTime.now().difference(date);

      if (diff.inMinutes < 1) return "Now";
      if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
      if (diff.inHours < 24) return "${diff.inHours} h ago";
      if (diff.inDays == 1) return "Yesterday";

      final year = date.year.toString();
      final month = date.month.toString().padLeft(2, "0");
      final day = date.day.toString().padLeft(2, "0");

      return "$year-$month-$day";
    } catch (_) {
      return createdAt;
    }
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}