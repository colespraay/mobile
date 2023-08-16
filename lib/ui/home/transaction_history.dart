import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/home/transaction_detail.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: 20,
          itemBuilder:(context, int position){
            return SlideListAnimationWidget(
              position: position,
              child: InkWell(
                onTap: (){
                  Navigator.push(context, FadeRoute(page: TransactionDetail()));

                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(color: Colors.grey, shape: BoxShape.circle,
                            // image: DecorationImage(image: AssetImage("images/aa.png"), fit: BoxFit.fill,)
                          ),
                        ),

                        SizedBox(width: 10.w,),

                        Expanded(
                          child: SizedBox(
                            width: 175.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Spray activity at Quilox", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400),),
                                height4,
                                Text("${DateFormat.MMMd().format(DateTime.now())}, ${DateFormat.jm().format(DateTime.now())}",
                                  style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor500),textAlign: TextAlign.center,),
                              ],
                            ),
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("-₦300,000", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700,
                                color: CustomColors.sErrorColor, fontFamily: "PlusJakartaSans")),

                            Text("${DateFormat.jm().format(DateTime.now())}",
                              style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor500),textAlign: TextAlign.center,),

                          ],
                        ),
                      ],
                    ),
                    height10,
                  ],
                ),
              ),
            );
          }),
    );
  }
}
