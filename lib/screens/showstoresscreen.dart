import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:groceries_pick_up_app/screens/addstoresscreen.dart';
import 'package:location/location.dart';

class ShowStores extends StatefulWidget {
  final Function jwtOrEmpty;
  const ShowStores({Key key, this.jwtOrEmpty}) : super(key: key);

  @override
  _ShowStoresState createState() => _ShowStoresState();
}

class _ShowStoresState extends State<ShowStores> {
  Completer<GoogleMapController> _controller = Completer();
  static final LatLng _center = LatLng(22.5937, 78.9629);
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: _center,
    zoom: 5,
  );
  LatLng _lastMapPosition = _center;
  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocationPermissionandMoveToTheLocation();
  }

  void getLocationPermissionandMoveToTheLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(_locationData.latitude, _locationData.longitude),
      zoom: 17.00,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => SingleChildScrollView(
              child: AddStoreScreen(
                coordinates: [
                  _lastMapPosition.latitude,
                  _lastMapPosition.longitude,
                ],
                jwtOrEmpty: widget.jwtOrEmpty,
              ),
            ),
          );
        },
        child: Icon(Icons.add_shopping_cart),
      ),
      body: Container(
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onCameraMove: _onCameraMove,
            ),
            Center(
              child: Image.asset(
                'assets/mappin.png',
                width: 40.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
