import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/events/event_details.dart';
import 'package:spraay/ui/events/my_events.dart';
import 'package:spraay/ui/events/ongoing_event.dart';
import 'package:spraay/ui/events/past_event/past_event.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {

  PageController ?_pageController;
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  int currentIndex = 0;
  onChangedFunction(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarSize(),
        body:  Padding(
          padding: horizontalPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text("Events", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 24.sp, fontWeight: FontWeight.w700) )),
              height26,
              _buildContainer(),
              height26,
              Expanded(
                child: PageView(
                  controller: _pageController=PageController(initialPage: 0),
                  onPageChanged: onChangedFunction,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    OngoingEvent(),
                    MyEvents(),
                    PastEvent()
                  ],),),



            ],
          ),
        ));

  }

  Widget _buildContainer(){
    // double width=MediaQuery.of(context).size.width/2.3;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GestureDetector(
            onTap:(){
              _pageController!.animateToPage(0,duration: _kDuration, curve: _kCurve);
            },
            child: Container(
                width:double.infinity ,
                height: 38.h,
                decoration: BoxDecoration(
                    color:currentIndex==0? CustomColors.sGreenColor500: CustomColors.sDarkColor2,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8.r), bottomLeft: Radius.circular(8.r))
                ),
                child: Center(child: Text("Ongoing", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, color:currentIndex==0? CustomColors.sGreyScaleColor900: CustomColors.sGreyScaleColor500,
                    fontWeight: FontWeight.w400),))),
          ),
        ),


        Expanded(
          child: GestureDetector(
            onTap:(){
              _pageController!.animateToPage(1,duration: _kDuration, curve: _kCurve);
            },
            child: Container(
                width:double.infinity ,
                height: 38.h,
                decoration: BoxDecoration(
                    color:currentIndex==1? CustomColors.sGreenColor500: CustomColors.sDarkColor2,
                    // borderRadius: BorderRadius.all(Radius.circular(8.r))
                ),
                child: Center(child: Text("My Events", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp,
                    color:currentIndex==1? CustomColors.sGreyScaleColor900: CustomColors.sGreyScaleColor500, fontWeight: FontWeight.w400),))),
          ),
        ),


        Expanded(
          child: GestureDetector(
            onTap:(){
              _pageController!.animateToPage(2,duration: _kDuration, curve: _kCurve);
            },
            child: Container(
                width:double.infinity ,
                height: 38.h,
                decoration: BoxDecoration(
                    color:currentIndex==2? CustomColors.sGreenColor500: CustomColors.sDarkColor2,
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(8.r), topRight: Radius.circular(8.r))
                ),
                child: Center(child: Text("Past Events", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp,
                    color:currentIndex==2? CustomColors.sGreyScaleColor900: CustomColors.sGreyScaleColor500, fontWeight: FontWeight.w400),))),
          ),
        )

      ],
    );
  }



}
