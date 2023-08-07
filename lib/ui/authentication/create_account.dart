import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:flutter/services.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/navigations/SlideUpRoute.dart';
import 'package:spraay/ui/authentication/create_account_otp_page.dart';
import 'package:spraay/ui/authentication/login_screen.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  TextEditingController phoneController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  final GlobalKey<FormState> _myKey = GlobalKey<FormState>();
  bool _isObscure = true;

  FocusNode? _textField1Focus;
  FocusNode? _textField2Focus;
  @override
  void initState() {
  setState(() {
    _textField1Focus = FocusNode();
    _textField2Focus = FocusNode();
  });
  }

  String firstBtn="";
  String secondBtn="";
  @override
  void dispose() {
    _textField1Focus?.dispose();
    _textField2Focus?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                child: Text("Create your Account",
                  style: CustomTextStyle.kTxtBold.copyWith(fontWeight: FontWeight.bold, fontSize: 48.sp, color: CustomColors.sGreyScaleColor50)),
              ),
              height40,

              CustomizedTextField(textEditingController:phoneController, keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,hintTxt: "7012345678",focusNode: _textField1Focus,
                maxLength: 11,
                prefixIcon: Padding(
                    padding:  EdgeInsets.only(right: 8.w, left: 10.w),
                  child: SvgPicture.asset("images/number.svg", height: 11.h,),
                ) ,
                inputFormat: [
                FilteringTextInputFormatter.digitsOnly
                ],
                onChanged:(value){
               setState(() {firstBtn=value;});
                },
              ),

              height20,

              CustomizedTextField(textEditingController:passwordController, keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,hintTxt: "Password", obsec: _isObscure, focusNode: _textField2Focus,
                onChanged:(value){
                  setState(() {secondBtn=value;});
                },
                surffixWidget: GestureDetector(
                  onTap: (){setState(() {_isObscure = !_isObscure;});},
                  child: Padding(
                    padding:  EdgeInsets.only(right: 8.w),
                    child: Icon(_isObscure ? Icons.visibility_off: Icons.visibility, color: Color(0xff9E9E9E),),
                  ),
                ),
                prefixIcon: Padding(
                  padding:  EdgeInsets.only(right: 8.w, left: 10.w),
                  child: SvgPicture.asset("images/lock.svg"),
                ),
              ),
              height26,

              CustomButton(
                  onTap: () {
                    if( firstBtn.isNotEmpty && secondBtn.isNotEmpty){
                      Navigator.push(context, SlideLeftRoute(page: CreateAccountOtpPage()));
                    }
                  },
                  buttonText: 'Sign up', borderRadius: 30.r,width: 380.w,
                  buttonColor: ( firstBtn.isNotEmpty && secondBtn.isNotEmpty) ? CustomColors.sPrimaryColor500:
              CustomColors.sDisableButtonColor),
              height34,

              GestureDetector(
                onTap:(){
                  Navigator.push(context, SlideUpRoute(page: LoginScreen()));
                },
                  child: buildTwoTextWidget(title: "Already have an account?", content: " Sign in")),
              height34,


            ],
          ),
        ));
  }
}
