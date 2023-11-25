import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/navigations/SlideUpRoute.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/authentication/create_account.dart';
import 'package:spraay/ui/authentication/create_account_otp_page.dart';
import 'package:spraay/ui/authentication/forgot_password_screen.dart';
import 'package:spraay/ui/dashboard/dashboard_screen.dart';
import 'package:spraay/utils/local_authentication.dart';
import 'package:spraay/utils/my_sharedpref.dart';
import 'package:spraay/utils/secure_storage.dart';
import 'package:spraay/view_model/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  final GlobalKey<FormState> _myKey = GlobalKey<FormState>();
  bool _isObscure = true;

  FocusNode? _textField1Focus;
  FocusNode? _textField2Focus;


  AuthProvider? credentialsProvider;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    credentialsProvider=context.watch<AuthProvider>();
  }

  String password="";
  @override
  void initState() {
    super.initState();
    setState(() {
      checkedValue= MySharedPreference.getRemember()==1?true:false;

      phoneController.text=MySharedPreference.getRemember()==1?MySharedPreference.getPhoneNumber().substring(1).toString():"";
      firstBtn=MySharedPreference.getRemember()==1?MySharedPreference.getPhoneNumber().substring(1):"";
      _textField1Focus = FocusNode();
      _textField2Focus = FocusNode();
    });

    SecureStorage().getPassword().then((value){
      if(value.isNotEmpty){
       setState(() {password=value;});
      }
    });
  }

  String firstBtn="";
  String secondBtn="";
  @override
  void dispose() {
    _textField1Focus?.dispose();
    _textField2Focus?.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  LoadingOverlayWidget(
      loading: credentialsProvider!.loading,
      child: Scaffold(
          appBar: appBarSize(height: 28.h),
          body: Form(
            key: _myKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: horizontalPadding,
              shrinkWrap: true,
              children: [
                height16,
                Text("Login to your\nAccount",
                    style: CustomTextStyle.kTxtBold.copyWith(fontWeight: FontWeight.bold, fontSize: 48.sp, color: CustomColors.sGreyScaleColor50)),
                height40,

                CustomizedTextField(textEditingController:phoneController, keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,hintTxt: "7012345678",focusNode: _textField1Focus,
                  maxLength: 10,
                  autofocus: MySharedPreference.getRemember()==1?false: true,
                  prefixText: "+234 ",
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
                height20,
                Center(child: buildCheckBox()),
                height20,
                Provider.of<AuthProvider>(context, listen: false).value==true?GestureDetector(
                    onTap: ()async{
                      local_auth();
                    },
                    child: Center(child: Padding(
                      padding:  EdgeInsets.only(bottom: 20.h),
                      child: Image.asset("images/biometric.png", color: CustomColors.sPrimaryColor500,),
                    ))):SizedBox.shrink(),

                CustomButton(
                    onTap: () {
                      if( firstBtn.isNotEmpty && secondBtn.isNotEmpty){

                        Provider.of<AuthProvider>(context, listen: false).fetchLoginEndpoint(context, passwordController.text, "0${phoneController.text}");

                      }
                    },
                    buttonText: 'Sign in', borderRadius: 30.r,width: 380.w,
                    buttonColor: ( firstBtn.isNotEmpty && secondBtn.isNotEmpty) ? CustomColors.sPrimaryColor500:
                    CustomColors.sDisableButtonColor),
                height22,
                GestureDetector(
                  onTap:(){
                    Navigator.push(context, SlideUpRoute(page: ForgotPasswordScreen()));
                  },
                  child: Text("Forgot the password?",
                    style: CustomTextStyle.kTxtSemiBold.copyWith(fontWeight: FontWeight.w500, fontSize: 16.sp, color: CustomColors.sGreyScaleColor700 ),textAlign: TextAlign.center,),
                ),

                height34,

                GestureDetector(
                  onTap:(){
                    Navigator.push(context, SlideLeftRoute(page: CreateAccount()));
                  },
                    child: buildTwoTextWidget(title: "Don’t have an account?", content: " Sign up")),
                height34,


              ],
            ),
          )),
    );
  }

  bool checkedValue=false;
  Widget buildCheckBox(){
    return  SizedBox(
      width: 220.w,
      child: CheckboxListTile(
        contentPadding: EdgeInsets.only(left: 0.w),
        checkColor: Colors.white,
        activeColor: CustomColors.sPrimaryColor500,
        title: Text("Remember me", style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 14.sp, color: Color(0xffF0F0F0)),),
        // subtitle: Text("08:00  -  11:00 AM", style: kTxtLight.copyWith(fontSize: 10.sp, fontWeight: FontWeight.w300, color: Colors.black),),
        value: checkedValue,
        onChanged: (newValue) {
          setState(() {
            checkedValue = newValue!;
          });

          if(checkedValue==true){
            MySharedPreference.saveRemember(1);
          }else{
            MySharedPreference.saveRemember(0);
          }

          // print("checkedValue=$checkedValue");
        },
        controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
      ),
    );
  }

  local_auth()async {
    bool isAuthenticated = await Authentication.authenticateWithBiometrics();

    if (isAuthenticated) {
      //if authenticated, login
      Provider.of<AuthProvider>(context, listen: false).fetchLoginEndpoint(context,password, MySharedPreference.getPhoneNumber());

    }
    else {
      toastMessage("Error authenticating using Biometrics.");
    }
  }
}
