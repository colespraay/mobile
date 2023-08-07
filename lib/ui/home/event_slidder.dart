import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/events/event_details.dart';

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
            Navigator.push(context, FadeRoute(page: EventDetails()));
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
}
