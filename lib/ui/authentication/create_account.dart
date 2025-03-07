import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:provider/provider.dart';
import 'package:rich_text_widget/rich_text_widget.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:flutter/services.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/navigations/SlideUpRoute.dart';
import 'package:spraay/ui/authentication/create_account_otp_page.dart';
import 'package:spraay/ui/authentication/login_screen.dart';
import 'package:spraay/view_model/auth_provider.dart';

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

  String _udid="";
  Future<void> initPlatformState() async {
    String udid;
    try {
      udid = await FlutterUdid.udid;
    } on PlatformException {udid = 'Failed to get UDID.';}

    if (!mounted) return;

    setState(() {_udid = udid;});
    print("_udiddddddWelcome111==${_udid}");


  }



  @override
  void initState() {
    initPlatformState();
  setState(() {
    _textField1Focus = FocusNode();
    _textField2Focus = FocusNode();
  });
  }


  AuthProvider? credentialsProvider;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    credentialsProvider=context.watch<AuthProvider>();
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
                  child: Text("Create your Account",
                    style: CustomTextStyle.kTxtBold.copyWith(fontWeight: FontWeight.bold, fontSize: 48.sp, color: CustomColors.sGreyScaleColor50)),
                ),
                height40,

                CustomizedTextField(textEditingController:phoneController, keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,hintTxt: "7012345678",focusNode: _textField1Focus,
                  maxLength: 10,
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

                        credentialsProvider?.fetchRegistertEndpoint(context, passwordController.text, "0${phoneController.text}", _udid);
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
                height90,
                Center(
                  child: SizedBox(
                    width: 350.w,
                    child: RichTextWidget(
                      Text('By clicking “Sign up”, you agree to Spraay’s Terms of Service and Privacy Policy',
                        style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 14.sp, color: CustomColors.sWhiteColor),textAlign: TextAlign.center,
                      ),textAlign: TextAlign.center,
                      // rich text list
                      richTexts: [
                        BaseRichText("Terms of Service", style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 14.sp, color: CustomColors.sPrimaryColor400,),
                          onTap:(){
                            openWebPage(url: "https://www.spraay.ng/terms");
                          },
                        ),
                        BaseRichText("Privacy Policy", style:  CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 14.sp, color: CustomColors.sPrimaryColor400),
                          onTap:(){
                            openWebPage(url: "https://www.spraay.ng/privacy");
                          },
                        ),

                      ],
                    ),
                  ),
                ),
                height34,

              ],
            ),
          )),
    );
  }
}
