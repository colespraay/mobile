import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/ui/authentication/email_forgot_password.dart';
import 'package:spraay/ui/authentication/forgot_password_otp_verif.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  Color borderColor=CustomColors.sGreyScaleColor300;
  int click=0;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: buildAppBar(context: context, title: "Forgot Password"),
        body: Padding(
          padding: horizontalPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              height50,
              SvgPicture.asset("images/padlock.svg"),
              height60,
              Text("Select which contact details should we use to reset your password",
                style: CustomTextStyle.kTxtSemiBold.copyWith(fontWeight: FontWeight.w500, fontSize: 18.sp, color: CustomColors.sGreyScaleColor50)),

              height20,
              buildContainer(title: "via SMS:", content:"+234 0 *******90", img: 'sms_svg', borderColor: click==1?CustomColors.sPrimaryColor500: borderColor, onTap: () {
                setState(() {click=1;});
              }),
              height26,
              buildContainer(title: 'via Email:', content: '*******@gmail.com', img: 'email_big', borderColor: click==2?CustomColors.sPrimaryColor500: borderColor, onTap: () {
                setState(() {click=2;});
              }),



              height40,


              CustomButton(
                  onTap: () {
                    if(click>0){


                      Navigator.push(context,
                          SlideLeftRoute(page: EmailForgotPassword(title:click==1? 'phone number': "email address",))
                      );



                    }
                  },
                  buttonText: 'Continue', borderRadius: 30.r,width: 380.w,
                  buttonColor: click>0 ? CustomColors.sPrimaryColor500:
                  CustomColors.sDisableButtonColor),



              height34,


            ],
          ),
        ));
  }

    Widget buildContainer({required String title,required String content, required String img,required Color borderColor, required void Function() onTap }){
    return GestureDetector(
      onTap:onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.r),
        height: 125.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(32.r),),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset("images/$img.svg"),
            SizedBox(width: 20.w,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title,
                      style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 14.sp, color: CustomColors.sGreyScaleColor400)),

                  Text(content,
                      style: CustomTextStyle.kTxtBold.copyWith(fontWeight: FontWeight.w700, fontSize: 16.sp, color: CustomColors.sGreyScaleColor50)),

                ],
              ),
            )

          ],
        ),
      ),
    );
    }
}
