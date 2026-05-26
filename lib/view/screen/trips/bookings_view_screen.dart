import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/trips/bookings_controller.dart';
import 'package:transport_project/core/class/statusrequest.dart';
import 'package:transport_project/core/constant/AppColor.dart';

class BookingRequestsPage extends StatelessWidget {
  const BookingRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: SafeArea(
        child: GetBuilder<BookingControllerImp>(
          init: BookingControllerImp(),
          builder: (controller) {
            final bookings = controller.bookingRequestsModel?.data?.items ?? [];

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 130),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Header(),
                      const SizedBox(height: 42),

                      const Text(
                        'OPERATIONS CENTER',
                        style: TextStyle(
                          color: Color(0xffdbe3ff),
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3,
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Booking\nRequests',
                        style: TextStyle(
                          color: Color(0xffedf2ff),
                          fontSize: 46,
                          height: .96,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -2,
                        ),
                      ),

                      const SizedBox(height: 30),

                      const SizedBox(height: 40),

                      const Filters(),

                      const SizedBox(height: 50),

                      if (controller.getBookingsRequest ==
                          StatusRequest.loading)
                        const Center(child: CircularProgressIndicator())
                      else if (controller.getBookingsRequest ==
                          StatusRequest.noData)
                        const EmptyState()
                      else if (controller.getBookingsRequest ==
                          StatusRequest.serverfailure)
                        const ErrorState()
                      else
                        ...bookings.map((booking) {
                          final statusKey = booking.status?.key;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TripTitle(
                                from: controller.from,
                                to: controller.to,
                                time: controller.formatDate(
                                  controller.departureTime,
                                ),
                                active:
                                    !controller.isDisabledBooking(statusKey),
                              ),

                              const SizedBox(height: 22),

                              RequestCard(
                                highlighted: statusKey == 'pending',
                                disabled: controller.isDisabledBooking(
                                  statusKey,
                                ),
                                name: booking.passengerName ?? '',
                                avatar: '🧍',
                                isNew: booking.isNew ?? false,
                                statusKey: statusKey ?? '',
                                rating: '${booking.passengerRating ?? 0}',
                                seats: '${booking.seatsReserved ?? 0} Seats',
                                payment: controller.paymentText(
                                  booking.paymentMethod,
                                ),
                                buttonText: controller.buttonText(statusKey),
                                buttonGradient: statusKey == 'pending',
                              ),

                              const SizedBox(height: 44),
                            ],
                          );
                        }),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xff3b7cff), width: 2),
          ),
          child: const Center(child: Text('👨🏻‍✈️')),
        ),
        const SizedBox(width: 12),
        const Text(
          'TransGo',
          style: TextStyle(
            color: Color(0xffb68cff),
            fontSize: 26,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Spacer(),
        CircleAvatar(
          radius: 22,
          backgroundColor: Color(0xff18243e),
          child: Icon(Icons.notifications, color: Color(0xff5d8cff)),
        ),
      ],
    );
  }
}

class Filters extends StatelessWidget {
  const Filters({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingControllerImp>(
      builder: (controller) {
        if (controller.getBookingStatusRequest == StatusRequest.loading) {
          return const SizedBox(
            height: 46,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final items = controller.bookingStatusModel?.data?.items ?? [];

        return SizedBox(
          height: 46,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final active = controller.filterIndex == i;

              return GestureDetector(
                onTap: () => controller.changeFilter(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    gradient:
                        active
                            ? const LinearGradient(
                              colors: [Color(0xff3577ff), Color(0xff477dff)],
                            )
                            : null,
                    color: active ? null : const Color(0xff121b2f),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      items[i].name ?? '',
                      style: TextStyle(
                        color: active ? Colors.white : const Color(0xffaab4cc),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class TripTitle extends StatelessWidget {
  final String from;
  final String to;
  final String time;
  final bool active;

  const TripTitle({
    super.key,
    required this.from,
    required this.to,
    required this.time,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 49,
          decoration: BoxDecoration(
            gradient:
                active
                    ? const LinearGradient(
                      colors: [Color(0xff4f7dff), Color(0xffd69bff)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                    : null,
            color: active ? null : const Color(0xff3b4b66),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Opacity(
            opacity: active ? 1 : .55,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$from  →  $to',
                  style: const TextStyle(
                    color: Color(0xffedf2ff),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.watch_later,
                      color: Color(0xff98a5c1),
                      size: 15,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      '$time Departure',
                      style: const TextStyle(
                        color: Color(0xff98a5c1),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class RequestCard extends StatelessWidget {
  final bool highlighted;
  final bool disabled;
  final String name;
  final String avatar;
  final bool isNew;
  final String statusKey;
  final String rating;
  final String seats;
  final String payment;
  final String buttonText;
  final bool buttonGradient;

  const RequestCard({
    super.key,
    this.highlighted = false,
    this.disabled = false,
    required this.name,
    required this.avatar,
    this.isNew = false,
    required this.statusKey,
    required this.rating,
    required this.seats,
    required this.payment,
    required this.buttonText,
    this.buttonGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? .55 : 1,
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          gradient:
              highlighted
                  ? const LinearGradient(
                    colors: [Color(0xff263867), Color(0xff493952)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : const LinearGradient(
                    colors: [Color(0xff151f34), Color(0xff10192b)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          borderRadius: BorderRadius.circular(44),
          border: Border.all(
            color:
                highlighted
                    ? const Color(0xff6c75ff).withOpacity(.45)
                    : Colors.white.withOpacity(.06),
          ),
          boxShadow:
              highlighted
                  ? [
                    BoxShadow(
                      color: const Color(0xff536dff).withOpacity(.35),
                      blurRadius: 28,
                      offset: const Offset(0, 10),
                    ),
                  ]
                  : null,
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor:
                      highlighted ? const Color(0xff806dff) : Colors.white24,
                  child: CircleAvatar(
                    radius: 23,
                    backgroundColor: const Color(0xffdbe2f2),
                    child: Text(avatar, style: const TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Color(0xffedf2ff),
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        disabled ? '⊘ $buttonText' : '★ $rating · Verified',
                        style: TextStyle(
                          color:
                              disabled
                                  ? const Color(0xffaeb7ca)
                                  : const Color(0xff83d8ff),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isNew)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff4c5fa4),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(
                        color: Color(0xffd8def2),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.3,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(child: InfoPill(title: 'REQUESTS', value: seats)),
                const SizedBox(width: 16),
                Expanded(
                  child: InfoPill(
                    title: disabled ? 'STATUS' : 'PAYMENT',
                    value: disabled ? buttonText : payment,
                    icon:
                        disabled
                            ? null
                            : payment == 'Cash'
                            ? Icons.payments_outlined
                            : Icons.credit_card,
                    danger: disabled,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: GetBuilder<BookingControllerImp>(
                    builder: (controller) {
                      return GestureDetector(
                        onTap: () {
                          /// فقط للحجوزات المقبولة
                          if (statusKey == 'accepted') {
                            controller.goToBookingDetails();
                          }
                        },
                        child: Container(
                          height: 49,
                          decoration: BoxDecoration(
                            gradient:
                                buttonGradient
                                    ? const LinearGradient(
                                      colors: [
                                        Color(0xff4f7dff),
                                        Color(0xffd69bff),
                                      ],
                                    )
                                    : null,
                            color:
                                buttonGradient ? null : const Color(0xff303950),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Center(
                            child: Text(
                              buttonText,
                              style: TextStyle(
                                color:
                                    disabled
                                        ? const Color(0xff74809a)
                                        : Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (highlighted) ...[
                  const SizedBox(width: 13),
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xff30374d),
                    child: Icon(Icons.more_horiz, color: Colors.white70),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class InfoPill extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  final bool danger;

  const InfoPill({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 67,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: const Color(0xff202b46).withOpacity(.58),
        borderRadius: BorderRadius.circular(35),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xff71809c),
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: const Color(0xff79dfff), size: 14),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color:
                        danger
                            ? const Color(0xffffa6b7)
                            : const Color(0xfff2f5ff),
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 40),
        child: Text(
          'No bookings found',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ErrorState extends StatelessWidget {
  const ErrorState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 40),
        child: Text(
          'Server error',
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
