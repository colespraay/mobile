import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/ongoing_event_model.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/services/api_response.dart';
import 'package:spraay/ui/events/event_details.dart';
import 'package:spraay/utils/my_sharedpref.dart';

class PastEvent extends StatefulWidget {
  const PastEvent({Key? key}) : super(key: key);

  @override
  State<PastEvent> createState() => _PastEventState();
}

class _PastEventState extends State<PastEvent> {
  @override
  Widget build(BuildContext context) {
    return  _buildOngoing();
  }


  //event screen
  Widget _buildOngoing(){
    return FutureBuilder<ApiResponse<OngoingEventModel>>(
        future: apiResponse.pastEventsList(MySharedPreference.getToken()),
        builder: (context, snapshot) {
          if (ConnectionState.active != null && !snapshot.hasData) {
            return Center(child: ShimmerCustomeGrid());
          }
          else if (ConnectionState.done != null && snapshot.hasError || snapshot.data!.error==true) {
            return Center(child: Text(snapshot.data!.errorMessage!, style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor50),));
          }
          else if(snapshot.data==null)
          {
            return Center(child: Text("No Past Event", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor50),));
          }
          else if(snapshot.data!.data!.data!.isEmpty)
          {
            return Center(child: Text("No Past Event", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor50),));
          }

          return ListView.separated(
            shrinkWrap: true,
            itemCount: snapshot.data!.data!.data!.length,
            padding: EdgeInsets.zero,
            itemBuilder: (_, int position){
              return buildContainer(snapshot.data!.data!.data![position]);
            },
            separatorBuilder: (BuildContext context, int index) { return height16; },);

        }
    );


    // return ListView.separated(
    //   shrinkWrap: true,
    //   itemCount: 3,
    //   padding: EdgeInsets.zero,
    //   itemBuilder: (_, int position){
    //     return buildContainer();
    //   },
    //   separatorBuilder: (BuildContext context, int index) { return height16; },);
  }

  Widget buildContainer(Datum datum){
    return Container(
      decoration: BoxDecoration(color: Color(0xff1A1A21), borderRadius: BorderRadius.all(Radius.circular(18.r))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding:  EdgeInsets.all(8.r),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8.r)),
              child: CachedNetworkImage(
                width: 110.w, height: 140.h,
                fit: BoxFit.cover,
                imageUrl:datum.eventCoverImage??"",
                placeholder: (context, url) => Center(child: SpinKitFadingCircle(size: 30,color: Colors.grey,)),
                errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
              ),
            ),
          ),
          SizedBox(width: 6.w,),


          Expanded(
            child: Padding(
              padding:  EdgeInsets.only(right: 16.w, top: 16.h, bottom: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(datum.eventName??"", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 16.sp,
                      fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor50), maxLines: 1, overflow: TextOverflow.ellipsis, ),
                  height4,
                  Text(datum.user?.firstName??"", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400,
                      color: CustomColors.sGreyScaleColor500),maxLines: 1, overflow: TextOverflow.ellipsis,  ),
                  height4,
                  buildDateAndLocContainer(title: "Done"),
                  height8,
                  GestureDetector(
                      onTap:(){
                        Navigator.push(context, FadeRoute(page: EventDetails(fromPage:datum.eventStatus??"", eventname:datum.eventName??"",
                          event_date: DateFormat('yyyy-MM-dd').format(datum.eventDate!), eventTime: datum.time??"", eventVenue:datum.venue??"",
                          eventCategory: datum.category??"", eventdescription: datum.eventDescription??"",
                          event_CoverImage: datum.eventCoverImage??"", eventId: datum.id??"", tag:datum.user?.userTag??"", lat: datum.eventGeoCoordinates?.latitude.toString()??"", long: datum.eventGeoCoordinates?.longitude.toString()??"",
                        )));
                        // Navigator.push(context, FadeRoute(page: EventDetails(fromPage: '', eventname: '', event_date: '',
                        //   eventTime: '', eventVenue: '', eventCategory: '', eventdescription: '', event_CoverImage: '',
                        //   eventId: '', tag: '', lat: '', long: '',)));
                      },
                      child: buildStatus(title: "View Details", color:CustomColors.sDarkColor3))

                ],
              ),
            ),
          )


        ],

      ),
    );
  }

  Widget buildDateAndLocContainer({ required String title}){
    return Container(
      width: double.infinity,
      height: 34.h,
      decoration: BoxDecoration(
          color: CustomColors.sErrorColor,
          borderRadius: BorderRadius.all(Radius.circular(6.r))
      ),
      child: Center(child: Text(title, style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500, color:CustomColors.sWhiteColor) )),
    );
  }

  Widget buildStatus({required String title, required Color color}){
    return   Container(
      width: double.infinity,
      height: 34.h,
      // padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(12.r))
      ),
      child:Center(child: Text(title, style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500, color: CustomColors.sPrimaryColor100) )),

    );
  }
}
