import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';

class ConfirmTopUpPin extends StatefulWidget {
  const ConfirmTopUpPin({Key? key}) : super(key: key);

  @override
  State<ConfirmTopUpPin> createState() => _ConfirmTopUpPinState();
}

class _ConfirmTopUpPinState extends State<ConfirmTopUpPin> {
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
        appBar: buildAppBar(context: context, title: "Confirm Top Up"),
        body: Form(
          key: _myKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: horizontalPadding,
            shrinkWrap: true,
            children: [
              height16,
              Text("You are about to top-up your Spray with ₦100,000", style: CustomTextStyle.kTxtBold.copyWith(fontWeight: FontWeight.bold, fontSize: 24.sp, color: CustomColors.sGreyScaleColor50)),
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

                      popupDialog(context: context, title: "Top-up Successful",
                          content: "You have successfully added ₦100,000 to your wallet.",
                          buttonTxt: "Great! Let’s turn up!", onTap: (){
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                            // Navigator.pushAndRemoveUntil(context, FadeRoute(page: DasboardScreen()),(Route<dynamic> route) => false);
                            // Provider.of<AuthProvider>(context, listen: false).onItemTap(0);

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


}
