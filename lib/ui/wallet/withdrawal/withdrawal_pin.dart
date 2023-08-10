import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/dashboard/dashboard_screen.dart';
import 'package:spraay/ui/others/payment_receipt.dart';
import 'package:spraay/view_model/auth_provider.dart';

class WithdrawalOtp extends StatefulWidget {
  String fromWhere;
   WithdrawalOtp({required this.fromWhere});

  @override
  State<WithdrawalOtp> createState() => _WithdrawalOtpState();
}

class _WithdrawalOtpState extends State<WithdrawalOtp> {
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
        appBar: buildAppBar(context: context, title: "Withdraw"),
        body: Form(
          key: _myKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: horizontalPadding,
            shrinkWrap: true,
            children: [
              height16,
              Text("You are about to withdraw  N200,000 from your wallet to Uche Usman 1234567890 (Access Bank)", style: CustomTextStyle.kTxtBold.copyWith(fontWeight: FontWeight.bold, fontSize: 24.sp, color: CustomColors.sGreyScaleColor50)),
              height8,
              Text("Enter PIN to confirm this transaction", style: CustomTextStyle.kTxtSemiBold.copyWith(fontWeight: FontWeight.w500, fontSize: 18.sp, color: CustomColors.sGreyScaleColor50)),

              height45,
              pincodeTextfield(context),

              height26,
              CustomButton(
                  onTap: () {
                    if(requiredNumber.length==4){

                      //Failed transaction
                      // popupDialog(context: context, title: "Transaction Failed", content: "We could not complete your withdrawal request",
                      //     buttonTxt: 'Try again',
                      //     onTap: () {
                      //   Navigator.pop(context);

                      //     }, png_img: 'Incorrect_sign');

                      popupSuccessfulDialog(context: context, title: "Transaction successful",
                          content: "You have successfully withdrawn N200,000 to 1234567890 Uche Usman. ",
                          buttonTxt: "Great! Take me Home", onTap: (){
                                  Navigator.pushAndRemoveUntil(context, FadeRoute(page: DasboardScreen()),(Route<dynamic> route) => false);
                                  Provider.of<AuthProvider>(context, listen: false).onItemTap(0);

                          }, png_img: "verified");



                    }
                  },
                  buttonText: 'Top up', borderRadius: 30.r,width: 380.w,
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


  popupSuccessfulDialog({ required BuildContext context, required String title, required String content, required String buttonTxt,
    required void Function() onTap, required String png_img}){
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
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
                          Image.asset("images/$png_img.png",width: 140.w, height: 140.h),
                          // Container(width: 140.w, height: 140.h, color: Colors.yellow,),
                          height30,
                          Text(title, style: CustomTextStyle.kTxtBold.copyWith(fontSize: 24.sp, fontWeight: FontWeight.w700, color: CustomColors.sPrimaryColor400),),
                          height16,
                          SizedBox(
                              width: 276.w,
                              child: Text(content, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: CustomColors.sWhiteColor),
                                textAlign: TextAlign.center,)),
                          height30,
                          CustomButton(
                              onTap: onTap,
                              buttonText: buttonTxt, borderRadius: 30.r,
                              buttonColor:  CustomColors.sPrimaryColor500),
                          height22,
                          CustomButton(
                              onTap:(){
                               if( widget.fromWhere=="new_bank_screen"){
                                 //call this if you route in through new_bank_screen
                                 Navigator.pop(context);
                                 Navigator.pop(context);
                                 Navigator.pop(context);
                                 Navigator.pop(context);
                                 Navigator.pop(context);
                                 Navigator.pushReplacement(context, FadeRoute(page: PaymentReceipt(svg_img: 'spray_anim', type: 'Electricity Bill', date: '17 April, 2:30 PM', amount: '1000', meterNumber: '123456789',
                                   transactionRef: 'SPA-71eas908', transStatus: 'Successful',)));

                               }else{
                                 //call this if you route in through to_bank_screen
                                 Navigator.pop(context);
                                 Navigator.pop(context);
                                 Navigator.pop(context);
                                 Navigator.pushReplacement(context, FadeRoute(page: PaymentReceipt(svg_img: 'spray_anim', type: 'Electricity Bill', date: '17 April, 2:30 PM', amount: '1000', meterNumber: '123456789',
                                   transactionRef: 'SPA-71eas908', transStatus: 'Successful',)));

                               }
                              },
                              buttonText: "View Receipt", borderRadius: 30.r,
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
