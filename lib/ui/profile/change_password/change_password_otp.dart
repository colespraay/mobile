import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/profile/change_password/change_password.dart';

class ChangePasswordOtp extends StatefulWidget {
  const ChangePasswordOtp({super.key});

  @override
  State<ChangePasswordOtp> createState() => _ChangePasswordOtpState();
}

class _ChangePasswordOtpState extends State<ChangePasswordOtp> {
  final GlobalKey<FormState> _myKey = GlobalKey<FormState>();
  StreamController<ErrorAnimationType>? errorController;
  String requiredNumber="";


  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    startTimer();
  }
  @override
  void dispose() {
    errorController!.close();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: buildAppBar(context: context, title: "Change Password"),
        body: Form(
          key: _myKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: horizontalPadding,
            shrinkWrap: true,
            children: [
              height26,
              Text("Code has been send to +234 1234 ******90", style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 18.sp, color: CustomColors.sGreyScaleColor50)),
              height45,
              pincodeTextfield(context),
              height20,
              _start !=0? buildCountWidget(title: "Resend OTP in ", content: " ${_start}", content2: "s"):
              InkWell(
                onTap:(){
                  setState(() {_start=60;});
                  startTimer();
                },
                child: Text("Resend Code",
                  style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 16.sp, color: CustomColors.sGreyScaleColor50 ),textAlign: TextAlign.center,),
              ),


              height70,
              CustomButton(
                  onTap: () {
                    if(requiredNumber.length==4){


                      Navigator.pushReplacement(context, FadeRoute(page: Changepassword()));

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

  Widget buildCountWidget({required String title,required String content, required String content2}){
    return  Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title,
          style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 16.sp, color: CustomColors.sGreyScaleColor50 ),textAlign: TextAlign.center,),
        Text(content,
          style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 16.sp, color: CustomColors.sPrimaryColor500 ),textAlign: TextAlign.center,),
        Text(content2,
          style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 16.sp, color: CustomColors.sGreyScaleColor50 ),textAlign: TextAlign.center,),

      ],
    );
  }

  late Timer _timer;
  int _start = 60;
  bool isLoading = false;
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            isLoading = false;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }
}
