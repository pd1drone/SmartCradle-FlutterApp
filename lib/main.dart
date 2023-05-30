import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smart_cradle/services/device_endpoint_config.dart';
import 'package:smart_cradle/settings/device_config.dart';

import 'dashboard/dashboard_page.dart';
import 'home/home_page.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:async';

import 'package:http/http.dart' as http;

Future<void> main() async {

  await AwesomeNotifications().initialize('resource://drawable/ic_launcher', [
      NotificationChannel(
        channelKey: 'temperature',
        channelName: 'temperature',
        channelDescription: 'Notification channels',
        defaultColor: Colors.blue,
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        playSound: true,
        enableLights: true,
        enableVibration: true,
        channelShowBadge: true,
      ),
      NotificationChannel(
        channelKey: 'front',
        channelName: 'front',
        channelDescription: 'Notification channels',
        defaultColor: Colors.blue,
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        playSound: true,
        enableLights: true,
        enableVibration: true,
        channelShowBadge: true,
      ),
      NotificationChannel(
        channelKey: 'rear',
        channelName: 'rear',
        channelDescription: 'Notification channels',
        defaultColor: Colors.blue,
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        playSound: true,
        enableLights: true,
        enableVibration: true,
        channelShowBadge: true,
      ),
      NotificationChannel(
        channelKey: 'right',
        channelName: 'right',
        channelDescription: 'Notification channels',
        defaultColor: Colors.blue,
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        playSound: true,
        enableLights: true,
        enableVibration: true,
        channelShowBadge: true,
      ),
      NotificationChannel(
        channelKey: 'left',
        channelName: 'left',
        channelDescription: 'Notification channels',
        defaultColor: Colors.blue,
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        playSound: true,
        enableLights: true,
        enableVibration: true,
        channelShowBadge: true,
      )
    ], channelGroups: [
      NotificationChannelGroup(
          channelGroupName: 'temperature', channelGroupKey: 'temperature'),
          NotificationChannelGroup(
          channelGroupName: 'temperature', channelGroupKey: 'front'),
          NotificationChannelGroup(
          channelGroupName: 'temperature', channelGroupKey: 'rear'),
          NotificationChannelGroup(
          channelGroupName: 'temperature', channelGroupKey: 'right'),
          NotificationChannelGroup(
          channelGroupName: 'temperature', channelGroupKey: 'left')
    ]);


  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());

  var endpoint = await getEndPoint();
  if (endpoint == ""){
    saveEndPoint("192.168.254.170");
  }
}
const MaterialColor white = const MaterialColor(
  0xFFFFFFFF,
  const <int, Color>{
    50: const Color(0xFFFFFFFF),
    100: const Color(0xFFFFFFFF),
    200: const Color(0xFFFFFFFF),
    300: const Color(0xFFFFFFFF),
    400: const Color(0xFFFFFFFF),
    500: const Color(0xFFFFFFFF),
    600: const Color(0xFFFFFFFF),
    700: const Color(0xFFFFFFFF),
    800: const Color(0xFFFFFFFF),
    900: const Color(0xFFFFFFFF),
  },
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: white,
      ),
      home:  HomePage(),
      routes: {
        'home': (context) =>  HomePage(),
        'configureip': (context) => DeviceConfigPage(),
        'dashboard': (context) => DashBoardPage(),
      },
    );
  }
}


