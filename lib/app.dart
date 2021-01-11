import 'package:faem_app/Location/user_location.dart';
import 'package:faem_app/Screens/auth_phone_screen.dart';
import 'package:faem_app/Screens/main_map_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'Screens/auth_code_screen.dart';

var milliseconds, lat, lng;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    milliseconds = stopwatch.elapsedMicroseconds;
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserLocation>(
      create: (context) => LocationService().locationStream,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xFF67C070),
          cursorColor: Color(0xFF67C070),
          unselectedWidgetColor: Color(0xFF67C070),
          selectedRowColor: Color(0xFF67C070),
          toggleableActiveColor: Color(0xFF67C070),
        ),
        home: MapScreen(),
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
      ),
    );
  }
}
