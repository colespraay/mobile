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
import 'package:spraay/utils/my_sharedpref.dart';
import 'package:spraay/view_model/auth_provider.dart';

class PinCreation extends StatefulWidget {
  const PinCreation({Key? key}) : super(key: key);

  @override
  State<PinCreation> createState() => _PinCreationState();
}

class _PinCreationState extends State<PinCreation> {
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
                Text("Create your unique 4-digit PIN", style: CustomTextStyle.kTxtBold.copyWith(fontWeight: FontWeight.bold, fontSize: 24.sp, color: CustomColors.sGreyScaleColor50)),
               height8,
                Text("Please remember this PIN. It will be used to perform transactions", style: CustomTextStyle.kTxtSemiBold.copyWith(fontWeight: FontWeight.w500, fontSize: 18.sp, color: CustomColors.sGreyScaleColor50)),

                height45,
                pincodeTextfield(context),

                height26,
                CustomButton(
                    onTap: () {
                      if(requiredNumber.length==4){
                        Provider.of<AuthProvider>(context,listen: true).createTransactionPinEndpoint(context, requiredNumber, MySharedPreference.getUId());
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
