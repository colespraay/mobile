import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/profile/reset_trans_pin/change_transaction_pin.dart';
import 'package:spraay/view_model/auth_provider.dart';

class ResetTransactionPin extends StatefulWidget {
  const ResetTransactionPin({super.key});

  @override
  State<ResetTransactionPin> createState() => _ResetTransactionPinState();
}

class _ResetTransactionPinState extends State<ResetTransactionPin> {
  TextEditingController passwordController=TextEditingController();
  final GlobalKey<FormState> _myKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _isObscureConf = true;

  FocusNode? _textField1Focus;
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
    });
  }

  String firstBtn="";
  String secondBtn="";
  @override
  void dispose() {
    _textField1Focus?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  LoadingOverlayWidget(
      loading: credentialsProvider?.loading??false,
      child: Scaffold(
          appBar: buildAppBar(context: context, title: "Confirm Password"),
          body: Form(
            key: _myKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: horizontalPadding,
              shrinkWrap: true,
              children: [
                height30,
                Center(
                  child: Text("To change your transaction PIN, please confirm your password",
                      style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 18.sp, color: CustomColors.sGreyScaleColor50), textAlign: TextAlign.center,),
                ),
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

                height60,

                CustomButton(
                    onTap: () {
                      if( firstBtn.isNotEmpty ){
                        Provider.of<AuthProvider>(context, listen: false).fetchConfLoginEndpoint(context, passwordController.text, credentialsProvider?.dataResponse?.phoneNumber??"");
                      }
                    },
                    buttonText: 'Continue', borderRadius: 30.r,width: 380.w,
                    buttonColor: ( firstBtn.isNotEmpty) ? CustomColors.sPrimaryColor500:
                    CustomColors.sDisableButtonColor),
                height22,

              ],
            ),
          )),
    );
  }
}
