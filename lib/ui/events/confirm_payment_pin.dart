import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/dashboard/dashboard_screen.dart';
import 'package:spraay/ui/events/view_ticket.dart';
import 'package:spraay/ui/home/fund_wallet.dart';
import 'package:spraay/ui/home/home_screen.dart';

class ConfirmPaymentPin extends StatefulWidget {
  const ConfirmPaymentPin({Key? key}) : super(key: key);

  @override
  State<ConfirmPaymentPin> createState() => _ConfirmPaymentPinState();
}

class _ConfirmPaymentPinState extends State<ConfirmPaymentPin> {
  final GlobalKey<FormState> _myKey = GlobalKey<FormState>();
  StreamController<ErrorAnimationType>? errorController;
  String requiredNumber="";


  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
  }
  @override
  void dispose() {
    errorController!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: buildAppBar(context: context, title: "Complete Payment"),
        body: Form(
          key: _myKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: horizontalPadding,
            shrinkWrap: true,
            children: [
              height50,
              Center(child: Text("Enter PIN to confirm this transaction", style: CustomTextStyle.kTxtSemiBold.copyWith(fontWeight: FontWeight.w500, fontSize: 18.sp, color: CustomColors.sGreyScaleColor50))),

              height45,
              pincodeTextfield(context),

              height26,
              CustomButton(
                  onTap: () {
                    if(requiredNumber.length==4){
                      popupDialogResponse();
                      // popupDialogFailedResponse();
                    }
                  },
                  buttonText: 'Continue', borderRadius: 30.r,width: 380.w,
                  buttonColor: requiredNumber.length==4 ? CustomColors.sPrimaryColor500:
                  CustomColors.sDisableButtonColor),
              height34,
            ],
          ),
        ));
  }

  Widget pincodeTextfield(BuildContext context){
    return Center(
      child: SizedBox(
        width: 300.w,
        child: PinCodeTextField(
          appContext: context,
          autoFocus: true,
          length: 4,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly
          ],
          textStyle: CustomTextStyle.kTxtRegular.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w400),
          obscureText: false,
          keyboardType: TextInputType.phone,
          animationType: AnimationType.fade,
          errorAnimationController: errorController,
          pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 57.h,
              fieldWidth: 57.w,
              // activeFillColor: Colors.red,
              inactiveColor:CustomColors.sDarkColor3,
              activeColor:CustomColors.sDarkColor3,
              selectedColor: CustomColors.sPrimaryColor500

          ),
          animationDuration: Duration(milliseconds: 300),
          // enableActiveFill: true,
          onChanged: (value) {
            setState(() {
              requiredNumber = value;
            });
          },
          onCompleted: (v) {
            if(v==requiredNumber){
              //  validateTofaTok(context,v);

            } else{
              print('invalid');
            }}, // Pass it here
        ),
      ),
    );
  }


  popupDialogResponse(){
    return showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black54,
        builder: (BuildContext context){
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState){
                return Dialog(
                  backgroundColor: CustomColors.sDarkColor2,
                  insetPadding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.r),),
                  child: Container(
                    width: 340.w,
                    decoration: BoxDecoration(
                      color: CustomColors.sDarkColor2,
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                    child: Padding(
                      padding:  EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 20.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          height40,
                          Image.asset("images/verified.png",width: 140.w, height: 140.h),
                          // Container(width: 140.w, height: 140.h, color: Colors.yellow,),
                          height30,
                          Text("Transaction successful", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 24.sp, fontWeight: FontWeight.w700, color: CustomColors.sPrimaryColor400),),
                          height16,
                          SizedBox(
                              width: 276.w,
                              child: Text("Super fan status achieved! You have successfully bought a ticket.", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: CustomColors.sWhiteColor),
                                textAlign: TextAlign.center,)),
                          height30,
                          CustomButton(
                              onTap:(){
                                Navigator.pushAndRemoveUntil(context, FadeRoute(page: DasboardScreen()),(Route<dynamic> route) => false);
                              },
                              buttonText: "Great! Take me Home", borderRadius: 30.r,
                              buttonColor:  CustomColors.sPrimaryColor500),
                          height22,
                          CustomButton(
                              onTap:(){
                                Navigator.pushReplacement(context, FadeRoute(page: ViewTicket()));
                              },
                              buttonText: "View Ticket", borderRadius: 30.r,
                              buttonColor:  CustomColors.sDarkColor3),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

  popupDialogFailedResponse(){
    return showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black54,
        builder: (BuildContext context){
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState){
                return Dialog(
                  backgroundColor: CustomColors.sDarkColor2,
                  insetPadding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.r),),
                  child: Container(
                    width: 340.w,
                    decoration: BoxDecoration(
                      color: CustomColors.sDarkColor2,
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                    child: Padding(
                      padding:  EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 20.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          height40,
                          Image.asset("images/Incorrect_sign.png",width: 140.w, height: 140.h),
                          // Container(width: 140.w, height: 140.h, color: Colors.yellow,),
                          height30,
                          Text("Transaction Failed", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 24.sp, fontWeight: FontWeight.w700, color: CustomColors.sPrimaryColor400),),
                          height16,
                          SizedBox(
                              width: 276.w,
                              child: Text("Ops!!!! You do not have sufficient balance to purchase this ticket. Please top up your account!", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: CustomColors.sWhiteColor),
                                textAlign: TextAlign.center,)),
                          height30,
                          CustomButton(
                              onTap:(){
                                Navigator.pushReplacement(context, FadeRoute(page: FundWallet()));

                              },
                              buttonText: "Top up", borderRadius: 30.r,
                              buttonColor:  CustomColors.sPrimaryColor500),
                          height22,
                          CustomButton(
                              onTap:(){
                                Navigator.pushAndRemoveUntil(context, FadeRoute(page: DasboardScreen()),(Route<dynamic> route) => false);
                              },
                              buttonText: "Take me Home", borderRadius: 30.r,
                              buttonColor:  CustomColors.sDarkColor3),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

}
