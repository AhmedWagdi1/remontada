import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/utils/extentions.dart';

import '../../../../core/theme/light_theme.dart';

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
      target: LatLng(
        widget.lat.toDouble(),
        widget.lan.toDouble(),
      ),
      zoom: 17,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: position == null
          ? Center(child: CircularProgressIndicator())
          : Stack(children: [
              GoogleMap(
                // myLocationEnabled : true,
                markers: {
                  Marker(
                    markerId: MarkerId('marker_1'),
                    position: LatLng(
                      widget.lat.toDouble(),
                      widget.lan.toDouble(),
                    ),
                    // infoWindow: InfoWindow(
                    //   title: 'My Marker',
                    //   snippet: 'نادي القصيم الرياضي',
                    // ),
                    icon: BitmapDescriptor.defaultMarker,
                  ),
                },
                // circles: {
                //   Circle(
                //     circleId: CircleId('currentLocation'),
                //     center: LatLng(position!.latitude, position!.longitude),
                //     radius: 2, // يمكنك ضبط نصف القطر هنا
                //     strokeColor: Colors.blue,
                //     fillColor: Colors.blue.withOpacity(0.5),
                //     strokeWidth: 1,
                //   ),
                // },
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                initialCameraPosition: getCameraPosition(),
                onMapCreated: (controller) {
                  mapController.complete(controller);
                },
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Row(
                  children: [
                    FloatingActionButton(
                      backgroundColor: LightThemeColors.primary,
                      shape: CircleBorder(),
                      onPressed: () async {
                        final GoogleMapController controller =
                            await mapController.future;
                        controller.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              bearing: 192.8334901395799,
                              zoom: 19.151926040649414,
                              target: LatLng(
                                widget.lat.toDouble(),
                                widget.lan.toDouble(),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Icon(
                        color: Colors.white,
                        Icons.navigation_rounded,
                      ),
                    ),
                    10.pw,
                    FloatingActionButton(
                      backgroundColor: LightThemeColors.primary,
                      shape: CircleBorder(),
                      onPressed: () async {
                        final GoogleMapController controller =
                            await mapController.future;
                        controller.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              bearing: 192.8334901395799,
                              zoom: 19.151926040649414,
                              target: LatLng(
                                position!.latitude,
                                position!.longitude,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Icon(
                        color: Colors.white,
                        Icons.my_location,
                      ),
                    ),
                  ],
                ),
              ),
            ]),
    );
  }
}
