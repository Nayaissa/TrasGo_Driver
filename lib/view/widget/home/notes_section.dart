import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/home/tripcontroller.dart';
import 'section_title.dart';

class NotesSection extends StatelessWidget {
  const NotesSection({super.key, required this.controller});

  final TripController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle('driver_notes_optional'.tr),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF121E3C),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: controller.notesController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'notes_hint'.tr,
              hintStyle: const TextStyle(color: Colors.white38),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }
}