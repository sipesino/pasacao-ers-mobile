import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:pers/main.dart';
import 'package:pers/src/models/incident_report.dart';
import 'package:pers/src/models/operation.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/models/shared_prefs.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  flutterLocalNotificationsPlugin.show(
    message.hashCode,
    message.data['title'],
    message.data['body'],
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: 'channel description',
        color: Colors.blue,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('alert_sound'),
        icon: '@mipmap/ic_launcher',
      ),
    ),
  );
  saveOperation(message);
  await Firebase.initializeApp();
}

void saveOperation(RemoteMessage message) {
  Map<String, dynamic> data = jsonDecode(message.data['"operation"']);
  final operation = Operation(
    operation_id: data['operation_id'],
    report: IncidentReport(
      incident_id: data['incident_id'],
      description: data['description'],
      incident_type: data['incident_type'],
      name: data['name'],
      sex: data['sex'],
      age: data['age'],
      victim_status: data['victim_status'],
      landmark: data['landmark'],
    ),
  );
  SharedPref().save('gotNewOperation', 'true');
  SharedPref().save('operation', operation);
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.max,
  sound: RawResourceAndroidNotificationSound('alert_sound'),
  playSound: true,
);

void setupFcm(void Function(String) onNewOperation) {
  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOs = const IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOs,
  );

  //when the app is in foreground state and you click on notification.
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) {
    if (payload != null) {
      print('>>> Payload: $payload');
      print('>>> Converting to map');
      Map<String, dynamic> data = json.decode(payload);
      print('>>> Successfully converted');
      goToNextScreen(data);
    }
  });

  //When the app is terminated, i.e., app is neither in foreground or background.
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    //Its compulsory to check if RemoteMessage instance is null or not.
    if (message != null) {
      flutterLocalNotificationsPlugin.show(
        message.hashCode,
        message.data['title'],
        message.data['body'],
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: 'channel description',
            color: Colors.blue,
            playSound: true,
            sound: RawResourceAndroidNotificationSound('alert_sound'),
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: message.data['"operation"'],
      );
      // goToNextScreen(message.data);
      onNewOperation(message.data['"operation"']);
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    saveOperation(message);
    onNewOperation(message.data['"operation"']);
    flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: 'channel description',
          color: Colors.blue,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('alert_sound'),
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: message.data['"operation"'],
    );
  });

  //When the app is in the background, but not terminated.
  FirebaseMessaging.onMessageOpenedApp.listen(
    (message) {
      if (message != null) {
        saveOperation(message);
        goToNextScreen(message.data['"operation"']);
      }
    },
    cancelOnError: false,
    onDone: () {},
  );
}

Future<void> deleteFcmToken() async {
  return await FirebaseMessaging.instance.deleteToken();
}

Future<String> getFcmToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  return Future.value(token);
}

void goToNextScreen(Map<String, dynamic> data) {
  if (data != null) {
    IncidentReport report = IncidentReport.fromMap(data);
    Operation operation = Operation.fromMap(data);

    print('>>> Report: $report');
    print('>>> Operation: $operation');
    navigatorKey.currentState?.pushNamed(
      '/responder/home/new_operation',
      arguments: ScreenArguments(
        incident_report: report,
        operation: operation,
      ),
    );
    return;
  }
}

Future<String> _base64encodedImage(String url) async {
  final http.Response response = await http.get(Uri.parse(url));
  final String base64Data = base64Encode(response.bodyBytes);
  return base64Data;
}
