import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static Future<Position?> getLocation() async {
    PermissionStatus status = await Permission.location.status;

    if (status.isDenied) {
      Permission.location.request();
    } else if (status.isGranted) {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}

class CustomMapWidget extends StatefulWidget {
  final String? lat;
  final String? lan;
  const CustomMapWidget({
    super.key,
    this.lan,
    this.lat,
  });

  @override
  State<CustomMapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<CustomMapWidget> {
  Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();
  Position? position;

  Future<void> getPostion() async {
    if (mounted) {
      Position? position = await LocationService.getLocation();
      setState(() {
        this.position = position;
      });
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    getPostion();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  CameraPosition getCameraPosition() {
    return CameraPosition(
      target: LatLng(position!.latitude, position!.longitude),
      zoom: 17,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: position == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              // myLocationEnabled : true,
              markers: {
                const Marker(
                  markerId: MarkerId('my_unique_marker_id'),
                ),
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: getCameraPosition(),
              onMapCreated: (controller) {
                mapController.complete(controller);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          color: Colors.blue,
          Icons.abc,
        ),
      ),
    );
  }
}
