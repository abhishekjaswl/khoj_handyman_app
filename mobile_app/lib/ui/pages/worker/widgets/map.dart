import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class CstmMap extends StatefulWidget {
  final double latitude;
  final double longitude;
  final bool myLocation;
  const CstmMap(
      {super.key,
      required this.latitude,
      required this.longitude,
      required this.myLocation});

  @override
  State<CstmMap> createState() => _CstmMapState();
}

class _CstmMapState extends State<CstmMap> {
  late double _latitude;
  late double _longitude;
  late bool _myLocation;
  late CameraPosition _initPosition;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Marker? _userMarker;

  Future<void> _checkLocationPermission() async {
    var status = await Permission.location.status;
    if (status != PermissionStatus.granted) {
      await Permission.location.request();
    }
  }

  @override
  void initState() {
    super.initState();
    _latitude = widget.latitude;
    _longitude = widget.longitude;
    _myLocation = widget.myLocation;
    _checkLocationPermission();
    _userMarker = Marker(
      markerId: const MarkerId("user_marker"),
      position: LatLng(_latitude, _longitude),
    );

    _initPosition = CameraPosition(
      target: LatLng(_latitude, _longitude),
      zoom: 18,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      myLocationEnabled: _myLocation,
      myLocationButtonEnabled: _myLocation,
      zoomControlsEnabled: _myLocation,
      zoomGesturesEnabled: _myLocation,
      scrollGesturesEnabled: _myLocation,
      mapType: MapType.normal,
      initialCameraPosition: _initPosition,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: _userMarker != null ? <Marker>{_userMarker!} : {},
    );
  }
}
