import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/others/spray/spray_detail.dart';

class RateExperience extends StatefulWidget {
  String? response_amount, response_transactiondate, response_eventId,response_transactRef;

   RateExperience({required this.response_amount, required this.response_eventId,required this.response_transactiondate,required this.response_transactRef, Key? key}) : super(key: key);

  @override
  State<RateExperience> createState() => _RateExperienceState();
}

class _RateExperienceState extends State<RateExperience> {
  @override
  Widget build(BuildContext context) {
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
                    // height18,
                    GestureDetector(
                      onTap:(){
                        Navigator.pop(context);
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                          child: Icon(Icons.close, color: Colors.white,)),
                    ),
                    height30,
                    Text("Rate this Experience", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 24.sp, fontWeight: FontWeight.w700, color: CustomColors.sPrimaryColor400),),
                    height18,
                    buildImg(),

                    // height22,

                  ],
                ),
              ),
            ),
          );
        });
  }

  String img="not_happyy";
  // int count=0;
  int _counter = 0;
  bool _incrementing = true;

  void _updateCounter() {
    setState(() {
      if (_incrementing) {
        _counter++;
        if (_counter == 2) {
          _incrementing = false;
        }
      } else {
        _counter--;
        if (_counter == 0) {
          _incrementing = true;
        }
      }
    });

    // if(_counter==0)
    if(_counter==0){
      setState(() {
        img="not_happyy";
      });
    }
    else if(_counter==1){
      setState(() {
        img="just_heree";
      });
    }

    else if(_counter==2){
      setState(() {
        img="be_happy";
      });
    }

    // print("_counter_counter=${_counter}");
  }
  //just_heree be_happy
  Widget buildImg(){
    return SizedBox(
      height: 400.h,
      child: Stack(
        children: [
          GestureDetector(
            onTap:(){
              _updateCounter();
            },
              child: Image.asset("images/$img.png", width: 180.w, height: 270.h,)),

          // height30,
          Positioned(
            bottom: 1.h,
            left: 0.w,
            right: 0.w,
            child: CustomButton(
                onTap:(){

                  Navigator.pushReplacement(context, FadeRoute(page: SprayDetail(response_amount:widget.response_amount, response_eventId:widget.response_eventId,
                  response_transactiondate: widget.response_transactiondate, response_transactRef:widget.response_transactRef,)));
                },
                buttonText: "Submit", borderRadius: 30.r,
                buttonColor:  CustomColors.sPrimaryColor500),
          ),

          Positioned(
            bottom: 80.h,
            left: 0.w,
            right: 0.w,
            child: SizedBox(
                width: 276.w,
                child: Text("Click on image to rate", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: CustomColors.sWhiteColor),
                  textAlign: TextAlign.center,)),
          ),
        ],
      ),
    );
  }
}
