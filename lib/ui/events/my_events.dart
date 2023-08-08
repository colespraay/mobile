import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/events/edit_event.dart';
import 'package:spraay/ui/events/event_details.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({Key? key}) : super(key: key);

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  @override
  Widget build(BuildContext context) {
    return _buildMyEvents();
  }

  Widget _buildMyEvents(){
    return ListView.separated(
      shrinkWrap: true,
      itemCount: 2,
      padding: EdgeInsets.zero,
      itemBuilder: (_, int position){
        return buildContainer();
      },
      separatorBuilder: (BuildContext context, int index) { return height16; },);
  }

  Widget buildContainer(){
    return Container(
      decoration: BoxDecoration(color: Color(0xff1A1A21), borderRadius: BorderRadius.all(Radius.circular(18.r))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("images/profilewiz.png", width: 120.w, height: 140.h, fit: BoxFit.cover,),
          SizedBox(width: 2.w,),
          Expanded(
            child: Padding(
              padding:  EdgeInsets.only(right: 16.w, top: 16.h, bottom: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("More Love, Less Ego Concert", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor50) ),
                  height4,
                  Text("Wizkid", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor500) ),
                  height4,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildDateAndLocContainer(img: 'datee', title: '23rd May 2023'),
                      SizedBox(width: 8.w,),
                      buildDateAndLocContainer(img: 'location', title: 'Lagos'),
                    ],
                  ),
                  height8,
                  GestureDetector(
                      onTap:(){
                        Navigator.push(context, FadeRoute(page: EditEvent()));
                      },
                      child: buildStatus(title: "Edit Details", color:CustomColors.sPrimaryColor500, ))



                ],
              ),
            ),
          )


        ],

      ),
    );
  }

  Widget buildDateAndLocContainer({required String img, required String title}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
          color: CustomColors.sDarkColor3,
          borderRadius: BorderRadius.all(Radius.circular(4.r))
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset("images/$img.svg", width: 20.w, height: 20.h,),
          SizedBox(width: 4.w,),
          Text(title, style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0xffEEECFF)) ),

        ],
      ),
    );
  }

  Widget buildStatus({required String title, required Color color}){
    return   Container(
      width: 200.w,
      height: 38.h,
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(16.r))
      ),
      child:Center(child: Text(title, style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500, color: CustomColors.sPrimaryColor100) )),

    );
  }
}
