import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spraay/components/reusable_widget.dart';

class GoogleMapLocationScreen extends StatefulWidget {
  const GoogleMapLocationScreen({Key? key}) : super(key: key);

  @override
  State<GoogleMapLocationScreen> createState() => _GoogleMapLocationScreenState();
}

class _GoogleMapLocationScreenState extends State<GoogleMapLocationScreen> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 16.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  BitmapDescriptor?  customIcon;
  Set<Marker> _markers=Set<Marker>();
  void _setMarker(LatLng point){

    setState(() {
      _markers.add(Marker(markerId: MarkerId("_kGooglePlex"),
          infoWindow: InfoWindow(title: "F Event"),
          icon: /*customIcon ??*/ BitmapDescriptor.defaultMarker, //use this marker to change icon
          position: point
      ));
    });
  }

  createMarker(BuildContext context){
    if(customIcon==null){
      ImageConfiguration configuration= createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(configuration, "images/marker.png").then((value)
      {
        setState(() {
          customIcon =value;
        });
      });
    }
  }


  @override
  void didChangeDependencies() {
    createMarker(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _setMarker( LatLng(37.43296265331129, -122.08832357078792));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context: context, title: "Event Location"),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            markers: _markers,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),

          Positioned(
            left: 10.w,
              right: 10.w,
              bottom: 10.h,
              child: buildContainer())
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }


  Widget buildContainer(){
    return  Container(
        width: double.infinity,
        margin: EdgeInsets.all(20.r),
        height: 112.h,
        decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(24.r))
        ),
    );
  }
}
