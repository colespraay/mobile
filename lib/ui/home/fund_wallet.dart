import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/utils/my_sharedpref.dart';

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

              height26,
              Text("Account Number",
                style: CustomTextStyle.kTxtBold.copyWith(fontWeight: FontWeight.w700, fontSize: 18.sp, color: CustomColors.sGreyScaleColor50)),
              height4,
              Text(MySharedPreference.getVAccNumber(),
                  style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 16.sp, color: CustomColors.sGreyScaleColor400)),
              height4,
              dividerWidget,
              height16,
              Text("Bank Name",
                  style: CustomTextStyle.kTxtBold.copyWith(fontWeight: FontWeight.w700, fontSize: 18.sp, color: CustomColors.sGreyScaleColor50)),
              height4,
              Text(MySharedPreference.getVAccName(),
                  style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 16.sp, color: CustomColors.sGreyScaleColor400)),
              height4,
              dividerWidget,

              Spacer(),

              Center(
                child: CustomButton(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text:MySharedPreference.getVAccNumber())).then((_){
                        cherryToastInfooo(context, "Account number copied", "Sending to this account will fund  your Spraay account automatically");
                      });
                    },
                    buttonText: 'Copy', borderRadius: 30.r,width: 380.w,
                    buttonColor:CustomColors.sPrimaryColor500),
              ),


              height40





            ],
          ),
        ));
  }

  void cherryToastInfooo(BuildContext context,String titlemsg, String dsc){
    return CherryToast.info(
      title: Text(titlemsg, style: CustomTextStyle.kTxtBold.copyWith(fontSize: 14.sp, color: CustomColors.sWhiteColor, fontWeight: FontWeight.w700),),
      description:Text(dsc, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, color: CustomColors.sWhiteColor, fontWeight: FontWeight.w400),),
      borderRadius: 8.r,
      shadowColor: Colors.transparent,
      backgroundColor: CustomColors.sDarkColor3,
      animationDuration: Duration(milliseconds: 1000),
      autoDismiss: true,
      displayTitle: true,
      toastPosition: Position.top,
      animationType: AnimationType.fromTop,
      enableIconAnimation: false,
      displayIcon: false,
    ).show(context);
  }
}
