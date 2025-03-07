import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/ui/events/confirm_payment_pin.dart';

class ConfirmPayment extends StatelessWidget {
  const ConfirmPayment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context: context, title: "Confirm Payment"),
        body:  ListView(
          padding: horizontalPadding,
          children: [
            height40,
            buildContainer(),
            height40,

            CustomButton(
                onTap: () {
                  Navigator.push(context, SlideLeftRoute(page: ConfirmPaymentPin()));
                },
                buttonText: 'Pay N50,000 ', borderRadius: 30.r,width: 380.w,
                buttonColor: CustomColors.sPrimaryColor500),
            height22


          ],
        ));
  }

  Widget buildContainer(){
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff1A1A21),
        borderRadius: BorderRadius.all(Radius.circular(22.r))
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("images/profilewiz.png", width: 96.w, height: 140.h,),
          SizedBox(width: 16.w,),
          Expanded(
            child: Padding(
              padding:  EdgeInsets.only(right: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("More Love, Less Ego Concert", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor50) ),
                  height4,
                  Text("Wizkid", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor500) ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildDateAndLocContainer(img: 'datee', title: '23rd May 2023'),
                      SizedBox(width: 8.w,),
                      buildDateAndLocContainer(img: 'location', title: 'Lagos'),
                  ],
                  ),
                  height8,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: buildStatus(title: "Type: Regular", color: Color(0x404CAF50))),
                      SizedBox(width: 8.w,),
                      Expanded(child: buildStatus(title: "N50,000", color: Color(0x40FF0000)))

                    ],
                  )



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
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(4.r))
      ),
      child:Center(child: Text(title, style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500, color: CustomColors.sPrimaryColor100) )),

    );
  }

}
