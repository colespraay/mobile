import 'dart:developer';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/rate_experience.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/others/payment_receipt.dart';
import 'package:spraay/ui/others/spray/spray_detail.dart';
import 'package:spraay/ui/others/spray/topup_spray.dart';
import 'package:spraay/models/join_event_model.dart';


class SprayScreen extends StatefulWidget {
  String cash;
  int totalAmount;
  int noteQuantity;
  int unitAmount;
  Data? eventModelData;
   SprayScreen({required this.cash, required this.totalAmount, required this.noteQuantity, required this.unitAmount, required this.eventModelData});

  @override
  State<SprayScreen> createState() => _SprayScreenState();
}

class _SprayScreenState extends State<SprayScreen>{

  final AppinioSwiperController controller = AppinioSwiperController();
  double amount=0.00;


  int? noteQuantity;
  @override
  void initState() {

  }

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
                        popupStopPayingDialog(context: context, title: "Are you sure?",
                            content: "You are about to stop spraying",
                            buttonTxt: "Yes Stop", onTap: (){
                              // Navigator.pushAndRemoveUntil(context, FadeRoute(page: DasboardScreen()),(Route<dynamic> route) => false);
                              // Provider.of<AuthProvider>(context, listen: false).onItemTap(0);


                              Navigator.pushReplacement(context, FadeRoute(page: SprayDetail()));

                            }, png_img: "question");

                      },
                      buttonText: 'Stop spray', borderRadius: 30.r,width: 380.w,
                      buttonColor: CustomColors.sErrorColor),
                ),
              ).animate().fadeIn(duration: 1000.milliseconds, curve: Curves.easeIn): SizedBox.shrink(),

              _isSprayEndReached==false? Spacer(): Expanded(child: _buildLimitReached().animate() // baseline=800ms
                  .slide(
                  duration: 800.milliseconds,curve: Curves.fastOutSlowIn,
                  begin: Offset(0.0, 1.0),
                  end: Offset.zero
              )),


              _isSprayEndReached==false?buildSprayWidget(): Center(
                child: Image.asset("images/hand.png", height: 200.h, ).animate().slide(
                    begin: Offset.zero,
                    end: Offset(0.0, 1.0),
                    duration: 800.milliseconds,curve: Curves.fastOutSlowIn),
              )

            ],
          ),
        ));
  }


  bool _isSprayEndReached=false;

  void _swipe(int index, AppinioSwiperDirection direction) {
    setState(() {
      amount =amount+widget.unitAmount;
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
          Padding(
            padding:  EdgeInsets.all(8.r),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8.r)),
              child: CachedNetworkImage(
                width: 100.w, height: 140.h,
                fit: BoxFit.cover,
                imageUrl: widget.eventModelData?.eventCoverImage??"",
                placeholder: (context, url) => Center(child: SpinKitFadingCircle(size: 30,color: Colors.grey,)),
                errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
              ),
            ),
          ),          SizedBox(width: 2.w,),
          Expanded(
            child: Padding(
              padding:  EdgeInsets.only(right: 16.w, top: 16.h, bottom: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.eventModelData?.eventName??"", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor50),
                    maxLines: 1, overflow: TextOverflow.ellipsis,),                  height4,
                  Text(widget.eventModelData?.user?.firstName??"", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor500) ),
                  height8,
                  buildDateAndLocContainer(title: "₦${formatNumberAndDecimal.format(amount)}")

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
                  cardsCount: widget.noteQuantity,
                  cardsBuilder: (BuildContext context, int index) {
                    return Image.asset("images/${widget.cash}.png", width: 128.w, height: 250.h,);
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        height40,
        Center(child: Text("Limit reached", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 28.sp, fontWeight: FontWeight.w800,),)),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Expanded(
              child: CustomButton(
                  onTap: () {
                    rateAppPopup();
                  },
                  buttonText: 'I am done', borderRadius: 30.r,height: 45.h,
                  buttonColor: CustomColors.sErrorColor),
            ),

            SizedBox(width: 20.w,),

            Expanded(
              child: CustomButton(
                  onTap: () {
                    Navigator.push(context, FadeRoute(page: TopUpSpray()));
                  },
                  buttonText: 'Top up', borderRadius: 30.r,height: 45.h,
                  buttonColor: CustomColors.sPrimaryColor500),
            ),
          ],
        ),
      ],
    );
  }


  popupStopPayingDialog({ required BuildContext context, required String title, required String content, required String buttonTxt,
    required void Function() onTap, required String png_img}){
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black54,
        builder: (BuildContext context){
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState){
                return Dialog(
                  backgroundColor: CustomColors.sDarkColor2,
                  insetPadding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.r),),
                  child: Container(
                    width: 340.w,
                    decoration: BoxDecoration(
                      color: CustomColors.sDarkColor2,
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                    child: Padding(
                      padding:  EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 20.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          height40,
                          Image.asset("images/$png_img.png",width: 140.w, height: 140.h).animate().scale(),
                          // Container(width: 140.w, height: 140.h, color: Colors.yellow,),
                          height30,
                          Text(title, style: CustomTextStyle.kTxtBold.copyWith(fontSize: 24.sp, fontWeight: FontWeight.w700, color: CustomColors.sPrimaryColor400),),
                          height16,
                          SizedBox(
                              width: 276.w,
                              child: Text(content, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: CustomColors.sWhiteColor),
                                textAlign: TextAlign.center,)),
                          height30,
                          CustomButton(
                              onTap: onTap,
                              buttonText: buttonTxt, borderRadius: 30.r,
                              buttonColor:  CustomColors.sPrimaryColor500),
                          height22,
                          CustomButton(
                              onTap:(){
                                Navigator.pop(context);
                              },
                              buttonText: "Cancel", borderRadius: 30.r,
                              buttonColor:  CustomColors.sDarkColor3),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

  rateAppPopup(){
    return showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black54,
        builder: (BuildContext context){
          return RateExperience();
        });
  }

}
