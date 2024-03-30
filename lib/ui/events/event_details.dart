
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/events/google_map_location.dart';
import 'package:spraay/ui/events/select_payment_method.dart';
import 'package:spraay/utils/my_sharedpref.dart';
import 'package:spraay/view_model/event_provider.dart';

class EventDetails extends StatefulWidget {

  String fromPage,eventname,event_date,eventTime,eventVenue,eventCategory, eventdescription, event_CoverImage,eventId,tag, lat, long, eventCode;

  EventDetails({required this.fromPage, required this.eventname, required this.event_date, required this.eventTime, required this.eventVenue,
    required this.eventCategory, required this.eventdescription, required this.event_CoverImage, required this.eventId, required this.tag,
  required this.lat, required this.long, required this.eventCode});
  // const EventDetails({Key? key}) : super(key: key);

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {


  String totalAmtSprayed="0";
  bool _loadTAmt=false;
  _fetchtotalAmtSprayedEndpoint() async{
    setState(() {_loadTAmt=true;});
    var result = await apiResponse.totalAmtSprayedApi(MySharedPreference.getToken(), widget.eventId);
    if (result['error'] == true) {
      print("fetchtotalAmtSprayedEndpoint error${result['message']}");
    }
    else {
      setState(() {totalAmtSprayed=result["total"].toString();});
    }
    setState(() {_loadTAmt=false;});
  }
  String totalPeopleInvited="0";
  String totalRsvp="0";
  // bool _loadTAmt=false;
  _fetchtotalPeopleInvitedEndpoint() async{
    setState(() {_loadTAmt=true;});
    var result = await apiResponse.totalPeopleInvitedApi(MySharedPreference.getToken(), widget.eventId??"");
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

    if(widget.fromPage=="PAST"){
      _fetchtotalAmtSprayedEndpoint();
    }else{
      _fetchtotalPeopleInvitedEndpoint();
    }


    super.initState();
  }

  EventProvider? eventProvider;
  @override
  void didChangeDependencies() {
    eventProvider=context.watch<EventProvider>();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayWidget(
      loading: eventProvider?.loading??false,
      child: Scaffold(
          appBar: buildAppBar(context: context, title: "Details", action: [

            GestureDetector(
                onTap:()async{
                  final box = context.findRenderObject() as RenderBox?;
                  await Share.share("Hello, I am inviting you to ${widget.eventname} ${widget.eventCategory}. Kindly download the Spraay App www.spraay.ng to confirm your attendance. Your private invitation code is ${widget.eventCode??""}",
                      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size
                  );
                },
                child: Padding(padding:  EdgeInsets.only(right: 18.w), child: SvgPicture.asset("images/arrow_svg.svg"),)),
          //   Padding(
          //   padding:  EdgeInsets.only(right: 18.w),
          //   child: SvgPicture.asset("images/arrow_svg.svg"),
          // )
          ]),
          body:  SingleChildScrollView(
            child: Padding(
              padding: horizontalPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // padding: horizontalPadding,
                children: [
                  height12,
                  Stack(
                    children: [
                      Hero(
                        tag: "image1",
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(14.r)),
                          child: Container(
                            width: double.infinity,
                            height: 455.h,
                            decoration: const BoxDecoration(
                              color: CustomColors.sPrimaryColor500,
                            ),
                            child: CachedNetworkImage(
                              width: double.infinity,
                              height: 455.h,
                              fit: BoxFit.cover,
                              imageUrl:widget.event_CoverImage??"",
                              placeholder: (context, url) => const Center(child: SpinKitFadingCircle(size: 30,color: Colors.grey,)),
                              errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                            ),
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
                            color: const Color(0xB209090B),
                            borderRadius: BorderRadius.all(Radius.circular(8.r))
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.eventname, style: CustomTextStyle.kTxtBold.copyWith(fontSize: 22.sp, fontWeight: FontWeight.w700) ),
                              Text("Invited by ${widget.tag}", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor400) ),
                            ],
                          ),
                        ),
                      ),


                    ],
                  ),
                  height22,

                  GestureDetector(
                    onTap:(){
                        Navigator.push(context, FadeRoute(page: GoogleMapLocationScreen(fromPage: "", eventname:widget.eventname,
                          event_date: widget.event_date, eventTime:widget.eventTime, eventVenue: widget.eventVenue,
                          eventCategory: widget.eventCategory, eventdescription: widget.eventdescription,
                          event_CoverImage: widget.event_CoverImage, eventId:widget.eventId, lat: double.parse(widget.lat), long:double.parse( widget.long),
                        )));
                    },
                      child: buildCard()),
                  height22,

                  widget.fromPage=="PAST"? buildDateAndLocContainer(title: "Completed"): const SizedBox.shrink(),

                  Text("About this event", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700) ),
                  height4,
                  Text(widget.eventdescription,
                      style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor50) ),
                  // height4,
                  // buildHorizontalTicket(),
                  // height22,

                  widget.fromPage=="PAST"? const SizedBox.shrink() :height30,
                  widget.fromPage=="PAST"? const SizedBox.shrink() : Row(
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
                  widget.fromPage=="PAST"?  Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     height22,
                     Text("Spraay Details", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700) ),
                     height4,
                     Container(
                       width: 140.w,
                       height: 138.h,
                       // padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
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
                               child: Text(_loadTAmt?"...": "₦${totalAmtSprayed}", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700, color: CustomColors.sWhiteColor, fontFamily: "SemiPlusJakartaSans") )),

                           Align(
                             alignment: Alignment.bottomCenter,
                             child: Padding(
                               padding: EdgeInsets.only(bottom: 8.h),
                               child: Text("Amount\nSprayed", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: CustomColors.sWhiteColor) ),
                             ),
                           ),

                           Positioned(
                               bottom: 0,
                               right: 0,
                               child: Image.asset("images/msk.png", width: 70.w,))
                         ],
                       ),
                     ),
                   ],
                 ): const SizedBox.shrink(),

                  //aaa
                  widget.fromPage=="PAST"? const SizedBox.shrink() : _builColmn(),

                  widget.fromPage=="PAST"? const SizedBox.shrink() : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CustomButton(
                            onTap: () {
                              eventProvider?.acceptOrRejectEventApi(context, widget.eventId, "ACCEPTED");

                            },
                            buttonText: 'Yes', borderRadius: 8.r,width: 380.w,
                            buttonColor: CustomColors.sDarkColor2),
                      ),

                      SizedBox(width: 24.w,),
                      Expanded(
                        child: CustomButton(
                            onTap: () {
                              eventProvider?.acceptOrRejectEventApi(context, widget.eventId, "REJECTED");

                            },
                            buttonText: 'No', borderRadius: 8.r,width: 380.w,
                            buttonColor: CustomColors.sGreyScaleColor800),
                      ),
                    ],
                  ),
                  height22,
                  widget.fromPage=="PAST"? const SizedBox.shrink() : Text("Event invitation code", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700) ),
                  widget.fromPage=="PAST"? const SizedBox.shrink() :  height4,
                  widget.fromPage=="PAST"? const SizedBox.shrink() : Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(color:CustomColors.sDarkColor2, borderRadius: BorderRadius.all(Radius.circular(8.r))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.eventCode, style: CustomTextStyle.kTxtRegular.copyWith(
                            fontSize: 16.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor50) ),

                        GestureDetector(
                          onTap: (){
                            Clipboard.setData(ClipboardData(text: widget.eventCode)).then((_){
                              toastMsg("Code copied!");
                            });
                          },
                            child: SvgPicture.asset("images/copy.svg"))

                      ],
                    ),
                  ),
                  widget.fromPage=="PAST"? const SizedBox.shrink() :  height26,

                ],
              ),
            ),
          )),
    );
  }

  Widget _builColmn(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height22,
        Text("Will you be attending this event?", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700) ),
        height4,
        Text("(Don’t worry, the even organiser will not know)", style: CustomTextStyle.kTxtRegular.copyWith(
            fontSize: 16.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor50) ),
        height22,
      ],
    );
  }

  Widget buildDateAndLocContainer({ required String title}){
    return Container(
      width: double.infinity,
      height: 42.h,
      margin: EdgeInsets.only(bottom: 24.h),
      decoration: BoxDecoration(
          color: Color(0xff4AAF57),
          borderRadius: BorderRadius.all(Radius.circular(6.r))
      ),
      child: Center(child: Text(title, style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500, color:CustomColors.sWhiteColor) )),
    );
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
                    Text(dayString(widget.event_date.toString()), style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w500) ),
                    Text(monthString(widget.event_date.toString()), style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0x99E0E9F4)) ),
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
                      Text(widget.eventVenue, style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500) ),
                      Text(widget.eventVenue, style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0x99FFFFFF)) ),
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

  int index_pos=-1;
  Widget buildHorizontalTicket(){
    return SizedBox(
      height: 70.h,
      child: ListView.builder(
        shrinkWrap: true,
          itemCount: 5,
          scrollDirection:  Axis.horizontal,
          itemBuilder: (context,int position){
            return GestureDetector(
              onTap:(){
                setState(() {index_pos=position;});
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                margin: EdgeInsets.only(right: 16.w),
                decoration: BoxDecoration(
                  color:index_pos==position? CustomColors.sPrimaryColor500: Color(0x40335EF7),
                  border: Border.all(color:index_pos==position? Colors.transparent: Color(0xffFAFAFA)),
                  borderRadius: BorderRadius.all(Radius.circular(8.r))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Regular", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor300) ),
                    height4,
                    Text("N50,000", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w500, color: CustomColors.sWhiteColor) ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
