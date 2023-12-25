// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../core/providers/currentuser_provider.dart';
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
    zoom: 16,
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
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: _kathmandu,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return const SizedBox(
                height: 100,
                child: Center(
                    child: Text(
                  'Long press anywhere on the map to set your address!',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                )),
              );
            },
          );
        },
        onLongPress: _onMapLongPress,
        markers: _userMarker != null ? <Marker>{_userMarker!} : {},
      ),
    );
  }

  void _onMapLongPress(LatLng latLng) async {
    try {
      // Reverse geocoding to get the address from coordinates
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

      Placemark place = placemarks.first;

      context.read<CurrentUser>().setAddress(
            latLng.latitude.toDouble(),
            latLng.longitude.toDouble(),
            '${place.name}, ${place.street}, ${place.locality}',
          );

      ScaffoldMessenger.of(context).showSnackBar(
        CstmSnackBar(
          text: 'Location Set: ${place.street}',
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
            snippet: '${place.name}, ${place.street}',
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
