import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/shared/widgets/customtext.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/light_theme.dart';

class LocationService {
  static Future<Position?> getLocation() async {
    PermissionStatus status = await Permission.location.status;

    if (status.isDenied) {
      await Permission.location.request();
      print("status0 $status");
    } else if (status.isGranted) {
      print("status1 $status");
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
    // if(mounted){
    //   mapController.dispose();
    // }
    if (mounted) {
      super.dispose();
    }
  }

  void openGoogleMaps(
      {required double latitude, required double longitude}) async {
    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } else {
      throw 'Could not open the map.';
    }
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
      appBar: AppBar(
        title: CustomText(
          "عرض اللوكيشن",
          weight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
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
                child: Column(
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
                    10.ph,
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
                    10.ph,
                    FloatingActionButton(
                        backgroundColor: LightThemeColors.primary,
                        shape: CircleBorder(),
                        onPressed: () async {
                          openGoogleMaps(
                            latitude: widget.lat.toDouble(),
                            longitude: widget.lan.toDouble(),
                          );
                          // final GoogleMapController controller =
                          //     await mapController.future;
                          // controller.animateCamera(
                          //   CameraUpdate.newCameraPosition(
                          //     CameraPosition(
                          //       bearing: 192.8334901395799,
                          //       zoom: 19.151926040649414,
                          //       target: LatLng(
                          //         position!.latitude,
                          //         position!.longitude,
                          //       ),
                          //     ),
                          //   ),
                          // );
                        },
                        child: FaIcon(
                          FontAwesomeIcons.mapMarkerAlt,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            ]),
    );
  }
}
