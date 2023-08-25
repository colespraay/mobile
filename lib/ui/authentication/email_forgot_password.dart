import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/ui/authentication/forgot_password_otp_verif.dart';
import 'package:spraay/view_model/auth_provider.dart';

class EmailForgotPassword extends StatefulWidget {
  String title;
   EmailForgotPassword({required this.title});

  @override
  State<EmailForgotPassword> createState() => _EmailForgotPasswordState();
}

class _EmailForgotPasswordState extends State<EmailForgotPassword> {
  final GlobalKey<FormState> _myKey = GlobalKey<FormState>();

  AuthProvider? credentialsProvider;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    credentialsProvider=context.watch<AuthProvider>();
  }

  FocusNode? _textField1Focus;
  FocusNode? _textField2Focus;
  TextEditingController textEditingController=TextEditingController();

  @override
  void initState() {
    setState(() {
      _textField1Focus = FocusNode();
      _textField2Focus = FocusNode();
    });
  }

  String firstVal="";
  String secondVal="";

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
          appBar: buildAppBar(context: context, title:"Forgot Password"),
          body: Form(
            key: _myKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child:buildListWidget(),
          )),
    );
  }

  Widget buildListWidget(){
    return ListView(
      padding: horizontalPadding,
      shrinkWrap: true,
      children: [
        height20,
        Text("Enter your ${widget.title}", style: CustomTextStyle.kTxtSemiBold.copyWith(fontWeight: FontWeight.w500, fontSize: 24.sp, color: CustomColors.sGreyScaleColor50)),

         height40,

       widget.title=="email address"?  CustomizedTextField(textEditingController:textEditingController, keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,hintTxt: "Type email address",focusNode: _textField1Focus,
          onChanged:(value){
            setState(() {firstVal=value;});
          },
        ):
       CustomizedTextField(textEditingController:textEditingController, keyboardType: TextInputType.phone,
         textInputAction: TextInputAction.done,hintTxt: "Type phone number",focusNode: _textField1Focus,
         maxLength: 11,
         // autofocus: true,
         // prefixText: "+234 ",
         // prefixIcon: Padding(
         //   padding:  EdgeInsets.only(right: 8.w, left: 10.w),
         //   child: SvgPicture.asset("images/number.svg", height: 11.h,),
         // ) ,
         inputFormat: [
           FilteringTextInputFormatter.digitsOnly
         ],
         onChanged:(value){
           setState(() {firstVal=value;});
         },
       ),


        // height18,
        // Text("Spraay tag available ✅", style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 12.sp, color: CustomColors.sWhiteColor)),


        height90,
        CustomButton(
            onTap: () {
              if( firstVal.isNotEmpty){

                if( widget.title=="email address"){
                  //email address credentialsProvider
                  Provider.of<AuthProvider>(context,listen: false).initiateForgotPasswordEmailEndpoint(context, textEditingController.text);
                }else{
                  Navigator.push(context, SlideLeftRoute(page: ForgotPassOtp(textEditingController.text)));

                }


                // Provider.of<AuthProvider>(context, listen: false).tellUsAboutYourselfTagEndpoint(context, sprayTagController.text, MySharedPreference.getUId());
              }
            },
            buttonText: 'Continue', borderRadius: 30.r,width: 380.w,
            buttonColor: ( firstVal.isNotEmpty ) ? CustomColors.sPrimaryColor500:
            CustomColors.sDisableButtonColor),
        height34,
      ],
    );
  }

}
