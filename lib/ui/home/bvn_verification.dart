import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';

class BvnVerification extends StatefulWidget {
  const BvnVerification({Key? key}) : super(key: key);

  @override
  State<BvnVerification> createState() => _BvnVerificationState();
}

class _BvnVerificationState extends State<BvnVerification> {

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
        appBar: buildAppBar(context: context, title: "BVN Verification"),
        body:  Padding(
          padding: horizontalPadding,
          child: ListView(
            shrinkWrap: true,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height22,
              buildContainer(),
              height26,
              CustomizedTextField(textEditingController:phoneController, keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,hintTxt: "7012345678",focusNode: _textField1Focus,
                maxLength: 11,
                inputFormat: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged:(value){
                  setState(() {firstBtn=value;});
                },
              ),
              height50,



              CustomButton(
                  onTap: () {
                    if(firstBtn.length==11){
                      popupDialog(context: context, title: "Identity Verified", content: "Yaay!!! You can not enjoy all the features of Spray App!",
                          buttonTxt: 'Let’s get started',
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }, png_img: 'verified');
                    }

                  },
                  buttonText: 'Verify', borderRadius: 30.r,width: 380.w,
                  buttonColor: firstBtn.length==11  ? CustomColors.sPrimaryColor500:
                  CustomColors.sDisableButtonColor),


              height40

            ],
          ),
        ));
  }

  Widget buildContainer(){
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
          color: CustomColors.sTransparentPurplecolor,
          borderRadius: BorderRadius.all(Radius.circular(30.r)),
          border: Border.all(color: CustomColors.sGreyScaleColor300)
      ),
      child:   Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset("images/profile_avatar.svg", width: 60.w, height: 60.h,),
          SizedBox(width: 12.w,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Why do we need your BVN?", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w500, color: CustomColors.sPrimaryColor100)),
                height4,
                Text("We need your BVN to verify your identity. This does not give Spray app any access to your bank data or balances. This is just to enable us confirm your identity(real name, phone number & date of birth).", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400)),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
