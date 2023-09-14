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
          _buildColumn(title: "1. Introduction", content: "Welcome to Spraay, a mobile application developed by Middl Technologies. This Privacy Policy is designed to help you understand how we collect, use, share, and safeguard your information when you use our app."),
          _buildColumn(title: "2. Information We Collect", content: "a. Personal Information: When you sign up for an account, we may collect personal information,including your name, email address, phone number, and date of birth.\n\nb. Usage Information: We collect information about your interactions with the app, including log data, device information, and app activity.\n\nc. Payment Information: If you make transactions through Spraay, we will collect payment information, such as credit card details or other payment methods.\n\nd. Location Information: With your consent, we may collect your precise location data to provide location-based features."),
          _buildColumn(title: "3. How We Use Information", content: "a. To Provide Services: We use your information to provide and personalize our services, process transactions, and enable you to spray and receive money digitally.\n\nb. To Improve Services: We use data to understand how our services are used, identify trends, and enhance the user experience.\n\nc. To Communicate: We may contact you for service updates, security alerts, and promotional messages based on your preferences. "),

          _buildColumn(title: "4. Sharing of Information", content: "a. With Other Users: Users can spray money to each other. The recipient will see your username and the amount sprayed.\n\nb. With Service Providers: We may share information with third-party service providers for payment processing, data analysis, and other services. \n\nc. For Legal Compliance: We may share data when required by law, to respond to legal requests, or to protect our rights and safety."),
          _buildColumn(title: "5. Your Choices", content: "a. Access and Control: You have the right to access, correct, or delete your personal information. You can do this through the app settings.\n\n b. Marketing Communications: You can manage your communication preferences regarding marketing messages."),
          _buildColumn(title: "6. Security", content: "We employ technical and organizational measures to protect your data. However, no method of data transmission or storage is completely secure, so we cannot guarantee absolute security."),
          _buildColumn(title: "7. Changes to this Privacy Policy", content: "We may update this Privacy Policy to reflect changes to our practices. We will notify you of any material changes via email or within the app."),
          _buildColumn(title: "8. Contact Information", content: "If you have questions about this Privacy Policy or our practices, please contact us at support@spraay.ng"),
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
