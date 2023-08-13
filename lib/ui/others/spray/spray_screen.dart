import 'dart:developer';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';

class SprayScreen extends StatefulWidget {
  const SprayScreen({Key? key}) : super(key: key);

  @override
  State<SprayScreen> createState() => _SprayScreenState();
}

class _SprayScreenState extends State<SprayScreen> {

  final AppinioSwiperController controller = AppinioSwiperController();
  double amount=0.00;

  List<String> candidates=["Hellop", "Daniel", "Frank", "How","Hellop", "Daniel", "Frank", "How"];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: appBarSize(),
        body: Padding(
          padding: horizontalPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildContainer(),
              (amount>0 && _isSprayEndReached==false)?  Center(
                child: Padding(
                  padding:  EdgeInsets.only(top: 30.h),
                  child: CustomButton(
                      onTap: () {
                      },
                      buttonText: 'Stop spray', borderRadius: 30.r,width: 380.w,
                      buttonColor: CustomColors.sErrorColor),
                ),
              ): SizedBox.shrink(),

              _isSprayEndReached==false? Spacer(): Expanded(child: _buildLimitReached()),

              _isSprayEndReached==false?buildSprayWidget(): SizedBox.shrink()

              //     .animate()
              //     .slide(duration: 1000.ms).fadeOut()
              // /* .then(delay: 1000.ms) // baseline=800ms
              //         .fadeOut()*/

            ],
          ),
        ));
  }


  bool _isSprayEndReached=false;

  void _swipe(int index, AppinioSwiperDirection direction) {
    setState(() {
      amount =amount+1000;
    });
    log("the card was swiped to the: " + direction.name);
  }

  void _unswipe(bool unswiped) {
    if (unswiped) {
      log("SUCCESS: card was unswiped");
    } else {
      log("FAIL: no card left to unswipe");
    }
  }

  void _onEnd() {
    setState(() {_isSprayEndReached=true;});
    log("end reached!");
  }


  Widget buildContainer(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(color: Color(0xff1A1A21), borderRadius: BorderRadius.all(Radius.circular(18.r))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("images/profilewiz.png", width: 120.w, height: 140.h, fit: BoxFit.cover,),
          SizedBox(width: 2.w,),
          Expanded(
            child: Padding(
              padding:  EdgeInsets.only(right: 16.w, top: 16.h, bottom: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("#Amik23 - Amara weds", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor50) ),
                  height4,
                  Text("Ikechukwu", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor500) ),
                  height8,
                  buildDateAndLocContainer(title: "₦${amount}")

                ],
              ),
            ),
          )


        ],

      ),
    );
  }
  Widget buildDateAndLocContainer({required String title}){
    return Container(
      height: 38.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
          color: CustomColors.sGreenColor500,
          borderRadius: BorderRadius.all(Radius.circular(4.r))
      ),
      child: Center(child: Text(title, style: CustomTextStyle.kTxtBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700,
          color: CustomColors.sGreyScaleColor900, fontFamily: "PlusJakartaSans") )),
    );
  }

  Widget buildSprayWidget(){
    return SizedBox(
      height: 600.h,
      child: Center(child: Stack(
        children: [

          Align(
              alignment: Alignment.topCenter,
              child: EmptyListLotie("swipe_animate")),

          Align(
            alignment: Alignment.bottomCenter,
              child: Image.asset("images/hand.png", height: 200.h, )),
          Positioned(
              bottom:30.h,
              right: 0.w,
              left: 50.w,
              child: SizedBox(
                height:250.h,
                width: 128.w,
                child: AppinioSwiper(
                  backgroundCardsCount:2,
                  direction:  AppinioSwiperDirection.top,
                  swipeOptions: const AppinioSwipeOptions.only(top: true),
                  unlimitedUnswipe: true,
                  controller: controller,
                  unswipe: _unswipe,
                  onSwiping: (AppinioSwiperDirection direction) {
                    debugPrint(direction.toString());
                  },
                  onSwipe: _swipe,
                  // padding:  EdgeInsets.only(left: 25.w, right: 25.w, top: 50.h, bottom: 40.h,),
                  onEnd: _onEnd,
                  cardsCount: candidates.length,
                  cardsBuilder: (BuildContext context, int index) {
                    return Image.asset("images/money.png", width: 128.w, height: 250.h,);
                  },
                ),
              )),
        ],
      )),
    );
  }

  Widget _buildLimitReached(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Center(child: Text("Limit reached", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 28.sp, fontWeight: FontWeight.w800,),)),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Expanded(
              child: CustomButton(
                  onTap: () {
                  },
                  buttonText: 'I am done', borderRadius: 30.r,height: 45.h,
                  buttonColor: CustomColors.sErrorColor),
            ),

            SizedBox(width: 20.w,),

            Expanded(
              child: CustomButton(
                  onTap: () {
                  },
                  buttonText: 'Top up', borderRadius: 30.r,height: 45.h,
                  buttonColor: CustomColors.sPrimaryColor500),
            ),
          ],
        ),
      ],
    );
  }

}
