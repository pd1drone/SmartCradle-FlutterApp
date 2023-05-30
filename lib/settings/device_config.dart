import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:smart_cradle/services/device_endpoint_config.dart';

class DeviceConfigPage extends StatefulWidget {
  @override
  _DeviceConfigPageState createState() => _DeviceConfigPageState();
}

class _DeviceConfigPageState extends State<DeviceConfigPage> {
  final ipController = TextEditingController(text: "");

  @override
  void dispose() {
    ipController.dispose();
    super.dispose();
  }

  Future<void> _handleConnect() async {
    
    var ipadd = ipController.text;
    var url = Uri.parse("http://$ipadd:8081/check");

      try {
        print("try");
        final response = await http.get(url, headers:{
          'Access-Control-Allow-Origin' : "*",
          'Content-Type' : "application/json",
        }).timeout(const Duration(seconds: 2));

        if (response.statusCode==200){
            saveEndPoint(ipadd);
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Successfuly Connected to device',style: GoogleFonts.audiowide(color:Colors.white, fontSize: 15)),
                duration: Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
              ),
            );
          }else{
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Invalid Device IP Address. Please enter the correct IP and connect again',style: GoogleFonts.audiowide(color:Colors.white, fontSize: 15)),
                duration: Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
              ),
            );
          }
      } on SocketException catch (e) {
        print("catch");
        print('Error fetching data: $e');
            Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid Device IP Address. Please enter the correct IP and connect again',style: GoogleFonts.audiowide(color:Colors.white, fontSize: 15)),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
          ),
        );
      } catch (e){
        print('Error fetching data: $e');
            Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid Device IP Address. Please enter the correct IP and connect again',style: GoogleFonts.audiowide(color:Colors.white, fontSize: 15)),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
          ),
        );
      } on TimeoutException catch (e){
            Navigator.of(context).pop();
                print('Error fetching data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid Device IP Address. Please enter the correct IP and connect again',style: GoogleFonts.audiowide(color:Colors.white, fontSize: 15)),
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
              "Enter Device IP Address:",
              style: GoogleFonts.audiowide(color: Colors.white, fontSize: 24),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: TextField(
                style: GoogleFonts.audiowide(color: Colors.white),
                controller: ipController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3,color: Colors.white)
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 3,color: Colors.white)
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: _handleConnect,
                child: Text("Connect",style: GoogleFonts.audiowide(color:Colors.black, fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
