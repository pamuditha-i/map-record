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
  List<LocationResult> locations = [];  //three variables , a list , a stream sub , a boolean var //list of the GPS locations
  StreamSubscription<LocationResult> streamSubscription; // data streamed by the service
  bool trackLocation = false;         //true when we track the location using GPS

  @override
  initState() {
    super.initState();
    checkGps();

    trackLocation = false;
    locations = [];
  }

   getLocations(){
      if (trackLocation) {
        setState(() => trackLocation = false);
        streamSubscription.cancel();      // the part of the function that used to turn off the GPS stream service
        streamSubscription = null;        // make it zero
        print(locations);
        locations = [];
      }
      else{                               // if the GPS tracking part is not running this is used to turn it on
        setState(() => trackLocation = true);

        streamSubscription = Geolocation
              .locationUpdates(
            accuracy: LocationAccuracy.best,
            displacementFilter: 0.0,      // set up the variance when the location updates will come through
                                          // at zero, it will feed us data regardless of we move our GPS location or not
            inBackground: false,            // whether we run it in the background or not
        )
            .listen((result) {               // this call back fn will get the result & pass it back to us
          final location = result;        // the final var in the listener
          setState(() {
            locations.add(location);      // call the locations and add the new address to it
          });
        });

        streamSubscription.onDone(() => setState(() {       // run when the streamsubs is finished
          trackLocation = false;
        }));
      }
   }



  checkGps() async {
      final GeolocationResult result = await Geolocation.isLocationOperational();
      if (result.isSuccessful) {
        print("ProcessSucceeded");
      } else {
        print("ProcessFailed");
      }
    }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GeoLocation Example'),
        actions: <Widget>[
          FlatButton(
            child: Text("Get Location"),
            onPressed: getLocations,
          )
        ],
      ),
      body: Center(
        child: Container(
          child: ListView(
            children: locations
                .map((loc) => ListTile(
                    title: Text(
                        "Current Location: ${loc.location.longitude} : ${loc.location.latitude}"),
                   subtitle: Text(
                        "Current Altitude: ${loc.location.altitude}"),
            ))
              .toList(),
          )
        )
      ),
    );
  }
}