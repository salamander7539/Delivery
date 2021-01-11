import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import "package:latlong/latlong.dart";
import 'package:geocoder/geocoder.dart';
import 'package:faem_app/Location/user_location.dart';
import '../app.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}


class _MapScreenState extends State<MapScreen> {
  Position position;

  void getLocation() async {
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var lastPosition = await Geolocator.getLastKnownPosition();
    print(lastPosition);
      setState(() {
        lat = position.latitude;
        lng = position.longitude;
      });
    print('Current location lat long ' + position.latitude.toString() + " - " + position.longitude.toString());
    final coordinates = new Coordinates(
        position.latitude, position.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        coordinates);
    var first = addresses.first;
    print('${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
  }

  Widget sideMenu() {
    return ListView(
      children: [
        DrawerHeader(child: Text('Введите номер телефона'),),
        ListTile(
          title: Text('Способы оплаты'),
        ),
        Visibility(
          visible: false,
          child: ListTile(
            title: Text('Бонусы'),
          ),
        ),
        Visibility(
          visible: false,
          child: ListTile(
            title: Text('История поездок'),
          ),
        ),
        Visibility(
          visible: false,
          child: ListTile(
            title: Text('Мои адреса'),
          ),
        ),
        ListTile(
          title: Text('Настройки'),
        ),
        ListTile(
          title: Text('Информация'),
        ),
        ListTile(
          title: Text('Служба поддержки'),
        ),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
        getLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    var userLocation = Provider.of<UserLocation>(context);
    return Scaffold(
      appBar: AppBar(
        leading: RaisedButton(
          child: Icon(
            Icons.menu,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
      ),
      drawer: Drawer(
        child: sideMenu(),
      ),
      body: Stack(
        children: [
          new FlutterMap(
            options: new MapOptions(
              center: new LatLng(position.latitude, position.longitude), minZoom: 10.0,),
            layers: [
              new TileLayerOptions(
                  urlTemplate:
                  "https://api.mapbox.com/styles/v1/faemtaxi/ck0fcruqn1p9o1cnzazi3pli9/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZmFlbXRheGkiLCJhIjoiY2pyYXNqZ3RhMHQxNTQ5bjBxMWlvcWF6eSJ9.ISSgNBMdG7idL3ljb2ILTg",
                  additionalOptions: {
                    'accessToken': 'pk.eyJ1IjoiZmFlbXRheGkiLCJhIjoiY2pyYXNqZ3RhMHQxNTQ5bjBxMWlvcWF6eSJ9.ISSgNBMdG7idL3ljb2ILTg',
                    'id': 'mapbox.mapbox-traffic-v1'
                  },
              ),
              new MarkerLayerOptions(
                markers: [
                  new Marker(
                    width: 45.0,
                    height: 45.0,
                    point: new LatLng(position.latitude, position.longitude),
                    builder: (context) =>
                    new Container(
                      child: IconButton(
                        icon: Icon(Icons.location_on),
                        color: Colors.red,
                        iconSize: 45.0,
                        onPressed: () {
                          print('marker taped');
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
