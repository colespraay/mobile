import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/events/confirm_payment.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context: context, title: "Select Method"),
        body:  ListView(
          padding: horizontalPadding,
          children: [
            height40,
            GestureDetector(
              onTap:(){
                Navigator.push(context, SlideLeftRoute(page: ConfirmPayment()));

              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xff616161)),
                  borderRadius: BorderRadius.all(Radius.circular(12.r))
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset("images/wallet_sml.svg"),
                    SizedBox(width: 16.w,),
                    Expanded(child: Text("Wallet (N200,000)", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500) )),
                    Icon(Icons.arrow_forward_ios_outlined, color: CustomColors.sWhiteColor, size: 20.r,)
                  ],
                ),
              ),
            ),

            height22


          ],
        ));
  }
}
