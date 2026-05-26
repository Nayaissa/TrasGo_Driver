// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:get/get.dart';
// import 'package:firebase_core/firebase_core.dart';

// class NotificationController extends GetxController {
//   String message = "";

//   @override
//   void onInit() {
//     super.onInit();

//     FirebaseMessaging.instance.requestPermission();

//     FirebaseMessaging.instance.getToken().then((token) {
//       print('FCM Token: $token');
//     });

//     FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
//       if (msg.notification != null) {
//         message = msg.notification!.body ?? '';
//         update();
//         print(' notifiaction: ${msg.notification!.body}');
//       }
//     });

//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   }
// }

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("message in background  : ${message.messageId}");
// }

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:transport_project/core/class/diohelper.dart';

// class NotificationController extends GetxController {
//   String message = "";

//   @override
//   void onInit() {
//     super.onInit();
//     _initFirebaseMessaging();
//   }

//   void _initFirebaseMessaging() async {
//     await FirebaseMessaging.instance.requestPermission();

   
//     FirebaseMessaging.instance.getToken().then((token) {
//       if (token != null) {
//         print('FCM Token: $token');
//         _sendTokenToServer(token); 
//       }
//     });


//     FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
//       if (msg.notification != null) {
//         message = msg.notification!.body ?? '';
//         update();
//         print('Foreground notification: ${msg.notification!.body}');
//       }
//     });

  
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage msg) {
//       if (msg.notification != null) {
//         message = msg.notification!.body ?? '';
//         update();
//         print('Background notification : ${msg.notification!.body}');
//       }
//     });

   
//     FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? msg) {
//       if (msg != null && msg.notification != null) {
//         message = msg.notification!.body ?? '';
//         update();
//         print('Terminated notification: ${msg.notification!.body}');
//       }
//     });

//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   }

//   Future<void> _sendTokenToServer(String token) async {
//     DioHelper.postsData(
//           url: '/api/user/update-fcm-token',
//           data: {"fcm_token": token},
//         )
//         .then((value) {
//           print(value!.data);
//           if (value.statusCode == 200 || value.statusCode == 201) {
//             update();
//           } else {
//             print('no update');
//           }
//           update();
//         })
//         .catchError((error) {
//           print(error);
//           update();
//         });
//   }
// }

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print(" Background handler message: ${message.messageId}");
// }

class NotificationController extends GetxController {
  String message = "";
  int unreadCount = 0; 

  @override
  void onInit() {
    super.onInit();
    _initFirebaseMessaging();
  }

  void _initFirebaseMessaging() async {
    await FirebaseMessaging.instance.requestPermission();

    FirebaseMessaging.instance.getToken().then((token) {
      if (token != null) {
        print('FCM Token: $token');
        _sendTokenToServer(token);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      if (msg.notification != null) {
        message = msg.notification!.body ?? '';
        unreadCount++; 
        update();
      }
    });

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage msg) {
    //   if (msg.notification != null) {
    //     message = msg.notification!.body ?? '';
    //     unreadCount++;
    //      Get.snackbar(
    //   msg.notification!.title ?? "New Notification",
    //   msg.notification!.body ?? "",
    //   snackPosition: SnackPosition.TOP,
    //   backgroundColor: Colors.black87,
    //   colorText: Colors.white,
    //   duration: Duration(seconds: 3),
    // );
    //     update();
    //   }
    // });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? msg) {
      if (msg != null && msg.notification != null) {
        message = msg.notification!.body ?? '';
        unreadCount++;
        update();
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _sendTokenToServer(String token) async {
    DioHelper.postsData(
      url: '/api/user/update-fcm-token',
      data: {"fcm_token": token},
    ).then((value) {
      print(value!.data);
    }).catchError((error) {
      print(error);
    });
  }

  void resetUnread() {
    unreadCount = 0;
    update();
  }
}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(" Background handler message: ${message.messageId}");
}
