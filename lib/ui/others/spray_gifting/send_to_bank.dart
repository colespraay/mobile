import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/ui/others/spray_gifting/reci_detail.dart';
import 'package:spraay/ui/others/spray_gifting/select_recipient.dart';

class SendToBank extends StatefulWidget {
  final String giftAmount;
  SendToBank({required this.giftAmount});

  @override
  State<SendToBank> createState() => _SendToBankState();
}

class _SendToBankState extends State<SendToBank> {
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context: context, title: "To Bank Account"),
        body: Padding(
          padding: horizontalPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height26,
              GestureDetector(
                  onTap: () async {
                    Navigator.push(
                        context,
                        SlideLeftRoute(
                            page: SeletRecipientScreen(
                          giftAmount: widget.giftAmount,
                        )));
                  },
                  child: buildContainer(title: 'Send to contact')),
              height18,
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        SlideLeftRoute(
                            page: ReciDetail(
                          giftAmount: widget.giftAmount,
                        )));
                  },
                  child: buildContainer(title: 'Send using Spraay Tag')),
              height40,
            ],
          ),
        ));
  }

  Widget buildContainer({required String title}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(color: CustomColors.sDarkColor2, borderRadius: BorderRadius.all(Radius.circular(16.r))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "images/spray_circle.svg",
            width: 50.w,
            height: 50.h,
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Text(title, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400)),
          ),
          SvgPicture.asset("images/arrow_left.svg")
        ],
      ),
    );
  }
}
