import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/navigations/SlideUpRoute.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/events/edit_event.dart';
import 'package:spraay/ui/events/google_map_location.dart';
import 'package:spraay/ui/events/new_event/contacts/phone_contacts.dart';
import 'package:spraay/utils/my_sharedpref.dart';
import 'package:spraay/view_model/event_provider.dart';

class ViewEvent extends StatefulWidget {
  const ViewEvent({Key? key}) : super(key: key);

  @override
  State<ViewEvent> createState() => _ViewEventState();
}

class _ViewEventState extends State<ViewEvent> {
  String totalPeopleInvited="0";
  String totalRsvp="0";
  bool _loadTAmt=false;
  _fetchtotalPeopleInvitedEndpoint() async{
    setState(() {_loadTAmt=true;});
    var result = await apiResponse.totalPeopleInvitedApi(MySharedPreference.getToken(), eventProvider?.eventId??"");
    if (result['error'] == true) {
      print("_fetchtotalPeopleInvitedEndpoint error${result['message']}");
    }
    else {
      setState(() {
        totalPeopleInvited=result["totalPeopleInvited"].toString();
        totalRsvp=result["totalRsvp"].toString();
      });
    }
    setState(() {_loadTAmt=false;});
  }

  @override
  void initState() {

    super.initState();
  }
  EventProvider? eventProvider;
  //totalPeopleInvitedApi
  @override
  void didChangeDependencies() {
    eventProvider=context.watch<EventProvider>();
    if(eventProvider?.eventId !=null || eventProvider?.eventId !=""){
      _fetchtotalPeopleInvitedEndpoint();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context: context, title: "Details", action: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, SlideUpRoute(page:  EditEvent(fromPage: 'view_event', eventname:eventProvider?.eventname??"", event_date:eventProvider?.event_date??"",
                  eventTime: eventProvider?.eventTime??"",
                  eventVenue: eventProvider?.eventVenue??"", eventCategory: eventProvider?.eventCategory??"",
                  eventdescription: eventProvider?.eventdescription??"",event_CoverImage: eventProvider?.event_CoverImage??"", eventId: eventProvider?.eventId??"",
                  eventCode: eventProvider?.eventCode??"")));
            },
              child: Padding(padding:  EdgeInsets.only(right: 18.w), child: SvgPicture.asset("images/edit.svg"),)),

          GestureDetector(
            onTap:()async{
              final box = context.findRenderObject() as RenderBox?;
              await Share.share("Hello, I am inviting you to ${eventProvider?.eventname??""} ${eventProvider?.eventCategory??""}. Kindly download the Spraay App www.spraay.ng to confirm your attendance. Your private invitation code is ${eventProvider?.eventCode??""}",
                sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
            },
              child: Padding(padding:  EdgeInsets.only(right: 18.w), child: SvgPicture.asset("images/arrow_svg.svg"),)),
        ]),
        body:  ListView(
          padding: horizontalPadding,
          children: [
            height12,
            Stack(
              children: [

                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(14.r)),
                  child: Container(
                    width: double.infinity,
                    height: 455.h,
                    decoration: const BoxDecoration(color: CustomColors.sPrimaryColor500,),
                    child: CachedNetworkImage(
                      width: double.infinity,
                      height: 455.h,
                      fit: BoxFit.cover,
                      imageUrl:eventProvider?.event_CoverImage??"",
                      placeholder: (context, url) => Center(child: SpinKitFadingCircle(size: 30,color: Colors.grey,)),
                      errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 24.h,
                  left: 18.w,
                  right: 18.w,
                  child: Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                        color: Color(0xB209090B),
                        borderRadius: BorderRadius.all(Radius.circular(8.r))
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(eventProvider?.eventname??"", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 22.sp, fontWeight: FontWeight.w700) ),
                        Text("Invited by", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor400) ),
                      ],
                    ),
                  ),
                ),


              ],
            ),
            height22,
            GestureDetector(
                onTap:(){
                  Navigator.push(context, FadeRoute(page: GoogleMapLocationScreen(fromPage: 'view_event', eventname:eventProvider?.eventname??"", event_date:eventProvider?.event_date??"",
                      eventTime: eventProvider?.eventTime??"",
                      eventVenue: eventProvider?.eventVenue??"", eventCategory: eventProvider?.eventCategory??"",
                      eventdescription: eventProvider?.eventdescription??"",event_CoverImage: eventProvider?.event_CoverImage??"",
                      eventId: eventProvider?.eventId??"", lat: eventProvider?.latitude??0, long: eventProvider?.longitude??0,)));
                },
                child: buildCard()),
            height22,
            Text("About this event", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700) ),
            height4,
            Text(eventProvider?.eventdescription??"",
                style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor50) ),

            height30,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                      color: const Color(0xff7664FF),
                      borderRadius: BorderRadius.all(Radius.circular(10.r))
                  ),
                  child: Stack(
                    children: [

                      Positioned(
                          top: 16.h,
                          left: 4.w,
                          right: 4.w,
                          child: Text(_loadTAmt?"...":  "$totalPeopleInvited", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 16.sp,
                              fontWeight: FontWeight.w700, color: CustomColors.sWhiteColor, fontFamily: "SemiPlusJakartaSans") )),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Text("Invited\nGuest", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: CustomColors.sWhiteColor) ),
                        ),
                      ),

                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Image.asset("images/msk.png", width: 30.w,))

                    ],
                  ),
                ),
                SizedBox(width: 28.w,),
                Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                      color: const Color(0xff7664FF),
                      borderRadius: BorderRadius.all(Radius.circular(10.r))
                  ),
                  child: Stack(
                    children: [

                      Positioned(
                          top: 16.h,
                          left: 4.w,
                          right: 4.w,
                          child: Text(_loadTAmt?"...":  "$totalRsvp", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700, color: CustomColors.sWhiteColor, fontFamily: "SemiPlusJakartaSans") )),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Text("Expected\nGuest", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: CustomColors.sWhiteColor) ),
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Image.asset("images/msk.png", width: 30.w,))
                    ],
                  ),
                ),
              ],
            ),
            height30,
            buildCode(),

            height26,
            CustomButton(
                onTap: () {
                  Navigator.push(context, SlideUpRoute(page: EditEvent(fromPage: 'view_event', eventname:eventProvider?.eventname??"", event_date:eventProvider?.event_date??"",
                    eventTime: eventProvider?.eventTime??"",
                    eventVenue: eventProvider?.eventVenue??"", eventCategory: eventProvider?.eventCategory??"",
                    eventdescription: eventProvider?.eventdescription??"",event_CoverImage: eventProvider?.event_CoverImage??"",
                  eventId: eventProvider?.eventId??"", eventCode: eventProvider?.eventCode??"")));
                },
                buttonText: "Edit this Event", borderRadius: 30.r,width: 380.w,
                buttonColor:  CustomColors.sPrimaryColor500),
            height16,
            CustomButton(
                onTap: () {
                  Navigator.pushReplacement(context, SlideLeftRoute(page: PhoneContacts()));
                },
                buttonText: 'Share this event', borderRadius: 30.r,width: 380.w,
                buttonColor: CustomColors.sDarkColor3),
            height26


          ],
        ));
  }

  Widget buildCard(){
    return Card(
      color: CustomColors.sPrimaryColor500,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 16.w,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(dayString(eventProvider?.event_date??""), style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w500) ),
                    Text(monthString(eventProvider?.event_date??""), style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0x99E0E9F4)) ),
                  ],
                ),
                SizedBox(width: 16.w,),
                VerticalDivider(color: Color(0x80FFFFFF),width: 0,thickness: 1.5.w, ),
                SizedBox(width: 16.w,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(eventProvider?.eventVenue??"", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis, ),
                      Text(eventProvider?.eventVenue??"", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0x99FFFFFF)), maxLines: 2, overflow: TextOverflow.ellipsis ),
                    ],
                  ),
                ),

                SvgPicture.asset("images/locatn.svg")


              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCode(){
    return Container(
      width: 380.w,
      height: 58.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
          color: CustomColors.sDarkColor2,
          borderRadius: BorderRadius.circular(12.r)),
      child: Material(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(eventProvider?.eventCode??"", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500),),
            InkWell(
                onTap:(){
                  Clipboard.setData( ClipboardData(text: eventProvider?.eventCode??"")).then((_) {
                    toastMessage("copied!");
                  });

                },
                child: SvgPicture.asset("images/copy.svg"))
          ],
        ),

      ),

    );

  }

}
