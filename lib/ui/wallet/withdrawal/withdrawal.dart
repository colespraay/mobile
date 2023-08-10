import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/wallet/withdrawal/to_bank_account.dart';

class Withdrawal extends StatefulWidget {
  const Withdrawal({Key? key}) : super(key: key);

  @override
  State<Withdrawal> createState() => _WithdrawalState();
}

class _WithdrawalState extends State<Withdrawal> {
  TextEditingController phoneController=TextEditingController();
  FocusNode? _textField1Focus;
  @override
  void initState() {
    setState(() {
      _textField1Focus = FocusNode();
    });
  }

  String firstBtn="";
  @override
  void dispose() {
    _textField1Focus?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context: context, title: "Withdraw"),
        body:  Padding(
          padding: horizontalPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height22,
              Center(child: Text("Enter Amount", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400))),
              height26,
              TextFormField(
                controller: phoneController,
                style: CustomTextStyle.kTxtBold.copyWith(color: CustomColors.sGreyScaleColor100, fontSize: 40.sp, fontWeight: FontWeight.bold),
                onChanged:(value){
                  setState(() {firstBtn=value;});
                },

                inputFormatters: [
                  // FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  NumberTextInputFormatter()
                ],
                decoration: new InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 0),

                  prefixIconConstraints: BoxConstraints(minWidth: 30.w, minHeight: 19.h,),


                  prefixIcon: Padding(
                    padding:  EdgeInsets.only(right: 0.w, left: 2.w),
                    child: Text("N", style: CustomTextStyle.kTxtBold.copyWith(color: CustomColors.sGreyScaleColor100, fontSize: 40.sp, fontWeight: FontWeight.bold),),
                  ) ,
                ),

              ),
              height26,

              // CustomizedTextField(textEditingController:phoneController, keyboardType: TextInputType.phone,
              //   textInputAction: TextInputAction.done,hintTxt: "7012345678",focusNode: _textField1Focus,
              //   maxLength: 11,
              //   inputFormat: [
              //     // FilteringTextInputFormatter.digitsOnly,
              //     FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              //     NumberTextInputFormatter()
              //   ],
              //   onChanged:(value){
              //     setState(() {firstBtn=value;});
              //   },
              // ),
              height50,



              CustomButton(
                  onTap: () {
                    if(firstBtn.isNotEmpty){
                      Navigator.push(context, FadeRoute(page: ToBankAccount()));

                      // popupDialog(context: context, title: "Identity Verified", content: "Yaay!!! You can not enjoy all the features of Spray App!",
                      //     buttonTxt: 'Let’s get started',
                      //     onTap: () {
                      //       Navigator.pop(context);
                      //       Navigator.pop(context);
                      //     }, png_img: 'verified');

                    }

                  },
                  buttonText: 'Continue', borderRadius: 30.r,width: 380.w,
                  buttonColor: firstBtn.isNotEmpty ? CustomColors.sPrimaryColor500:
                  CustomColors.sDisableButtonColor),


              height40

            ],
          ),
        ));
  }

}
