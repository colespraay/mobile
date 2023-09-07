import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';

class GoogleMapLocationScreen extends StatefulWidget {
  double lat, long;
  String fromPage,eventname,event_date,eventTime,eventVenue,eventCategory, eventdescription, event_CoverImage,eventId;
  GoogleMapLocationScreen({required this.fromPage, required this.eventname, required this.event_date, required this.eventTime, required this.eventVenue,
    required this.eventCategory, required this.eventdescription, required this.event_CoverImage, required this.eventId,
    required this.lat, required this.long});
  // const GoogleMapLocationScreen({Key? key}) : super(key: key);

  @override
  State<GoogleMapLocationScreen> createState() => _GoogleMapLocationScreenState();
}

class _GoogleMapLocationScreenState extends State<GoogleMapLocationScreen> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();




  Set<Marker> _markers=Set<Marker>();
  void _setMarker(LatLng point)async{

    BitmapDescriptor markerIcon= await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), "images/mark_pinn.png");

    _markers.add(Marker(
      markerId: MarkerId("_kGooglePlex"),
      infoWindow: InfoWindow(title: widget.eventname),
      icon: markerIcon  /*BitmapDescriptor.defaultMarker*/, //use this marker to change icon
      position: point,

    ));

    setState(() {});
  }




  @override
  void initState() {
    _setMarker( LatLng(widget.lat, widget.long));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context: context, title: "Event Location"),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            markers: _markers.toSet(),
            initialCameraPosition: CameraPosition(target: LatLng(widget.lat, widget.long), zoom: 14.4746,),
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
    );
  }




  Widget buildContainer(){
    return  GestureDetector(
      onTap:(){
        _goToCurrentLocation();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(24.r)),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 1.w),
          decoration: BoxDecoration(color: Color(0xff1A1A21), borderRadius: BorderRadius.all(Radius.circular(18.r))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:  EdgeInsets.only(right:8.r, left: 10.w, top: 10.h, bottom: 10.h),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8.r), bottomLeft: Radius.circular(8.r)),
                  child: CachedNetworkImage(
                    width: 110.w, height: 110.h,
                    fit: BoxFit.cover,
                    imageUrl:widget.event_CoverImage??"",
                    placeholder: (context, url) => Center(child: SpinKitFadingCircle(size: 30,color: Colors.grey,)),
                    errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                  ),
                ),
              ),
              SizedBox(width: 6.w,),
              Expanded(
                child: Padding(
                  padding:  EdgeInsets.only(right: 16.w, top: 1.h, bottom: 0.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${dayString(widget.event_date.toString())} ${monthString(widget.event_date.toString()??"")}, ${widget.eventTime}", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500) ),

                      height10,
                      Text(widget.eventname??"", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 16.sp,
                          fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor50),maxLines: 1, overflow: TextOverflow.ellipsis, ),
                      height10,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset("images/location.svg"),
                          SizedBox(width: 10.w,),
                          SizedBox(
                            width: 150.w,
                            child: Text(widget.eventVenue??"", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0xffEEEEEE)),
                              maxLines: 1, overflow: TextOverflow.ellipsis,),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),


            ],

          ),
        ),

      ),
    );
  }

  Future<void> _goToCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition( CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(widget.lat, widget.long),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414)));
  }
}
