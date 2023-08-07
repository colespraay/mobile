import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';

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
            // GestureDetector(
            //   onTap:(){
            //     // Navigator.push(context, FadeRoute(page: ConfirmPayment()));
            //
            //   },
            //   child: Container(
            //     width: double.infinity,
            //     padding: EdgeInsets.all(16.r),
            //     decoration: BoxDecoration(
            //         border: Border.all(color: Color(0xff616161)),
            //         borderRadius: BorderRadius.all(Radius.circular(12.r))
            //     ),
            //     child: Row(
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         SvgPicture.asset("images/wallet_sml.svg"),
            //         SizedBox(width: 16.w,),
            //         Expanded(child: Text("Wallet (₦200,000)", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500) )),
            //         Icon(Icons.arrow_forward_ios_outlined, color: CustomColors.sWhiteColor, size: 20.r,)
            //       ],
            //     ),
            //   ),
            // ),

            CustomButton(
                onTap: () {

                },
                buttonText: 'Pay N50,000 ', borderRadius: 30.r,width: 380.w,
                buttonColor: CustomColors.sPrimaryColor500),
            height22


          ],
        ));
  }

  Widget buildContainer(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

      ],

    );
  }
}
