import 'package:flutter/material.dart';

import 'map.dart';

class UserLocation extends StatefulWidget {
  final double latitude;
  final double longitude;
  const UserLocation(
      {super.key, required this.latitude, required this.longitude});

  @override
  State<UserLocation> createState() => _UserLocationState();
}

class _UserLocationState extends State<UserLocation> {
  late double _latitude;
  late double _longitude;
  @override
  void initState() {
    super.initState();
    _latitude = widget.latitude;
    _longitude = widget.longitude;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Location')),
      body: CstmMap(
        latitude: _latitude,
        longitude: _longitude,
        myLocation: true,
      ),
    );
  }
}
