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
import 'package:spraay/ui/authentication/tell_us_about_yourself.dart';
import 'package:spraay/utils/my_sharedpref.dart';
import 'package:spraay/view_model/auth_provider.dart';

class CreateAccountOtpPage extends StatefulWidget {
  const CreateAccountOtpPage({Key? key}) : super(key: key);

  @override
  State<CreateAccountOtpPage> createState() => _CreateAccountOtpPageState();
}

class _CreateAccountOtpPageState extends State<CreateAccountOtpPage> {
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

  AuthProvider? credentialsProvider;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    credentialsProvider=context.watch<AuthProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return  LoadingOverlayWidget(
      loading: credentialsProvider!.loading,
      child: Scaffold(
          appBar: buildAppBar(context: context),
          body: Form(
            key: _myKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: horizontalPadding,
              shrinkWrap: true,
              children: [
                height16,
                SizedBox(
                  width: 240.w,
                  child: Text("Enter OTP sent to\n${MySharedPreference.getPhoneNumber()}",
                      style: CustomTextStyle.kTxtBold.copyWith(fontWeight: FontWeight.bold, fontSize: 24.sp, color: CustomColors.sGreyScaleColor50)),
                ),
                height45,
                pincodeTextfield(context),
                height20,
                _start !=0? buildCountWidget(title: "Resend OTP in ", content: " ${_start}", content2: "s"):
                InkWell(
                  onTap:(){
                    Provider.of<AuthProvider>(context, listen: false).resendOTPCodeEndpoint(context,MySharedPreference.getUId());

                    setState(() {_start=60;});
                    startTimer();
                  },
                  child: Text("Resend Code",
                    style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 16.sp, color: CustomColors.sGreyScaleColor50 ),textAlign: TextAlign.center,),
                ),


                height26,
                CustomButton(
                    onTap: () {
                      if(requiredNumber.length==4){
                        Provider.of<AuthProvider>(context, listen: false).registerVerifyCodeEndpoint(context, requiredNumber);
                      }
                    },
                    buttonText: 'Continue', borderRadius: 30.r,width: 380.w,
                    buttonColor: requiredNumber.length==4 ? CustomColors.sPrimaryColor500:
                    CustomColors.sDisableButtonColor),
                height34,



              ],
            ),
          )),
    );
  }

  Widget pincodeTextfield(BuildContext context){
    return Center(
      child: SizedBox(
        width: 300.w,
        child: PinCodeTextField(
          appContext: context,
          autoFocus: true,
          length: 4,
          // inputFormatters: [
          //   FilteringTextInputFormatter.digitsOnly
          // ],
          textStyle: CustomTextStyle.kTxtRegular.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w400),
          obscureText: false,
          keyboardType: TextInputType.text,
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
