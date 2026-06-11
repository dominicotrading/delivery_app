import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:marocsie/app/theme/colors.dart';

class NotificationController {
  static ReceivedAction? initialAction;

  ///  *********************************************
  ///     INITIALIZATIONS
  ///  *********************************************
  ///
  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
        'resource://drawable/ic_launcher', //
        [
          NotificationChannel(
              channelKey: 'marcoci-notifymax',
              channelName: 'Notification',
              channelDescription: "Notification Awesome",
              defaultColor: primaryColor,
              ledColor: primaryColor,
              channelShowBadge: true,
              playSound: true,
              enableLights: true,
              enableVibration: true,
              importance: NotificationImportance.Max,
              vibrationPattern: highVibrationPattern),
        ]);

    // Get initial notification action is optional
    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS LISTENER
  ///  *********************************************
  ///  Notifications events are only delivered after call this method
  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS
  ///  *********************************************
  ///
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
if (receivedAction.payload!["payload_type"] == "payment-aproved") {
      // Navigator.pushReplacement(navigationState.currentContext!,
      //     DefaultPageRouteBuilder(widget: const CreditScreen()));
    }
     else if (receivedAction.payload!["payload_type"] == "withdrawal") {
      // Navigator.pushNamed(navigationState.currentContext!,DashBoardScreen.routeName);
    }else if(receivedAction.payload!["payload_type"] == "appointment-booked"){
    }else if(receivedAction.payload!["payload_type"] == "appointment-replied"){
    }
  }

  ///  *********************************************
  ///     BACKGROUND TASKS TEST
  ///  *********************************************
  static Future<void> executeLongTaskInBackground() async {
    print("starting long task");
    await Future.delayed(const Duration(seconds: 4));
    const url = "http://google.com";
    final re = await Dio().get(url);
    print(re.data);
    print("long task done");
  }

  ///  *********************************************
  ///     NOTIFICATION CREATION METHODS
  ///  *********************************************

  static showProfileNotification(Map<String, dynamic> data) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: data["id"],
          channelKey: 'marcoci-notifymax',
          title: data["title"],
          body: data["body"],
          payload: {"payload_type": data["payload_type"]},
          category: NotificationCategory.Event,
          icon: 'resource://drawable/ic_launcher',
          notificationLayout: NotificationLayout.Inbox),
    );
  }

  static showWelcomeNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 43,
          channelKey: 'marcoci-notifymax',
          title: "Welcome to Terapi App",
          body:
              "We see you have created a new account, we want all the best for you.",
          notificationLayout: NotificationLayout.Inbox),
    );
  } 
  static Future<void> showAdNotification(Map<String, dynamic> addInfo) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 101, // -1 is replaced by a random number
          channelKey: 'marcoci-notifymax',
          title: addInfo['title'],
          bigPicture: addInfo['ad_gif'],
          notificationLayout: NotificationLayout.BigPicture,
          payload: {'notificationId': '1234567890'}),
    );
  }

  static Future<void> createNewNotification() async {
    // bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    // if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 1, // -1 is replaced by a random number
            channelKey: 'marcoci-notifymax',
            title: 'Huston! The eagle has landed!',
            body:
                "A small step for a man, but a giant leap to Flutter's community!",
            bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
            // largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
            //'asset://assets/images/balloons-in-sky.jpg',
            notificationLayout: NotificationLayout.BigPicture,
            payload: {'notificationId': '1234567890'}),
        actionButtons: [
          NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
          NotificationActionButton(
              key: 'REPLY',
              label: 'Reply Message',
              requireInputText: true,
              actionType: ActionType.SilentAction),
          NotificationActionButton(
              key: 'DISMISS',
              label: 'Dismiss',
              actionType: ActionType.DismissAction,
              isDangerousOption: true)
        ]);
  }

  static Future<void> scheduleNewNotification() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: -1, // -1 is replaced by a random number
            channelKey: 'alerts',
            title: "Huston! The eagle has landed!",
            body:
                "A small step for a man, but a giant leap to Flutter's community!",
            bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
            notificationLayout: NotificationLayout.BigPicture,
            payload: {
              'notificationId': '1234567890'
            }),
        actionButtons: [
          NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
          NotificationActionButton(
              key: 'DISMISS',
              label: 'Dismiss',
              actionType: ActionType.DismissAction,
              isDangerousOption: true)
        ],
        schedule: NotificationCalendar.fromDate(
            date: DateTime.now().add(const Duration(seconds: 10))));
  }

  static Future<void> resetBadgeCounter() async {
    await AwesomeNotifications().resetGlobalBadge();
  }

  static Future<void> cancelNotifications() async {
    await AwesomeNotifications().cancelAll();
  }
}
