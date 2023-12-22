import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mobile_app/ui/widgets/cstm_button.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../widgets/cstm_snackbar.dart';

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

  Marker? _userMarker;

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
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            const Text(
              'Long press on the map to set your location.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            SizedBox(
              height: 580,
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
            const Spacer(),
            CstmButton(
              text: 'Submit KYC',
              leadingIcon: const Icon(
                Icons.drive_folder_upload,
                color: Colors.white,
              ),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }

  void _onMapLongPress(LatLng latLng) async {
    try {
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

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        CstmSnackBar(
          text: 'Street Name: $street',
          type: 'success',
        ),
      );

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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        CstmSnackBar(
          text: 'Couldn not get the location. Try again!',
          type: 'error',
        ),
      );
    }
  }
}
