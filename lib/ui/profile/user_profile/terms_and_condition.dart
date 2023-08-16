import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({super.key});


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: buildAppBar(context: context, title:"Terms and Condition" ),
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
          _buildColumn(title: "1. Acceptance of Terms", content: "By downloading, installing, or using the Spray App, you agree to be bound by these Terms and Conditions. If you do not agree with any part of these terms, please refrain from using the app."),
          _buildColumn(title: "2.  Use of your Personal Data", content: "You agree to use the Spray App for lawful purposes and in compliance with applicable laws and regulations. You shall not use the app for any illegal or unauthorized activities."),
          _buildColumn(title: "3. Account Creation and Security", content: "When creating an account with the Spray App, you are responsible for maintaining the confidentiality of your login credentials. You must not share your account details with any third party. You are solely responsible for all activities that occur under your account."),
          _buildColumn(title: "4. Privacy and Data Protection", content: "The Spray App respects your privacy and handles your personal information in accordance with our Privacy Policy. By using the app, you consent to the collection, storage, and processing of your personal data as described in the Privacy Policy."),
          _buildColumn(title: "5. Modifications to the App and Terms", content: "The app developer reserves the right to modify, suspend, or discontinue the Spray App, in whole or in part, at any time and without prior notice. The app developer also reserves the right to update or modify these Terms and Conditions at any time. Your continued use of the app after any changes to the terms shall constitute your acceptance of the modified terms."),
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
