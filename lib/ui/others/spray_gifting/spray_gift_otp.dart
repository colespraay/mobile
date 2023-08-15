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

class SprayGiftOtp extends StatefulWidget {
 final String? phoneNumber;
  const SprayGiftOtp({Key? key, this.phoneNumber}) : super(key: key);

  @override
  State<SprayGiftOtp> createState() => _SprayGiftOtpState();
}

class _SprayGiftOtpState extends State<SprayGiftOtp> {
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
        appBar: buildAppBar(context: context, title: "Gift"),
        body: Form(
          key: _myKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: horizontalPadding,
            shrinkWrap: true,
            children: [

              height20,
              Text("You are about to gift  ₦20,000 to your friend Adam Smith",
                  style: CustomTextStyle.kTxtBold.copyWith(fontWeight: FontWeight.bold, fontSize: 20.sp, color: CustomColors.sGreyScaleColor50,
                      fontFamily: "PlusJakartaSans")),
              height16,
              Text("Enter PIN to confirm this transaction", style: CustomTextStyle.kTxtSemiBold.copyWith(fontWeight: FontWeight.w500, fontSize: 18.sp, color: CustomColors.sGreyScaleColor50)),

              height45,
              pincodeTextfield(context),

              height26,
              CustomButton(
                  onTap: () {
                    if(requiredNumber.length==4){

                      popupWithTwoBtnDialog(context: context, title: "Transaction successful",
                          content: "You have successfully gifted Adam Smith N20,000.",
                          buttonTxt: "Great! Take me Home", onTap: (){
                            Navigator.pushAndRemoveUntil(context, FadeRoute(page: DasboardScreen()),(Route<dynamic> route) => false);
                            Provider.of<AuthProvider>(context, listen: false).onItemTap(0);

                          }, png_img: "verified", btn2Txt: 'View Receipt', onTapBtn2: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pushReplacement(context, FadeRoute(page: PaymentReceipt(svg_img: "spray_circle", type:"Spray Gift", date: '17 April, 2:30 PM', amount: '₦500.00', meterNumber: '+2346123456', transactionRef: 'SPA-71eas908', transStatus: 'Successful',)));
                          });
                    }
                  },
                  buttonText:  'Continue', borderRadius: 30.r,width: 380.w,
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
}
