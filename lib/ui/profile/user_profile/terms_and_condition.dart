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
          _buildColumn(title: "1. Acceptance of Terms", content: "By using the Spraay App, you agree to these Terms and Conditions. If you do not agree, please do not use the app."),
          _buildColumn(title: "2. User Accounts", content: "a. Registration: To use our services, you must create an account. You are responsible for keeping your account credentials confidential. \n\nb. Account Termination: We reserve the right to suspend or terminate accounts that violate these terms."),
          _buildColumn(title: "3. Content and Usage", content: "a. User Content: You may create, post, or share content through the app. You retain ownership of your content. \n\nb. Prohibited Activities: You must not engage in illegal activities, spam, or abusive behavior on the app."),
          _buildColumn(title: "4. Payments", content: "If you use payment features on the app, you agree to pay all associated fees. Payment information must be accurate and current."),
          _buildColumn(title: "5. Intellectual Property", content: "a. Ownership: Spraay and Middl Technologies own all rights, title, and interest in the app and its content."),

          _buildColumn(title: "6. Disclaimers and Limitations", content: "a. No Warranties: We provide the app \"as-is,\" and we do not make any warranties regarding its accuracy or reliability. \n\nb. Limitation of Liability: We are not liable for any direct, indirect, or consequential damages arising from your use of the app."),
          _buildColumn(title: "7. Termination", content: "We may terminate your access to the app at our discretion, without notice."),

          _buildColumn(title: "8. Governing Law and Jurisdiction", content: "These terms are governed by the laws of Nigeria, and any disputes shall be resolved in the appropriate courts."),
          _buildColumn(title: "9. Changes to Terms and Conditions", content: "We may update these terms to reflect changes in our services. Users will be notified of any material changes."),
          _buildColumn(title: "10. Contact Information", content: "For questions or support, please contact us at [support@spraay.ng]. Visit our website at [www.Spraay.ng].")

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
