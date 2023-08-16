import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/profile/reset_trans_pin/confirm_change_pin.dart';

class ChangeTransactionPin extends StatefulWidget {
  const ChangeTransactionPin({super.key});

  @override
  State<ChangeTransactionPin> createState() => _ChangeTransactionPinState();
}

class _ChangeTransactionPinState extends State<ChangeTransactionPin> {
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
        appBar: buildAppBar(context: context, title: "Change Transaction PIN"),
        body: Form(
          key: _myKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: horizontalPadding,
            shrinkWrap: true,
            children: [
              height45,
              Center(child: Text("Enter new transaction PIN", style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 18.sp, color: CustomColors.sGreyScaleColor50))),
              height45,
              pincodeTextfield(context),
              height20,

              height70,
              CustomButton(
                  onTap: () {
                    if(requiredNumber.length==4){

                      Navigator.push(context, FadeRoute(page: ConfirmChangePin()));

                    }
                  },
                  buttonText: 'Verify', borderRadius: 30.r,width: 380.w,
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
