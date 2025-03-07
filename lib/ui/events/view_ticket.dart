import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';

class ViewTicket extends StatefulWidget {
  const ViewTicket({Key? key}) : super(key: key);

  @override
  State<ViewTicket> createState() => _ViewTicketState();
}

class _ViewTicketState extends State<ViewTicket> {

  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBarClick(context: context, title: "Ticket Details", action: [GestureDetector(
          onTap:(){
             _takeScreenhot();
          },
          child: Padding(
            padding:  EdgeInsets.only(right: 18.w),
            child: SvgPicture.asset("images/arrow_svg.svg"),
          ),
        )]),
        body:  Screenshot(
          controller: screenshotController,
          child: Container(
            
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 10.w),
            decoration: BoxDecoration(
              color: CustomColors.sDarkColor2,
              borderRadius: BorderRadius.all(Radius.circular(16.r))
            ),
            child: ListView(
              padding: horizontalPadding,
              children: [
                height12,
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: double.infinity,
                        height: 455.h,
                        decoration: BoxDecoration(
                            color: CustomColors.sPrimaryColor500,
                            borderRadius: BorderRadius.all(Radius.circular(14.r))
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 24.h,
                      left: 18.w,
                      right: 18.w,
                      child: Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                            color: Color(0xB209090B),
                            borderRadius: BorderRadius.all(Radius.circular(8.r))
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("More Love, Less Ego Tour", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 24.sp, fontWeight: FontWeight.w700) ),
                            Text("Wizkid", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor400) ),
                          ],
                        ),
                      ),
                    ),


                  ],
                ),
                height22,

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: SizedBox(width: 150.w, child: buildMiniColumn(title: "Name", content: "Uche Usman"))),
                    SizedBox(width: 12.w,),
                    Expanded(child: SizedBox(width: 150.w, child: buildMiniColumn(title: "Seat", content: "Regular"))),

                  ],
                ),
                height16,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: SizedBox(width: 150.w, child: buildMiniColumn(title: "Date", content: "13th May 2023"))),
                    SizedBox(width: 12.w,),
                    Expanded(child: SizedBox(width: 150.w, child: buildMiniColumn(title: "Location", content: "Landmark Beach"))),

                  ],
                ),
                height22,
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: CustomColors.sDarkColor3
                ),
                child: BarcodeWidget(
                  height: 100.h,
                  color: Color(0xffEEECFF),
                  barcode: Barcode.code128(),
                  data: '7 1234 03782143 3482',
                  style:CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500, color: CustomColors.sPrimaryColor100) ,
                ),
              ),

              ],
            ),
          ),
        ));
  }

  void _takeScreenhot() async{
    final box = context.findRenderObject() as RenderBox?;
    await screenshotController.capture(delay: const Duration(milliseconds: 10)).then((Uint8List ?image) async {
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/image.png').create();
        await imagePath.writeAsBytes(image);
        await Share.shareFiles([imagePath.path],
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
        );
      }
    });
  }

  Widget buildMiniColumn({required String title, required String content}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor500) ),
        height4,
        Text(content, style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w500, color: CustomColors.sWhiteColor) ),
      ],
    );
  }


  AppBar buildAppBarClick({required BuildContext context, String ?title,
    List<Widget>? action, Color? arrowColor,Brightness? statusBarBrightness,Brightness? statusBarIconBrightness,
    Color ? backgroundColor }){
    return AppBar(
      backgroundColor: backgroundColor??Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: statusBarBrightness??Brightness.dark, statusBarIconBrightness:statusBarIconBrightness?? Brightness.light,statusBarColor: Colors.transparent),

      centerTitle: false,
      leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            },
          child:  Icon(Icons.arrow_back_outlined, color: arrowColor??Color(0xffFBFBFB),)),
      title: Text(title?? "",
          style: CustomTextStyle.kTxtBold.copyWith(fontSize: 24.sp, fontWeight: FontWeight.w700) ),
      actions:action??[],
    );
  }
}
