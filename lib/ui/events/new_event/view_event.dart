import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/navigations/SlideUpRoute.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/events/edit_event.dart';
import 'package:spraay/ui/events/google_map_location.dart';
import 'package:spraay/ui/events/new_event/contacts/phone_contacts.dart';

class ViewEvent extends StatefulWidget {
  const ViewEvent({Key? key}) : super(key: key);

  @override
  State<ViewEvent> createState() => _ViewEventState();
}

class _ViewEventState extends State<ViewEvent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context: context, title: "Details", action: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, SlideUpRoute(page: EditEvent(fromPage: 'view_event')));
            },
              child: Padding(padding:  EdgeInsets.only(right: 18.w), child: SvgPicture.asset("images/edit.svg"),)),

          Padding(padding:  EdgeInsets.only(right: 18.w), child: SvgPicture.asset("images/arrow_svg.svg"),),

        ]),
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

            height30,
            buildCode(),

            height26,
            CustomButton(
                onTap: () {
                  Navigator.push(context, SlideUpRoute(page: EditEvent(fromPage: 'view_event',)));
                },
                buttonText: "Edit this Event", borderRadius: 30.r,width: 380.w,
                buttonColor:  CustomColors.sPrimaryColor500),
            height16,
            CustomButton(
                onTap: () {
                  Navigator.push(context, SlideLeftRoute(page: PhoneContacts()));
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
            Text("xyzrdsa", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500),),
            GestureDetector(
                onTap:(){
                  toastMessage("copied!");
                },
                child: SvgPicture.asset("images/copy.svg"))
          ],
        ),

      ),

    );

  }

}
