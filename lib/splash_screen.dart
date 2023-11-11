import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/authentication/screen_direction.dart';
import 'package:spraay/ui/onboarding/onboarding.dart';

class SplashScreen extends StatefulWidget {
  static String id="splashscreen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
      backgroundColor: CustomColors.sBackgroundColor,
      body:   Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildWidget()
          ],
        ),
      ),

    );
  }

  Widget _buildWidget(){
    return  AnimationLimiter(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("images/logo.svg"),
          SizedBox(width: 10.w,),
          Column(
            children: AnimationConfiguration.toStaggeredList(
              // duration: const Duration(milliseconds: 2000),
              duration: const Duration(milliseconds: 2500),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: -100.0,
                curve: Curves.fastLinearToSlowEaseIn,
                child: FadeInAnimation(child: widget,),),
              children: [
                Padding(
                  padding:  EdgeInsets.only(top: 10.h),
                  child: SvgPicture.asset("images/spraay.svg"),
                )

              ],),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Timer(Duration(seconds: 4), ()=> Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ScreenDirection())));
  }
}
