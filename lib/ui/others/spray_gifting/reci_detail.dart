import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/ui/others/spray_gifting/spray_gift_otp.dart';

import '../../../navigations/fade_route.dart';

class ReciDetail extends StatefulWidget {
  const ReciDetail({Key? key}) : super(key: key);

  @override
  State<ReciDetail> createState() => _ReciDetailState();
}

class _ReciDetailState extends State<ReciDetail> {
  final GlobalKey<FormState> _myKey = GlobalKey<FormState>();
  TextEditingController sprayTagController=TextEditingController();
  FocusNode? _textTagFocus;
  @override
  void initState() {
    setState(() {
      _textTagFocus=FocusNode();
    });
  }

  String tagVal="";
  @override
  void dispose() {
    _textTagFocus?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: buildAppBar(context: context, title:"Recipient Details " ),
        body: Form(
          key: _myKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: buildListWidget(),
        ));

  }

  Widget buildListWidget(){
    return ListView(
      padding: horizontalPadding,
      shrinkWrap: true,
      children: [
        height20,

        Text("Enter Spraay tag of receiver", style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 18.sp, color: CustomColors.sGreyScaleColor50)),
        height40,

        CustomizedTextField(textEditingController:sprayTagController, keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,hintTxt: "tag name",focusNode: _textTagFocus,
          autofocus: true,
          prefixIcon: Padding(
            padding:  EdgeInsets.only(right: 8.w, left: 10.w),
            child: SvgPicture.asset("images/at_svg.svg",),
          ),
          onChanged:(value){
            setState(() {tagVal=value;});
          },
        ),
        height8,
        Text("Adam Smith", style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 12.sp, color: CustomColors.sWhiteColor)),


        height90,
        CustomButton(
            onTap: () {
              if( tagVal.isNotEmpty){
                Navigator.pushReplacement(context, FadeRoute(page: SprayGiftOtp()));
              }
            },
            buttonText: 'Confirm', borderRadius: 30.r,width: 380.w,
            buttonColor: ( tagVal.isNotEmpty ) ? CustomColors.sPrimaryColor500:
            CustomColors.sDisableButtonColor),
        height34,
      ],
    );
  }

}
