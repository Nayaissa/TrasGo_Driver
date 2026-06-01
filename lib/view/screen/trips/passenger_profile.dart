import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PassengerProfileController extends GetxController {
  int currentIndex = 3;

  List<Map<String, dynamic>> activities = [
    {
      "title": "Downtown Central",
      "date": "Oct 24 • 14:20 PM",
      "price": "\$34.50",
      "status": "COMPLETED",
      "icon": Icons.location_on_outlined,
      "completed": true,
    },
    {
      "title": "International Airport",
      "date": "Oct 22 • 09:15 AM",
      "price": "\$58.00",
      "status": "COMPLETED",
      "icon": Icons.flight,
      "completed": true,
    },
    {
      "title": "Grand Plaza Mall",
      "date": "Oct 19 • 18:45 PM",
      "price": "\$12.20",
      "status": "CANCELLED",
      "icon": Icons.shopping_bag_outlined,
      "completed": false,
    },
  ];

  changeIndex(int index) {
    currentIndex = index;
    update();
  }
}

class PassengerProfilePage extends StatelessWidget {
  const PassengerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PassengerProfileController());

    return GetBuilder<PassengerProfileController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xff020D2B),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff031038),
                  Color(0xff020B26),
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      /// HEADER
                      Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.08),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Text(
                              "Passenger\nProfile",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Text(
                            "TransGo",
                            style: TextStyle(
                              color: Color(0xff6C7CFF),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.blue,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                "https://images.unsplash.com/photo-1500648767791-00dcc994a43e",
                              ),
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 40),

                      /// PROFILE IMAGE
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(.6),
                              blurRadius: 25,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 80,
                              backgroundColor: const Color(0xff162451),
                              child: CircleAvatar(
                                radius: 74,
                                backgroundImage: NetworkImage(
                                  "https://images.unsplash.com/photo-1494790108377-be9c29b29330",
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xff3F7DFF),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xff020D2B),
                                    width: 3,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.verified,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        "Elena Richardson",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "PREMIUM MEMBER SINCE 2022",
                        style: TextStyle(
                          color: Colors.white.withOpacity(.7),
                          letterSpacing: 3,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 35),

                      /// ACTION BUTTONS
                      Row(
                        children: [
                          Expanded(
                            child: _actionButton(
                              title: "Message",
                              icon: Icons.message_outlined,
                              color: const Color(0xff202B4C),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xff5578FF),
                                    Color(0xffE2A5FF),
                                  ],
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.call, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    "Call Now",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 30),

                      /// STATS
                      Row(
                        children: [
                          Expanded(
                            child: _statCard("4.92", "RATING",
                                const Color(0xffF3A6FF)),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _statCard("128", "BOOKINGS",
                                const Color(0xff82D0FF)),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _statCard(
                                "2", "CANCELLED", const Color(0xffFFB0B0)),
                          ),
                        ],
                      ),

                      const SizedBox(height: 35),

                      /// TITLE
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Recent Activity",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "VIEW ALL",
                            style: TextStyle(
                              color: Colors.white.withOpacity(.8),
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// ACTIVITY LIST
                      ...controller.activities.map(
                        (activity) => _activityCard(activity),
                      ),

                      const SizedBox(height: 30),

                      /// NOTES
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: const Color(0xff101C42),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Passenger Notes",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: const Color(0xff17254D),
                                borderRadius: BorderRadius.circular(20),
                                border: const Border(
                                  left: BorderSide(
                                    color: Color(0xffE3A3FF),
                                    width: 4,
                                  ),
                                ),
                              ),
                              child: Text(
                                '"Often carries a small laptop bag.\n'
                                'Prefers quiet rides and low\n'
                                'temperature. Very punctual at pickup\n'
                                'points."',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(.8),
                                  fontSize: 18,
                                  height: 1.6,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// BOTTOM NAVIGATION
          bottomNavigationBar: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xff111D45),
              borderRadius: BorderRadius.circular(40),
            ),
            child: BottomNavigationBar(
              currentIndex: controller.currentIndex,
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white54,
              onTap: controller.changeIndex,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.directions_car),
                  label: "REQUESTS",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet),
                  label: "EARNINGS",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month),
                  label: "SCHEDULE",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "ACCOUNT",
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _actionButton({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(35),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white70),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }

  Widget _statCard(String value, String title, Color color) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xff111D45),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 34,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }

  Widget _activityCard(Map activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xff111D45),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white.withOpacity(.08),
            child: Icon(
              activity["icon"],
              color: Colors.white70,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity["title"],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                Text(
                  activity["date"],
                  style: const TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                activity["price"],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    activity["completed"]
                        ? Icons.check_circle
                        : Icons.cancel,
                    size: 16,
                    color: activity["completed"]
                        ? Colors.cyanAccent
                        : Colors.redAccent,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    activity["status"],
                    style: TextStyle(
                      color: activity["completed"]
                          ? Colors.cyanAccent
                          : Colors.redAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}