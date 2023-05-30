import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_cradle/services/device_endpoint_config.dart';


// DateTime lastTemperatureNotificationTime = DateTime(2018);
// DateTime lastFrontNotificationTime= DateTime(2018);
// DateTime lastRearNotificationTime= DateTime(2018);
// DateTime lastRightNotificationTime= DateTime(2018);
// DateTime lastLeftNotificationTime= DateTime(2018);
// int id = 0;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

    @override
    void initState() {
    super.initState();

      AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(context: context, builder: (BuildContext context) {
          return AlertDialog(title: Text("Allow Notifications"),
        content: Text("Our app would like to send you notifications"),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Don't Allow",style: TextStyle(color: Colors.grey, fontSize: 18),)),
          TextButton(onPressed: (){
            AwesomeNotifications().requestPermissionToSendNotifications().then((_) => Navigator.pop(context));
          }, child: Text("Allow",style: TextStyle(color: Colors.teal, fontSize: 18,fontWeight: FontWeight.bold),))
        ],
        );
      });
      }
    });
  }


    Future<void> _handleConnect() async {
    
    var ipadd = await getEndPoint();
    var url = Uri.parse("http://$ipadd:8081/check");
    print(url);

      try {
        print("try");
        final response = await http.get(url, headers:{
          'Access-Control-Allow-Origin' : "*",
          'Content-Type' : "application/json",
        }).timeout(const Duration(seconds: 2));

        if (response.statusCode==200){
            // Timer.periodic(Duration(seconds: 1), (Timer timer) {
            //     GetSensorValues();
            // });
            Navigator.of(context).pushNamed("dashboard").then((_) => setState(() {}));
          }else{
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Please enter the correct IP and connect to the device first before going to the dashboard',style: GoogleFonts.audiowide(color:Colors.white, fontSize: 15)),
                duration: Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
              ),
            );
          }
      } on SocketException catch (e) {
        print("catch");
        print('Error fetching data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter the correct IP and connect to the device first before going to the dashboard',style: GoogleFonts.audiowide(color:Colors.white, fontSize: 15)),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
          ),
        );
      } catch (e){
        print('Error fetching data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter the correct IP and connect to the device first before going to the dashboard',style: GoogleFonts.audiowide(color:Colors.white, fontSize: 15)),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
          ),
        );
      } on TimeoutException catch (e){
                print('Error fetching data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter the correct IP and connect to the device first before going to the dashboard',style: GoogleFonts.audiowide(color:Colors.white, fontSize: 15)),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
          ),
        );
      }


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 16, 30, 113),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Smart',
              style: GoogleFonts.audiowide(color: Colors.white, fontSize: 72),
            ),
            Text(
              'Cradle',
              style: GoogleFonts.audiowide(color: Colors.white, fontSize: 72),
            ),
            SizedBox(height: 50),
            SizedBox(
              height: 50,
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  //Navigator.of(context).pushNamed("dashboard").then((_) => setState(() {}));
                  _handleConnect();
                },
                child: Text('Dashboard',style: GoogleFonts.audiowide(color:Colors.black, fontSize: 20)),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 50,
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("configureip").then((_) => setState(() {}));
                },
                child: Text('Connect to Device',style: GoogleFonts.audiowide(color: Colors.black, fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


  // void GetSensorValues() async{
  
  // var endpoint = await getEndPoint();
  // var url = Uri.parse('http://$endpoint:8081/temperature');
  // http.Response response = await http.get(url,
  //     headers: {
  //       'Access-Control-Allow-Origin': '*',
  //       'Content-Type': 'application/json'
  //     });

      
  // final Map parsed = json.decode(response.body);
  // print("${response.statusCode}");
  // print(parsed);

  //   if (response.statusCode == 200){
  //     double _temp = double.parse(parsed["temperature"]);
  //     double  _airquality = double.parse(parsed["airQuality"]);
  //     double  _front = double.parse(parsed["front"]);
  //     double  _rear = double.parse(parsed["rear"]);
  //     double  _right = double.parse(parsed["right"]);
  //     double  _left = double.parse(parsed["left"]);

  //     print(_temp);
  //     print(_airquality);
  //     print(_front);
  //     print(_rear);
  //     print(_right);
  //     print(_left);
  //   if (lastTemperatureNotificationTime == null ||
  //         DateTime.now().difference(lastTemperatureNotificationTime).inMinutes >= 5) {
  //     if (_temp > 26.0){
  //         await AwesomeNotifications().createNotification(
  //         content: NotificationContent(
  //           id: id++,
  //           channelKey: 'temperature',
  //           title:'Temperature has reached the threshold of the comfort temperature of the baby' ,
  //           body: 'The temperature has reached ' + _temp.toString() + ' °C.',
  //           notificationLayout: NotificationLayout.Default,
  //           displayOnForeground: true,
  //         ),
  //       );
  //       lastTemperatureNotificationTime = DateTime.now();
  //     }
  //   }

  //   if (lastFrontNotificationTime == null ||
  //         DateTime.now().difference(lastFrontNotificationTime).inMinutes >= 5) {
  //   if(_front < 11){
  //     await AwesomeNotifications().createNotification(
  //       content: NotificationContent(
  //         id: id++,
  //         channelKey: 'temperature',
  //         title: 'Their is an object in the front of the Cradle',
  //         body: 'Object Detected below threshold: '+_front.toString() + ' in front of the cradle',
  //         notificationLayout: NotificationLayout.Default,
  //         displayOnForeground: true,
  //       ),
  //     );
  //     lastFrontNotificationTime = DateTime.now();
  //   }
  //   }
  //   if (lastRearNotificationTime == null ||
  //         DateTime.now().difference(lastRearNotificationTime).inMinutes >= 5) {
  //   if(_rear < 11){
  //     await AwesomeNotifications().createNotification(
  //       content: NotificationContent(
  //         id: id++,
  //         channelKey: 'temperature',
  //         title: 'Their is an object in the rear of the Cradle',
  //         body: 'Object Detected below threshold: '+_rear.toString() + ' in rear of the cradle',
  //         notificationLayout: NotificationLayout.Default,
  //         displayOnForeground: true,
  //       ),
  //     );
  //     lastRearNotificationTime = DateTime.now();
  //   }
  //   }
  //   if (lastRightNotificationTime == null ||
  //         DateTime.now().difference(lastRightNotificationTime).inMinutes >= 5) {
  //   if(_right < 11){
  //     await AwesomeNotifications().createNotification(
  //       content: NotificationContent(
  //         id: id++,
  //         channelKey: 'temperature',
  //         title: 'Their is an object in the right of the Cradle',
  //         body: 'Object Detected below threshold: '+_right.toString() + ' in right of the cradle',
  //         notificationLayout: NotificationLayout.Default,
  //         displayOnForeground: true,
  //       ),
  //     );
  //     lastRightNotificationTime = DateTime.now();
  //   }
  //   }
  //   if (lastLeftNotificationTime == null ||
  //         DateTime.now().difference(lastLeftNotificationTime).inMinutes >= 5) {
  //   if(_left < 11){
  //     await AwesomeNotifications().createNotification(
  //       content: NotificationContent(
  //         id: id++,
  //         channelKey: 'temperature',
  //         title: 'Their is an object in the left of the Cradle',
  //         body: 'Object Detected below threshold: '+_left.toString() + ' in left of the cradle',
  //         notificationLayout: NotificationLayout.Default,
  //         displayOnForeground: true,
  //       ),
  //     );
  //     lastLeftNotificationTime =  DateTime.now();
  //   }
  //   }
  //   }
  // }
  