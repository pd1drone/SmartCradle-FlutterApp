import 'dart:async';
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';

import '../services/device_endpoint_config.dart';
DateTime lastTemperatureNotificationTime = DateTime(2018);
DateTime lastFrontNotificationTime= DateTime(2018);
DateTime lastRearNotificationTime= DateTime(2018);
DateTime lastRightNotificationTime= DateTime(2018);
DateTime lastLeftNotificationTime= DateTime(2018);
int id = 0;


class DashBoardPage extends StatefulWidget {
  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  double maxtemp = 100.0;
  double maxAirQuality = 100;
  double maxDistance = 30;

  double _temp = 0;
  double _airquality = 0;
  double _front = 0;
  double _rear = 0;
  double _left = 0;
  double _right = 0;
  Timer? timer;

  int tapCount = 0;
  String cradleMode = 'Swing Cradle min'; 

  void toggleSwing () async{
    var endpoint = await getEndPoint();
    setState(() async {
      tapCount++;
      if (tapCount == 1) {
        cradleMode = 'Swing Cradle average';
        var url = Uri.parse('http://$endpoint:8081/1');
        http.Response response = await http.get(url,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json'
        });
      } else if (tapCount == 2) {
        cradleMode = 'Swing Cradle max';
        var url = Uri.parse('http://$endpoint:8081/2');
        http.Response response = await http.get(url,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json'
        });
      } else if (tapCount == 3) {
        cradleMode = 'Unswing Cradle';
        var url = Uri.parse('http://$endpoint:8081/3');
        http.Response response = await http.get(url,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json'
        });
      } else if (tapCount == 4) {
        cradleMode = 'Swing Cradle min';
        tapCount = 0;
        var url = Uri.parse('http://$endpoint:8081/0');
        http.Response response = await http.get(url,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json'
        });
      }
      print(tapCount);
    });
  }

  @override
  void initState(){
    super.initState();
    
    GetSensorValues();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      GetSensorValues();
    });
    
  }

  void cancelTimer() {
    if (timer != null) {
      timer?.cancel();
    }
  }

  void GetSensorValues() async{

  var endpoint = await getEndPoint();
  var url = Uri.parse('http://$endpoint:8081/temperature');
  http.Response response = await http.get(url,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json'
      });

      
  final Map parsed = json.decode(response.body);
  print("${response.statusCode}");
  print(parsed);

    if (response.statusCode == 200){
      setState(() {
        _temp = double.parse(parsed["temperature"]);
        _airquality = double.parse(parsed["airQuality"]);
        _front = double.parse(parsed["front"]);
        _rear = double.parse(parsed["rear"]);
        _right = double.parse(parsed["right"]);
        _left = double.parse(parsed["left"]);
      });

      print(_temp);
      print(_airquality);
      print(_front);
      print(_rear);
      print(_right);
      print(_left);

    if (lastTemperatureNotificationTime == null ||
          DateTime.now().difference(lastTemperatureNotificationTime).inMinutes >= 5) {
      if (_temp > 26.0){
          await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: id++,
            channelKey: 'temperature',
            title:'Temperature has reached the threshold of the comfort temperature of the baby' ,
            body: 'The temperature has reached ' + _temp.toString() + ' °C.',
            notificationLayout: NotificationLayout.Default,
            displayOnForeground: true,
          ),
        );
        lastTemperatureNotificationTime = DateTime.now();
      }
    }

    if (lastFrontNotificationTime == null ||
          DateTime.now().difference(lastFrontNotificationTime).inMinutes >= 5) {
    if(_front < 11){
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id++,
          channelKey: 'temperature',
          title: 'Their is an object in the front of the Cradle',
          body: 'Object Detected below threshold: '+_front.toString() + ' in front of the cradle',
          notificationLayout: NotificationLayout.Default,
          displayOnForeground: true,
        ),
      );
      lastFrontNotificationTime = DateTime.now();
    }
    }
    if (lastRearNotificationTime == null ||
          DateTime.now().difference(lastRearNotificationTime).inMinutes >= 5) {
    if(_rear < 11){
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id++,
          channelKey: 'temperature',
          title: 'Their is an object in the rear of the Cradle',
          body: 'Object Detected below threshold: '+_rear.toString() + ' in rear of the cradle',
          notificationLayout: NotificationLayout.Default,
          displayOnForeground: true,
        ),
      );
      lastRearNotificationTime = DateTime.now();
    }
    }
    if (lastRightNotificationTime == null ||
          DateTime.now().difference(lastRightNotificationTime).inMinutes >= 5) {
    if(_right < 11){
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id++,
          channelKey: 'temperature',
          title: 'Their is an object in the right of the Cradle',
          body: 'Object Detected below threshold: '+_right.toString() + ' in right of the cradle',
          notificationLayout: NotificationLayout.Default,
          displayOnForeground: true,
        ),
      );
      lastRightNotificationTime = DateTime.now();
    }
    }
    if (lastLeftNotificationTime == null ||
          DateTime.now().difference(lastLeftNotificationTime).inMinutes >= 5) {
    if(_left < 11){
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id++,
          channelKey: 'temperature',
          title: 'Their is an object in the left of the Cradle',
          body: 'Object Detected below threshold: '+_left.toString() + ' in left of the cradle',
          notificationLayout: NotificationLayout.Default,
          displayOnForeground: true,
        ),
      );
      lastLeftNotificationTime =  DateTime.now();
    }
    }
    }
  }
  @override
  void dispose() {
    // Cancel the Timer when the page is no longer active
    timer?.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 16, 30, 113),
      body: Center(
        child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Text(
                'Smart Cradle',
                style: GoogleFonts.audiowide(color: Colors.white, fontSize: 35,fontWeight: FontWeight.bold),
              ),
              Text(
                'Environment',
                style: GoogleFonts.audiowide(color: Colors.white, fontSize: 35,fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: new LinearPercentIndicator(
                  width: 165,
                  animation: true,
                  leading: Text("Temperature:  ",style: GoogleFonts.audiowide(color:Colors.white, fontSize: 20)),
                  center: Text(_temp.toString()+" °C",style: GoogleFonts.audiowide(color:Colors.black, fontSize: 20)),
                  lineHeight: 25,
                  animationDuration: 0,
                  percent: _temp/maxtemp,
                  barRadius: Radius.circular(9.0),
                  progressColor: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: new LinearPercentIndicator(
                  width: 165,
                  animation: true,
                  leading: Text("Air Quality:      ",style: GoogleFonts.audiowide(color:Colors.white, fontSize: 20)),
                  center: Text(_airquality.toString()+" %",style: GoogleFonts.audiowide(color:Colors.black, fontSize: 20)),
                  lineHeight: 25,
                  animationDuration: 0,
                  percent: _airquality/100,
                  barRadius: Radius.circular(9.0),
                  progressColor: Colors.white,
                ),
              ),
              SizedBox(height: 26),
              Row(
                children: [
                   Text("   Object Detected",style: GoogleFonts.audiowide(color:Colors.white, fontSize: 15,fontWeight:FontWeight.bold ,)),
                   Text("       Distance (in)",style: GoogleFonts.audiowide(color:Colors.white, fontSize: 15,fontWeight:FontWeight.bold )),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: new LinearPercentIndicator(
                  width: 165,
                  animation: true,
                  leading: Text("Front Side:      ",style: GoogleFonts.audiowide(color:Colors.white, fontSize: 20)),
                  center: Text(_front.toString()+" in",style: GoogleFonts.audiowide(color:Colors.black, fontSize: 20)),
                  lineHeight: 25,
                  animationDuration: 0,
                  percent: _front/maxDistance,
                  barRadius: Radius.circular(9.0),
                  progressColor: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: new LinearPercentIndicator(
                  width: 165,
                  animation: true,
                  leading: Text("Left Side:        ",style: GoogleFonts.audiowide(color:Colors.white, fontSize: 20)),
                  center: Text(_left.toString()+" in",style: GoogleFonts.audiowide(color:Colors.black, fontSize: 20)),
                  lineHeight: 25,
                  animationDuration: 0,
                  percent: _left/maxDistance,
                  barRadius: Radius.circular(9.0),
                  progressColor: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: new LinearPercentIndicator(
                  width: 165,
                  animation: true,
                  leading: Text("Right Side:      ",style: GoogleFonts.audiowide(color:Colors.white, fontSize: 20)),
                  center: Text(_right.toString()+" in",style: GoogleFonts.audiowide(color:Colors.black, fontSize: 20)),
                  lineHeight: 25,
                  animationDuration: 0,
                  percent: _right/maxDistance,
                  barRadius: Radius.circular(9.0),
                  progressColor: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: new LinearPercentIndicator(
                  width: 165,
                  animation: true,
                  leading: Text("Rear Side:       ",style: GoogleFonts.audiowide(color:Colors.white, fontSize: 20)),
                  center: Text(_rear.toString()+" in",style: GoogleFonts.audiowide(color:Colors.black, fontSize: 20)),
                  lineHeight: 25,
                  animationDuration: 0,
                  percent: _rear/maxDistance,
                  barRadius: Radius.circular(9.0),
                  progressColor: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
              height: 50,
              width: 350,
              child: ElevatedButton(
                onPressed: () {
                  toggleSwing();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(tapCount == 3 ? Icons.stop : Icons.start),
                    Text(
                      '  $cradleMode',
                      style: GoogleFonts.audiowide(color: Colors.black, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
         Navigator.of(context).pop();
      },
      child: const Icon(Icons.arrow_back),
      ),
    );
  }
}