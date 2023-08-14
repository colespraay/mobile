import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/ui/others/spray/conf_topUp_pin.dart';

class TopUpSpray extends StatefulWidget {
  const TopUpSpray({Key? key}) : super(key: key);

  @override
  State<TopUpSpray> createState() => _TopUpSprayState();
}

class _TopUpSprayState extends State<TopUpSpray> {
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
        appBar: buildAppBar(context: context, title: "Spray Top Up"),
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
                keyboardType: TextInputType.number,
                autofocus: true,
                style: CustomTextStyle.kTxtBold.copyWith(color: CustomColors.sGreyScaleColor100, fontSize: 40.sp, fontWeight: FontWeight.bold),
                onChanged:(value){
                  setState(() {firstBtn=value;});
                },

                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  NumberTextInputFormatter()
                ],
                decoration: new InputDecoration(

                  prefixText: "₦",
                  prefixStyle:  CustomTextStyle.kTxtBold.copyWith(color: CustomColors.sGreyScaleColor100, fontSize: 40.sp, fontWeight: FontWeight.bold, fontFamily: "PlusJakartaSans"),

                  contentPadding: EdgeInsets.symmetric(vertical: 0.1.h, horizontal: 0),

                  // prefixIconConstraints: BoxConstraints(minWidth: 30.w, minHeight: 10.h,),


                  // prefixIcon: Padding(
                  //   padding:  EdgeInsets.only(right: 5.w, left: 2.w, top: 4.h),
                  //   child: Text("N", style: CustomTextStyle.kTxtBold.copyWith(
                  //       color: CustomColors.sGreyScaleColor100, fontSize: 38.sp, fontWeight: FontWeight.bold),),
                  // ) ,
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
                      Navigator.push(context, SlideLeftRoute(page: ConfirmTopUpPin()));

                      // popupDialog(context: context, title: "Identity Verified", content: "Yaay!!! You can not enjoy all the features of Spray App!",
                      //     buttonTxt: 'Let’s get started',
                      //     onTap: () {
                      //       Navigator.pop(context);
                      //       Navigator.pop(context);
                      //     }, png_img: 'verified');

                    }

                  },
                  buttonText: 'Top up', borderRadius: 30.r,width: 380.w,
                  buttonColor: firstBtn.isNotEmpty ? CustomColors.sPrimaryColor500:
                  CustomColors.sDisableButtonColor),


              height40

            ],
          ),
        ));
  }
}
