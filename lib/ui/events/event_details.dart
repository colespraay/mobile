
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:screenshot/screenshot.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/events/google_map_location.dart';
import 'package:spraay/ui/events/select_payment_method.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({Key? key}) : super(key: key);

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context: context, title: "Details", /*action: [Padding(
          padding:  EdgeInsets.only(right: 18.w),
          child: SvgPicture.asset("images/arrow_svg.svg"),
        )]*/),
        body:  ListView(
          padding: horizontalPadding,
          children: [
            height12,
            Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: double.infinity,
                    height: 455.h,
                    decoration: BoxDecoration(
                      color: CustomColors.sPrimaryColor500,
                      borderRadius: BorderRadius.all(Radius.circular(14.r))
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
                        Text("More Love, Less Ego Tour", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 22.sp, fontWeight: FontWeight.w700) ),
                        Text("Invited by @ammie19", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor400) ),
                      ],
                    ),
                  ),
                ),


              ],
            ),
            height22,
            GestureDetector(
              onTap:(){
                  Navigator.push(context, FadeRoute(page: GoogleMapLocationScreen()));
              },
                child: buildCard()),
            height22,
            Text("About this event", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700) ),
            height4,
            Text("Join us as we celebrate the union between Amara Azubuike and Ikechukwu Dirichie on the 1st of June 2023.",
                style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor50) ),
            // height4,
            // buildHorizontalTicket(),
            // height22,
            height22,
            Text("Will you be attending this event?", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700) ),
            height4,
            Text("(Don’t worry, the even organiser will not know)",
                style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor50) ),

            height22,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomButton(
                      onTap: () {
                        // if(index_pos==-1){
                        //   cherryToastInfo(context, "Info!", "Please select ticket");
                        // }else{
                        //   Navigator.push(context, FadeRoute(page: PaymentMethod()));
                        // }

                      },
                      buttonText: 'Yes', borderRadius: 8.r,width: 380.w,
                      buttonColor: CustomColors.sPrimaryColor500),
                ),

                SizedBox(width: 24.w,),
                Expanded(
                  child: CustomButton(
                      onTap: () {

                      },
                      buttonText: 'No', borderRadius: 8.r,width: 380.w,
                      buttonColor: CustomColors.sErrorColor),
                ),
              ],
            ),
            height22


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
                    Text("13", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w500) ),
                    Text("May", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0x99E0E9F4)) ),
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
                      Text("Landmark Beach", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500) ),
                      Text("Victoria Island, Lagos", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0x99FFFFFF)) ),
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
