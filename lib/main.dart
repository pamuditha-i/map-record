import 'package:flutter/material.dart';
import 'package:geolocation/geolocation.dart';

import 'dart:async';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Example',
      theme: ThemeData.dark(),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  initState() {
    super.initState();
    checkGps();
  }

    checkGps() async {
      final GeolocationResult result = await Geolocation.isLocationOperational();
      if (result.isSuccessful) {
        print("Success");
      } else {
        print("Failedd");
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GeoLocation Example'),
      ),
      body: Container(),
    );
  }
}