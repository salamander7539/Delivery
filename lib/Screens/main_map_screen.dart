import 'dart:async';

import 'package:faem_app/Models/FindAddressModel.dart';
import 'package:faem_app/Post/findAddress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:faem_app/Location/user_location.dart';
import '../app.dart';
import 'package:provider/provider.dart';
import 'Drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'create_order_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:geocoder/geocoder.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  MapController mapController;
  LatLng centerPos;
  var newAddress;
  bool moveOver;
  bool visible;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mapController = MapController();
    centerPos = new LatLng(position.latitude, position.longitude);

    newAddress = first;
    moveOver = true;
    visible = true;
  }

  changeLocation(newPosLat, newPosLng) async {
    var lat = double.parse(newPosLat.toStringAsFixed(4));
    var lng = double.parse(newPosLng.toStringAsFixed(4));
    final coordinates = new Coordinates(lat, lng);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    newAddress = addresses.first;
    // print('${newAddress.thoroughfare}, ${newAddress.subThoroughfare}');
  }

  _openCreateOrder() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.7,
        child: CreateOrder(),
      ),
    );
  }

  var addValue;

  @override
  Widget build(BuildContext context) {
    final String faemPoint = 'assets/svg_images/faemPoint.svg';
    final Widget faemSvg = SvgPicture.asset(
      faemPoint,
      semanticsLabel: 'Faem Point',
      color: Color(0xFFFD6F6D),
    );
    final String clientPoint = 'assets/svg_images/clientPoint.svg';
    final Widget clientSvg = SvgPicture.asset(
      clientPoint,
      semanticsLabel: 'Client Point',
    );
    final String locationArrow = 'assets/svg_images/location_arrow.svg';
    final Widget locationArrowSvg = SvgPicture.asset(
      locationArrow,
      semanticsLabel: 'Client Point',
    );

    var userLocation = Provider.of<UserLocation>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        // leading: IconButton(
        //   onPressed: () {
        //     Scaffold.of(context).openDrawer();
        //   },
        //   icon: Icon(Icons.menu),
        //   color: Colors.black,
        // ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, -1), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(28.0),
                color: Colors.white,
              ),
              child: FlatButton(
                child: Container(
                  child: Text('Далее'),
                ),
                onPressed: () {
                  print('TAP');
                },
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: MainDrawer(),
      ),
      body: Stack(
        children: [
          new FlutterMap(
            options: new MapOptions(
              onPositionChanged: (newPosition, check) {
                setState(() {
                  centerPos = newPosition.center;
                  changeLocation(newPosition.center.latitude,
                      newPosition.center.longitude);
                });
                FutureBuilder<FindAddressData>(
                  future: findAddress(
                      double.parse(newPosition.center.latitude.toStringAsFixed(4)),  double.parse(newPosition.center.longitude.toStringAsFixed(4))),
                  // ignore: missing_return
                  builder: (context, AsyncSnapshot<FindAddressData> snapshot) {
                  },
                );
                visible = false;
                // print(centerPos);
              },
              controller: mapController,
              center: new LatLng(position.latitude, position.longitude),
              zoom: 17.0,
              minZoom: 10.0,
            ),
            mapController: mapController,
            layers: [
              new TileLayerOptions(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/faemtaxi/ck0fcruqn1p9o1cnzazi3pli9/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZmFlbXRheGkiLCJhIjoiY2pyYXNqZ3RhMHQxNTQ5bjBxMWlvcWF6eSJ9.ISSgNBMdG7idL3ljb2ILTg",
                additionalOptions: {
                  'accessToken':
                      'pk.eyJ1IjoiZmFlbXRheGkiLCJhIjoiY2pyYXNqZ3RhMHQxNTQ5bjBxMWlvcWF6eSJ9.ISSgNBMdG7idL3ljb2ILTg',
                  'id': 'mapbox.mapbox-traffic-v1'
                },
              ),
              new MarkerLayerOptions(
                markers: [
                  new Marker(
                    width: 25.0,
                    height: 25.0,
                    point: new LatLng(position.latitude, position.longitude),
                    builder: (context) => new Container(
                      child: clientSvg,
                    ),
                  ),
                  new Marker(
                    width: 120.0,
                    height: 120.0,
                    point:
                        new LatLng(centerPos.latitude, centerPos.longitude),
                    builder: (context) => new Container(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(bottom: 55.0, left: 24.5),
                        child: faemSvg,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 150.0),
              child: FutureBuilder<FindAddressData>(
                future: findAddress(
                    double.parse(centerPos.latitude.toStringAsFixed(4)),
                    double.parse(centerPos.longitude.toStringAsFixed(4)),
                  ),
                  // ignore: missing_return
                  builder: (context, AsyncSnapshot<FindAddressData> snapshot){
                  findAddressController.text = snapshot.data.unrestrictedValue;
                  return Text(
                    '${snapshot.data.unrestrictedValue}',
                    // '${newAddress.thoroughfare}, ${newAddress.subThoroughfare}',
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                  );
                }
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(right: 15.0, top: 40.0),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 90.0, right: 16.0),
              child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      mapController.move(
                          new LatLng(position.latitude, position.longitude),
                          mapController.zoom);
                    });
                  },
                  shape: CircleBorder(),
                  child: Center(
                    child: locationArrowSvg,
                  )),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: 52.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: FlatButton(
                  onPressed: () async {
                    // await findAddress(centerPos.latitude, centerPos.longitude);
                    // findAddressController.text = addressValue;
                    await _openCreateOrder();
                  },
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          color: Color(0xFF409AFF),
                        ),
                        Text(
                          'Куда?',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
