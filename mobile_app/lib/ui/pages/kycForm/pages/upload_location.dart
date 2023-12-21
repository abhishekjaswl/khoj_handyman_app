import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart'; // Import the geocoding package
import 'package:mobile_app/ui/widgets/cstm_button.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadLocation extends StatefulWidget {
  const UploadLocation({Key? key}) : super(key: key);

  @override
  State<UploadLocation> createState() => _UploadLocationState();
}

class _UploadLocationState extends State<UploadLocation> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kathmandu = CameraPosition(
    target: LatLng(27.7172, 85.3240),
    zoom: 15,
  );

  Marker? _userMarker; // Variable to hold the user's marker

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    var status = await Permission.location.status;
    if (status != PermissionStatus.granted) {
      await Permission.location.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Text(
              'Long press on the map to set your location.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 600,
              child: Card(
                child: GoogleMap(
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  mapType: MapType.normal,
                  initialCameraPosition: _kathmandu,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  onLongPress: _onMapLongPress,
                  markers: _userMarker != null ? <Marker>{_userMarker!} : {},
                ),
              ),
            ),
            CstmButton(text: 'Submit', onPressed: () {})
          ],
        ),
      ),
    );
  }

  void _onMapLongPress(LatLng latLng) async {
    print('Location: $latLng');
    print('Latitude: ${latLng.latitude}');
    print('Longitude: ${latLng.longitude}');

    // Reverse geocoding to get the address from coordinates
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    String locationName = placemarks.first.name ?? "Unknown Location";
    String street = placemarks.first.street ?? "Unknown Location";

    print('Location Name: $locationName');
    print('Street Name: $street');

    // Remove existing marker if it exists
    if (_userMarker != null) {
      setState(() {
        _userMarker = null;
      });
    }

    // Add a new marker to the map
    setState(() {
      _userMarker = Marker(
        markerId: MarkerId(latLng.toString()),
        position: latLng,
        infoWindow: InfoWindow(
          title: 'Your Address',
          snippet: '$locationName, $street',
        ),
      );
    });
  }
}
