import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/current_user.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/navigations/scale_transition.dart';
import 'package:spraay/ui/events/event_details.dart';
import 'package:spraay/ui/events/new_event/new_event.dart';
import 'package:spraay/ui/home/bvn_verification.dart';
import 'package:spraay/utils/my_sharedpref.dart';
import 'package:spraay/view_model/event_provider.dart';

import '../../components/reusable_widget.dart';

class EventSlidder extends StatefulWidget {
  const EventSlidder({Key? key}) : super(key: key);

  @override
  State<EventSlidder> createState() => _EventSlidderState();
}

class _EventSlidderState extends State<EventSlidder> {

  EventProvider? eventProvider;
  @override
  void didChangeDependencies() {
    eventProvider=context.watch<EventProvider>();
    super.didChangeDependencies();
  }
  @override
  void initState() {
    super.initState();
    Provider.of<EventProvider>(context, listen: false).fetchCurrentUserApi();
  }
  int currentPos = 0;
  Widget shimmerLoading(){
    return SizedBox(
      width:double.infinity,
      height: 110.h,
      child: Shimmer.fromColors(
        baseColor: CustomColors.sPrimaryColor500,
        highlightColor: Colors.grey,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(24.r)),
              color: CustomColors.sWhiteColor,
            ),

        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(eventProvider?.userHorizontalScrool==null){
      return Center(child: shimmerLoading());
    }
    else if(eventProvider!.userHorizontalScrool!.isEmpty)
    {
      return Center(child: buildDottedBorder(
        child: Container(
            width: double.infinity,
            height: 112.h,
            child: InkWell(
              onTap:(){
                Navigator.push(context, ScaleTransition1(page: NewEvent()));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("No Event", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor50),),
                  height4,
                  Text("Create one", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: CustomColors.sPrimaryColor500),),
                ],
              ),
            )),
      ));
    }
    else{
      return buildEventForYou(eventProvider?.userHorizontalScrool);
    }

  }

  Widget buildEventForYou(List<DatumCurrentUser>? userHorizontalScrool){
    return Column(
      children: [

        carouseSliderWidget(userHorizontalScrool!),
        height8,
        AnimatedSmoothIndicator(
            activeIndex: currentPos,
            count: userHorizontalScrool.length,  //count: pages.length,
            effect: ExpandingDotsEffect( dotColor: CustomColors.sDarkColor3,
              dotHeight: 10.h, dotWidth: 12.w,
              activeDotColor: CustomColors.sGreenColor500,)),
      ],
    );

    // return FutureBuilder(
    //     future: apiResponse.currentUser(MySharedPreference.getToken()),
    // builder: (context, snapshot) {
    //   if (ConnectionState.active != null && !snapshot.hasData) {
    //     return Center(child: shimmerLoading());
    //   }
    //   else if (ConnectionState.done != null && snapshot.hasError || snapshot.data!.error==true) {
    //     return Center(child: Container(
    //         width: double.infinity,
    //         height: 112.h,
    //         decoration: BoxDecoration(
    //             color: Colors.grey,
    //             borderRadius: BorderRadius.all(Radius.circular(24.r))
    //         ),
    //         child: Center(child: Text(snapshot.data!.errorMessage!, style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor50),))));
    //   }
    //   else if(snapshot.data==null)
    //   {
    //     return Center(child: Container(
    //         width: double.infinity,
    //         height: 112.h,
    //         decoration: BoxDecoration(
    //             color: Colors.grey,
    //             borderRadius: BorderRadius.all(Radius.circular(24.r))
    //         ),
    //         child: Center(child: Text("No Event", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor50),))));
    //   }
    //   else if(snapshot.data!.data!.data!.isEmpty)
    //   {
    //     return Center(child: Container(
    //         width: double.infinity,
    //         height: 112.h,
    //         decoration: BoxDecoration(
    //             color: Colors.grey,
    //             borderRadius: BorderRadius.all(Radius.circular(24.r))
    //         ),
    //         child: Center(child: Text("No Event", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor50),))));
    //   }
    //     return Column(
    //       children: [
    //         // GestureDetector(
    //         //   onTap: (){
    //         //     // _verifyYourIdentityBModal();
    //         //     Navigator.push(context, FadeRoute(page: EventDetails()));
    //         //   },
    //         //   child: Container(
    //         //     width: double.infinity,
    //         //     height: 112.h,
    //         //     decoration: BoxDecoration(
    //         //         color: Colors.grey,
    //         //         borderRadius: BorderRadius.all(Radius.circular(24.r))
    //         //     ),
    //         //
    //         //   ),
    //         // ),
    //
    //         carouseSliderWidget(snapshot.data!.data!.data!),
    //         height8,
    //         AnimatedSmoothIndicator(
    //             activeIndex: currentPos,
    //             count: snapshot.data!.data!.data!.length,  //count: pages.length,
    //             effect: ExpandingDotsEffect( dotColor: CustomColors.sDarkColor3,
    //               dotHeight: 10.h, dotWidth: 12.w,
    //               activeDotColor: CustomColors.sGreenColor500,)),
    //       ],
    //     );
    //   }
    // );
  }



  Widget carouseSliderWidget(List<DatumCurrentUser> list){
    return CarouselSlider.builder(
      itemCount: list.length,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => GestureDetector(
        onTap:(){
          // Navigator.push(context, FadeRoute(page: EventDetails()));
          Navigator.push(context, FadeRoute(page: EventDetails(fromPage: "", eventname:list[itemIndex].eventName??"",
            event_date: DateFormat('yyyy-MM-dd').format(list[itemIndex].eventDate!), eventTime: list[itemIndex].time??"", eventVenue: list[itemIndex].venue??"",
            eventCategory: list[itemIndex].category??"", eventdescription: list[itemIndex].eventDescription??"",
            event_CoverImage: list[itemIndex].eventCoverImage??"", eventId: list[itemIndex].id??"", tag: list[itemIndex].user?.userTag??"", lat: list[itemIndex].eventGeoCoordinates?.latitude.toString()??"", long: list[itemIndex].eventGeoCoordinates?.longitude.toString()??"",
            eventCode: list[itemIndex].eventCode??"",
          )));

        },
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(24.r)),
          child: Container(
            decoration: BoxDecoration(color: Color(0xff1A1A21), borderRadius: BorderRadius.all(Radius.circular(18.r))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: "image1",
                  child: Padding(
                    padding:  EdgeInsets.only(right:8.r),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(8.r), bottomLeft: Radius.circular(8.r)),
                      child: CachedNetworkImage(
                        width: 110.w, height: 140.h,
                        fit: BoxFit.cover,
                        imageUrl:list[itemIndex].eventCoverImage??"",
                        placeholder: (context, url) => Center(child: SpinKitFadingCircle(size: 30,color: Colors.grey,)),
                        errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 6.w,),
                Expanded(
                  child: Padding(
                    padding:  EdgeInsets.only(right: 16.w, top: 16.h, bottom: 0.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 150.w,
                          child: Text(list[itemIndex].eventName??"", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 20.sp,
                              fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor50),maxLines: 1, overflow: TextOverflow.ellipsis, ),
                        ),
                        height4,
                        SizedBox(
                          width: 150.w,
                          child: Text(list[itemIndex].eventDescription??"", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor500),
                            maxLines: 1, overflow: TextOverflow.ellipsis,),
                        ),

                        height8,
                        buildStatus(title: "View Details", color:CustomColors.sGreenColor500, )



                      ],
                    ),
                  ),
                ),

                Container(
                  width: 56.w,
                  height: 64.h,
                  margin: EdgeInsets.only(right: 12.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12.r)),
                    color: CustomColors.sPrimaryColor500
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(monthString(list[itemIndex].eventDate.toString()??""), style: CustomTextStyle.kTxtBold.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700) ),
                      Text(dayString(list[itemIndex].eventDate.toString()), style: CustomTextStyle.kTxtBold.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700) ),
                    ],
                  ),
                ),

              ],

            ),
          ),

        ),
      ),
      options: CarouselOptions(
          autoPlay: true,
          onPageChanged: (index, reason) {
            setState(() {
              currentPos = index;
            });
          },
          height: 115.h,
          enlargeCenterPage: true,
          viewportFraction: 1,
          initialPage: 0,
          enableInfiniteScroll: false,
          reverse: false,
          autoPlayInterval: Duration(seconds: 4),
          autoPlayAnimationDuration: Duration(milliseconds: 700),
          autoPlayCurve: Curves.fastOutSlowIn,
          scrollDirection: Axis.horizontal
      ),
    );
  }


  Widget buildStatus({required String title, required Color color}){
    return   Container(
      width: 100.w,
      height: 28.h,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(16.r))
      ),
      child:Center(child: Text(title, style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor900) )),

    );
  }

}
