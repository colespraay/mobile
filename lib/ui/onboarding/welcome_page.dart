import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/SlideDownRoute.dart';
import 'package:spraay/navigations/SlideUpRoute.dart';
import 'package:spraay/ui/authentication/create_account.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SvgPicture.asset("images/background.svg", width: double.infinity, height: double.infinity,
          fit: BoxFit.cover,),
          AnimationLimiter(
            child: ListView(
              shrinkWrap: true,
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 800),
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: 80.0,
                  curve: Curves.easeIn,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: [
                  height16,
                   Text("Welcome to Spray App!",
                    style: CustomTextStyle.kTxtBold.copyWith(fontWeight: FontWeight.bold, fontSize: 24.sp),textAlign: TextAlign.center,),
                  height34,
                  Image.asset("images/spraay_phon.png", height: 570.h,),
                  height70,
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 10.w),
                    child: CustomButton(
                        onTap: () {
                          Navigator.push(context, SlideDownRoute(page: CreateAccount()));
                        },
                        buttonText: 'Continue with Phone Number', borderRadius: 30.r,width: 380.w,
                        buttonColor: CustomColors.sPrimaryColor500 ),
                  ),
                  height34,

                  buildTwoTextWidget(title: "Don’t have an account?", content: " Sign up"),

                  height34,

                ],),
            ),
          ),
        ],
      ),
    );
  }
}
