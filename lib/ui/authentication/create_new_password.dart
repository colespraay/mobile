import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/authentication/login_screen.dart';
import 'package:spraay/view_model/auth_provider.dart';

class CreateNewPassword extends StatefulWidget {
  String uniqueVerificationCode;
   CreateNewPassword(this.uniqueVerificationCode);

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  TextEditingController confPassController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  final GlobalKey<FormState> _myKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _isObscureConf = true;

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

  AuthProvider? credentialsProvider;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    credentialsProvider=context.watch<AuthProvider>();

  }

  @override
  Widget build(BuildContext context) {
    return  LoadingOverlayWidget(
      loading: credentialsProvider?.loading??false,
      child: Scaffold(
          appBar: buildAppBar(context: context, title: "Create New Password"),
          body: Form(
            key: _myKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: horizontalPadding,
              shrinkWrap: true,
              children: [
                height30,
                Text("Create a new password to get back into your account",
                    style: CustomTextStyle.kTxtSemiBold.copyWith(fontWeight: FontWeight.w500, fontSize: 18.sp, color: CustomColors.sGreyScaleColor50)),
                height40,

                CustomizedTextField(textEditingController:passwordController, keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,hintTxt: "Password", obsec: _isObscure, focusNode: _textField1Focus,
                  onChanged:(value){
                    setState(() {firstBtn=value;});
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

                CustomizedTextField(textEditingController:confPassController, keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,hintTxt: "Retype Password", obsec: _isObscureConf, focusNode: _textField2Focus,
                  onChanged:(value){
                    setState(() {secondBtn=value;});
                  },

                  surffixWidget: GestureDetector(
                    onTap: (){setState(() {_isObscureConf = !_isObscureConf;});},
                    child: Padding(
                      padding:  EdgeInsets.only(right: 8.w),
                      child: Icon(_isObscureConf ? Icons.visibility_off: Icons.visibility, color: Color(0xff9E9E9E),),
                    ),
                  ),
                  prefixIcon: Padding(
                    padding:  EdgeInsets.only(right: 8.w, left: 10.w),
                    child: SvgPicture.asset("images/lock.svg"),
                  ),
                ),

                // height20,
                // Center(child: buildCheckBox()),
                height70,

                CustomButton(
                    onTap: () {
                      if( firstBtn.isNotEmpty && secondBtn.isNotEmpty && firstBtn ==secondBtn){
                        Provider.of<AuthProvider>(context, listen: false).changeForgotPasswordEndpoint(context, widget.uniqueVerificationCode, passwordController.text);
                      }
                    },
                    buttonText: 'Continue', borderRadius: 30.r,width: 380.w,
                    buttonColor: ( firstBtn.isNotEmpty && secondBtn.isNotEmpty&&
                        firstBtn ==secondBtn) ? CustomColors.sPrimaryColor500:
                    CustomColors.sDisableButtonColor),
                height22,

              ],
            ),
          )),
    );
  }

  bool checkedValue=false;
  Widget buildCheckBox(){
    return  CheckboxListTile(
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
      },
      controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
    );
  }


}
