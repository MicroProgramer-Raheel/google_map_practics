import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_map_practics/location_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<bool>(
          future: checkPermissionStatus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState==ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            else if(snapshot.data==false){
              return Column(
                children: [
                  Text("No Permission Granted, please try again"),
                  TextButton(onPressed: (){
                    setState(() {

                    });
                  }, child: Text("Retry"))
                ],
              );
            }
            else{
              return FutureBuilder<String?>(
                future: getAddressFromCurrentLocation(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState==ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  String address=snapshot.data!;
                  return Column(
                    children: [
                      Expanded(
                        child: GoogleMap(
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          mapType: MapType.hybrid,
                          initialCameraPosition: _kGooglePlex,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                        ),
                      ),
                      Text(address)
                    ],
                  );
                }
              );
            }

          }
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: _goToTheLake,
        //   label: const Text('To the lake!'),
        //   icon: const Icon(Icons.directions_boat),
        // ),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}