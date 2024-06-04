import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

requestPermissionNotification() async {
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
}

fcmconfig() {
  FirebaseMessaging.onMessage.listen((message) {
    print("==================varsler");
    print(message.notification!.title);
    print(message.notification!.body);

    Get.snackbar(message.notification!.title!, message.notification!.body!);
    //FlutterRingtonePlayer.playNotification();
  });
}
