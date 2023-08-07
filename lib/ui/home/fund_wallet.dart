import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';

class FundWallet extends StatelessWidget {
  const FundWallet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context: context, title: "Fund Wallet"),
        body:  Padding(
          padding: horizontalPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text("The account number provided is unique to your Spraay account. Copy the account details below and transfer your amount you want to fund. Your account will be funded instantly",
                  style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 16.sp, color: CustomColors.sGreyScaleColor50), textAlign: TextAlign.center,),

              height16,
              Text("Account Number",
                style: CustomTextStyle.kTxtBold.copyWith(fontWeight: FontWeight.w700, fontSize: 18.sp, color: CustomColors.sGreyScaleColor50)),
              height4,
              Text("00418273618",
                  style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 16.sp, color: CustomColors.sGreyScaleColor400)),
              height4,
              dividerWidget,
              height16,
              Text("Bank Name",
                  style: CustomTextStyle.kTxtBold.copyWith(fontWeight: FontWeight.w700, fontSize: 18.sp, color: CustomColors.sGreyScaleColor50)),
              height4,
              Text("Wema Bank",
                  style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 16.sp, color: CustomColors.sGreyScaleColor400)),
              height4,
              dividerWidget,

              Spacer(),

              CustomButton(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: "12340494")).then((_){
                      cherryToastInfo(context, "Account number copied", "Sending to this account will fund  your Spraay account automatically");
                    });
                  },
                  buttonText: 'Copy', borderRadius: 30.r,width: 380.w,
                  buttonColor:CustomColors.sPrimaryColor500),


              height40





            ],
          ),
        ));
  }
}
