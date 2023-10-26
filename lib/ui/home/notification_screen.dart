import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/notification_model.dart';

class NotificationScreen extends StatelessWidget {

  List<NotificationDatum>? notificationlist;

   NotificationScreen( {required this.notificationlist, Key? key}) : super(key: key);

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

                  if(notificationlist!.isEmpty){
                    return buildNoNotification();
                  }else{

                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(width: double.infinity, height: 30.h, decoration: BoxDecoration(color: CustomColors.sDarkColor2,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(25.r), topRight: Radius.circular(25.r))),
                            child: Center(child: SvgPicture.asset("images/indicate.svg")),),

                          Expanded(
                            child: ListView.separated(
                                padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 16.h),
                                shrinkWrap: true,
                                // controller: scrollController,
                                itemCount: notificationlist!.length,
                                separatorBuilder: (context, int) {
                                  return  height12;
                                },
                                itemBuilder:(context, int position){
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      SvgPicture.asset("images/notification_holder.svg"),
                                      SizedBox(width: 10.w,),

                                      Expanded(
                                        child: SizedBox(
                                          width: 175.w,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(notificationlist?[position].subject??"", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400),),
                                              height4,
                                              Text(notificationlist?[position].message??"",
                                                  style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor500,
                                                      fontFamily: "LightPlusJakartaSans")),
                                            ],
                                          ),
                                        ),
                                      ),

                                      Text("${DateFormat.yMMMd().format(notificationlist![position].dateCreated!)}",
                                          style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor500)),

                                    ],
                                  );
                                }),
                          ),

                        ]);
                  }


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

        Expanded(child: Center(child: SvgPicture.asset("images/no_notification_bell.svg",width: 270.w, height: 300.h,))),
      ],
    );
  }
}
