import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/join_event_model.dart';
import 'package:spraay/navigations/SlideUpRoute.dart';
import 'package:spraay/services/api_services.dart';
import 'package:spraay/ui/others/spray/spray_screen.dart';
import 'package:spraay/utils/my_sharedpref.dart';

class JoinEventOtp extends StatefulWidget {
  String cash;
  int totalAmount;
  int noteQuantity;
  int unitAmount;
  Data? eventModelData;
  JoinEventOtp({required this.cash, required this.totalAmount, required this.noteQuantity, required this.unitAmount, required this.eventModelData});


  @override
  State<JoinEventOtp> createState() => _JoinEventOtpState();
}

class _JoinEventOtpState extends State<JoinEventOtp> {
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

  bool _isLoading=false;
  fetchTransactionPinApi(BuildContext context ,String transactionPin) async{
    setState(() {_isLoading=true;});
    var result=await ApiServices().transactionPinApi(MySharedPreference.getToken(), transactionPin);
    if(result['error'] == true){

      popupDialog(context: context, title: "Transaction Failed", content:result['message'],
          buttonTxt: 'Try again',
          onTap: () {
            Navigator.pop(context);

          }, png_img: 'Incorrect_sign');


    }else{

      // //remove this
      // Navigator.pushReplacement(context, SlideUpRoute(page: SprayScreen(cash: widget.cash, totalAmount: 1000, noteQuantity: 5,
      //   unitAmount: 200, eventModelData: widget.eventModelData, transactionPin: transactionPin,)));

      Navigator.pushReplacement(context, SlideUpRoute(page: SprayScreen(
        cash: widget.cash, totalAmount: widget.totalAmount, noteQuantity: widget.noteQuantity.toInt(),
        unitAmount: widget.unitAmount, eventModelData: widget.eventModelData, transactionPin: transactionPin
      )));

    }

    setState(() {_isLoading=false;});

  }

  @override
  Widget build(BuildContext context) {
    return  LoadingOverlayWidget(
      loading: _isLoading,
      child: Scaffold(
          appBar: buildAppBar(context: context, title: "Transaction pin"),
          body: Form(
            key: _myKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: horizontalPadding,
              shrinkWrap: true,
              children: [
                height16,
                Text("You are about to Spray ₦${widget.totalAmount}", style: CustomTextStyle.kTxtBold.copyWith(fontWeight: FontWeight.bold, fontSize: 22.sp, color: CustomColors.sGreyScaleColor50,
                fontFamily: "PlusJakartaSans")),
                height8,
                Text("Enter PIN to continue", style: CustomTextStyle.kTxtSemiBold.copyWith(fontWeight: FontWeight.w500, fontSize: 18.sp, color: CustomColors.sGreyScaleColor50)),

                height45,
                pincodeTextfield(context),

                height26,
                CustomButton(
                    onTap: () {
                      if(requiredNumber.length==4){

                        fetchTransactionPinApi(context, requiredNumber);

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
