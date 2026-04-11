import 'package:flutter/material.dart';
import 'package:transport_project/controller/home/tripcontroller.dart';

class CreateTripButton extends StatelessWidget {
  const CreateTripButton({super.key, required this.controller});

  final TripController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [Color(0xFF5B8CFF), Color(0xFFD58BFF)],
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x665B8CFF),
              blurRadius: 24,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: controller.createTrip,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: const Text(
            'Create Trip',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}