import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/navigations/scale_transition.dart';
import 'package:spraay/ui/events/event_details.dart';
import 'package:spraay/ui/home/bvn_verification.dart';

class EventSlidder extends StatefulWidget {
  const EventSlidder({Key? key}) : super(key: key);

  @override
  State<EventSlidder> createState() => _EventSlidderState();
}

class _EventSlidderState extends State<EventSlidder> {

  int currentPos = 0;
  Widget shimmerLoading(){
    return SizedBox(
      width:double.infinity,
      height: 110.h,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(24.r)),
              color: CustomColors.sWhiteColor,
            ),

        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    // if(widget.otherUIsProviders.loading){
    //   return shimmerLoading();
    // }else{
      return buildEventForYou();
  //  }

  }

  Widget buildEventForYou(){
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            _verifyYourIdentityBModal();
            // Navigator.push(context, FadeRoute(page: EventDetails()));
          },
          child: Container(
            width: double.infinity,
            height: 112.h,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(24.r))
            ),

          ),
        ),

        // carouseSliderWidget(),
        height8,
        AnimatedSmoothIndicator(
          // activeIndex: currentIndex,
            activeIndex: 0,
            count: 3,  //count: pages.length,
            effect: ExpandingDotsEffect( dotColor: CustomColors.sDarkColor3,
              dotHeight: 10.h, dotWidth: 12.w,
              activeDotColor: CustomColors.sGreenColor500,)),
      ],
    );
  }



  Widget carouseSliderWidget(/*List<DatumIntroSliderModel>? list*/){
    return CarouselSlider.builder(
      itemCount: 3,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(24.r)),
        child: CachedNetworkImage(
          fit: BoxFit.fitWidth,
          width: double.infinity,
          height: 112.h,
          imageUrl: /*list[itemIndex].image??*/"",
          placeholder: (context, url) => Center(child: SpinKitFadingCircle(size: 30,color: Colors.grey,)),
          errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
        ),
      ),
      options: CarouselOptions(
          autoPlay: true,
          onPageChanged: (index, reason) {
            setState(() {
              currentPos = index;
            });
          },
          height: 115.h,
          enlargeCenterPage: true,
          viewportFraction: 1,
          initialPage: 0,
          enableInfiniteScroll: false,
          reverse: false,
          autoPlayInterval: Duration(seconds: 4),
          autoPlayAnimationDuration: Duration(milliseconds: 700),
          autoPlayCurve: Curves.fastOutSlowIn,
          scrollDirection: Axis.horizontal
      ),
    );
  }

  Future<void> _verifyYourIdentityBModal(){
    double heigth=MediaQuery.of(context).size.height;
    return  showModalBottomSheet(
        context: context,
        backgroundColor: CustomColors.sDarkColor2,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r),),),
        builder: (context)=> StatefulBuilder(
            builder: (context, setState)=>
                Container(
                  width: double.infinity,
                  child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          height34,
                          Text("Verify your Identity", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 24.sp, fontWeight: FontWeight.w700,)),
                          height18,
                          Text("Before you can use Spray App, you need to verify your identity to confirm your name, date of birth and to keep Spray App safe", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w400,)),
                          height40,

                          InkWell(
                            onTap:(){
                              Navigator.pushReplacement(context, ScaleTransition1(page: BvnVerification()));
                            },
                            child: Container(
                              padding: EdgeInsets.all(16.r),
                              decoration: BoxDecoration(
                                  color: CustomColors.sTransparentPurplecolor,
                                  borderRadius: BorderRadius.all(Radius.circular(30.r)),
                                  border: Border.all(color: CustomColors.sGreyScaleColor300)
                              ),
                              child:   Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset("images/profile_avatar.svg", width: 60.w, height: 60.h,),
                                  SizedBox(width: 12.w,),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Verify via BVN", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w500, color: CustomColors.sPrimaryColor100)),
                                        height4,
                                        Text("Verify your account using your Bank Verification Number (BVN)", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400)),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          height22,


                          // height30,
                        ],
                      )
                  ),
                )

        ));
  }

}
