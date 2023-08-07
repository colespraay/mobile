import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/onboarding/welcome_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  PageController ?_pageController;
  int currentIndex = 0;
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;
  onChangedFunction(int index) {
    setState(() {currentIndex = index;});
  }


  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }
  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      backgroundColor: CustomColors.sBackgroundColor,
      body: Stack(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          PageView(
            controller: _pageController,
            onPageChanged: onChangedFunction,
            children : [
              Stack(
                children: [
                  Image.asset('images/onbd1.gif', width: double.infinity, height: double.infinity, fit: BoxFit.cover),
                  Image.asset("images/bg_trans.png", width: double.infinity, height: double.infinity,
                    fit: BoxFit.cover,),
                ],
              ),
              Stack(
                children: [
                  Image.asset('images/onbd.gif', width: double.infinity, height: double.infinity, fit: BoxFit.cover),
                  Image.asset("images/bg_trans.png", width: double.infinity, height: double.infinity, fit: BoxFit.cover,),
                ],
              ),

              Stack(
                children: [
                  Image.asset('images/onbd3.gif', width: double.infinity, height: double.infinity, fit: BoxFit.cover),

                  Image.asset("images/bg_trans.png", width: double.infinity, height: double.infinity, fit: BoxFit.cover,),
                ],
              ),
              ],
          ),



          Positioned(
              top: 550.h,
              left: 0,
              right: 0,
              child: pageIndicator()),


          currentIndex==2? Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 40.h),
              child: CustomButton(
                  onTap: () {
                    Navigator.push(context, FadeRoute(page: WelcomePage()));
                    },
                  buttonText: 'Let’s Go!', borderRadius: 30.r,width: 380.w,
                  buttonColor: CustomColors.sPrimaryColor500 ),
            ),
          ): GestureDetector(
            onTap:(){
              _pageController!.nextPage( duration: _kDuration, curve: _kCurve);
            },
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 64.w,
                height: 64.h,
                margin: EdgeInsets.only(bottom: 40.h),
                decoration:BoxDecoration(
                  color:CustomColors.sPrimaryColor500,
                  shape: BoxShape.circle
                ),
                child: Center(child: SvgPicture.asset("images/arrow_right.svg")),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget pageIndicator(){
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSmoothIndicator(
              activeIndex: currentIndex,
              count: 3,  //count: pages.length,
              effect: ExpandingDotsEffect( dotColor: CustomColors.sDarkColor3,
                dotHeight: 10.h, dotWidth: 10.w,
                activeDotColor: CustomColors.sGreenColor500,)),
          height20,
          SizedBox(
            width: 360.w,
            child: Text(currentIndex==0? onbTitle1: currentIndex==1? onbTitle2: onbTitle3,
            style: CustomTextStyle.kTxtBold.copyWith(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
          ),
          height26,
          SizedBox(
            width: 360.w,
            child: Text(currentIndex==0? onbCont1: currentIndex==1? onbCont2: onbCont3 ,
              style: CustomTextStyle.kTxtBold.copyWith(fontWeight: FontWeight.bold, fontSize: 18.sp),textAlign: TextAlign.center,),
          ),

        ],
      ),
    );
  }
}
