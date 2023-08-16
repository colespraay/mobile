import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: buildAppBar(context: context, title:"Privacy Policy" ),
        body: buildStep1Widget());

  }

  Widget buildStep1Widget(){
    return AnimationLimiter(
      child: ListView(
        padding: horizontalPadding,
        shrinkWrap: true,
        children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 500),
            childAnimationBuilder: (widget) => SlideAnimation(
              horizontalOffset: 50.0,
              child: FadeInAnimation(
                child: widget,
              ),
            ),
        children: [
          height20,
          _buildColumn(title: "1. Types of Data We Collect", content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Elementum sit ipsum quam ac sit maecenas. Nullam vulputate sollicitudin tempus euismod leo pharetra mauris. Sollicitudin velit, in eget sed phasellus enim quam. Sed imperdiet tincidunt neque tempor lectus fermentum massa. Tincidunt maecenas nibh orci nunc. Id vulputate nulla lorem nulla augue quis."),
          _buildColumn(title: "2.  Use of your Personal Data", content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Elementum sit ipsum quam ac sit maecenas. Nullam vulputate sollicitudin tempus euismod leo pharetra mauris. Sollicitudin velit, in eget sed phasellus enim quam. Sed imperdiet tincidunt neque tempor lectus fermentum massa. Tincidunt maecenas nibh orci nunc. Id vulputate nulla lorem nulla augue quis."),
          _buildColumn(title: "3. Disclosure of Personnal Data", content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Elementum sit ipsum quam ac sit maecenas. Nullam vulputate sollicitudin tempus euismod leo pharetra mauris. Sollicitudin velit, in eget sed phasellus enim quam. Sed imperdiet tincidunt neque tempor lectus fermentum massa. Tincidunt maecenas nibh orci nunc. Id vulputate nulla lorem nulla augue quis."),
        ]),
      ),
    );
  }

  Widget _buildColumn({required String title, required String content}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: CustomTextStyle.kTxtBold.copyWith(fontWeight: FontWeight.w700, fontSize: 20.sp)),
        height30,
        Text(content, style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 16.sp, color: Color(0xff818288))),
        height30,
      ],
    );
  }
}
