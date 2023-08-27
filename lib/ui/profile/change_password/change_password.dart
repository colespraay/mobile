import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/utils/my_sharedpref.dart';
import 'package:spraay/view_model/auth_provider.dart';

class Changepassword extends StatefulWidget {
  const Changepassword({super.key});

  @override
  State<Changepassword> createState() => _ChangepasswordState();
}

class _ChangepasswordState extends State<Changepassword> {
  TextEditingController confPassController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  final GlobalKey<FormState> _myKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _isObscureConf = true;

  FocusNode? _textField1Focus;
  FocusNode? _textField2Focus;

  AuthProvider? credentialsProvider;
  @override
  void didChangeDependencies() {
    credentialsProvider=context.watch<AuthProvider>();
    super.didChangeDependencies();
  }

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
                  textInputAction: TextInputAction.next,hintTxt: "Current Password", obsec: _isObscure, focusNode: _textField1Focus,
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
                  textInputAction: TextInputAction.done,hintTxt: "Password", obsec: _isObscureConf, focusNode: _textField2Focus,
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

                height60,

                CustomButton(
                    onTap: () {
                      if( firstBtn.isNotEmpty && secondBtn.isNotEmpty){
                        Provider.of<AuthProvider>(context, listen: false).changePasswordEndpoint(context, MySharedPreference.getToken(),
                            passwordController.text, confPassController.text);

                      }
                    },
                    buttonText: 'Continue', borderRadius: 30.r,width: 380.w,
                    buttonColor: ( firstBtn.isNotEmpty && secondBtn.isNotEmpty) ? CustomColors.sPrimaryColor500:
                    CustomColors.sDisableButtonColor),
                height22,

              ],
            ),
          )),
    );
  }
}
