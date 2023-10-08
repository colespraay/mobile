import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/themes.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.92,
                minChildSize: 0.92,
                maxChildSize: 0.92,
                builder: (BuildContext context, ScrollController scrollController) {

                  // return buildNoNotification();

                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       Container(width: double.infinity, height: 30.h, decoration: BoxDecoration(color: CustomColors.sDarkColor2,
                       borderRadius: BorderRadius.only(topLeft: Radius.circular(25.r), topRight: Radius.circular(25.r))),
                       child: Center(child: SvgPicture.asset("images/indicate.svg")),),

                        Expanded(
                          child: ListView.separated(
                              padding: horizontalPadding,
                              shrinkWrap: true,
                              // controller: scrollController,
                              itemCount: 20,
                              separatorBuilder: (context, int) {
                                return  height12;
                              },
                              itemBuilder:(context, int position){
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    // SvgPicture.asset("images/notf_add_card.svg"),
                                    // SizedBox(width: 10.w,),

                                    Expanded(
                                      child: SizedBox(
                                        width: 175.w,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Card successfully added", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400),),
                                            height4,
                                            Text("You can now top-up your wallet from your card",
                                              style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor500)),
                                          ],
                                        ),
                                      ),
                                    ),

                                    Text("${DateFormat.yMMMd().format(DateTime.now())}",
                                      style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor500)),

                                  ],
                                );
                              }),
                        ),

                      ]);
                });
          }),
    );

  }

  Widget buildNoNotification(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(width: double.infinity, height: 30.h, decoration: BoxDecoration(color: CustomColors.sDarkColor2,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(25.r), topRight: Radius.circular(25.r))),
          child: Center(child: SvgPicture.asset("images/indicate.svg")),),

        Expanded(child: Center(child: SvgPicture.asset("images/no_notification_bell.svg"))),
      ],
    );
  }
}
