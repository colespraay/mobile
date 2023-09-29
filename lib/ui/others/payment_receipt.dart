import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/file_storage.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/ui/profile/help_and_support.dart';
import 'package:spraay/view_model/transaction_provider.dart';


class PaymentReceipt extends StatefulWidget {
  String svg_img, amount, type, date, meterNumber, transactionRef, transStatus,transactionId;
   PaymentReceipt({required this.svg_img, required this.type, required this.date, required this.amount, required this.meterNumber, required this.transactionRef
  , required this.transStatus, required this.transactionId});

  @override
  State<PaymentReceipt> createState() => _PaymentReceiptState();
}

class _PaymentReceiptState extends State<PaymentReceipt> {

  ScreenshotController screenshotController = ScreenshotController();
  TransactionProvider? _transactionProvider;

  @override
  void initState() {
    super.initState();
    FileStorage.getExternalDocumentPath();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _transactionProvider=context.watch<TransactionProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayWidget(
      loading: _transactionProvider!.loading,
      child: Scaffold(
          appBar: buildAppBar(context: context, title: "Receipt"),
          body:  ListView(
            padding: horizontalPadding,
            children: [
              height18,
              SvgPicture.asset("images/${widget.svg_img}.svg", width: 80.w, height: 80.h,),
              // height16,
              buildContainer(),

              height40,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap:(){
                      Provider.of<TransactionProvider>(context, listen: false).downloadPdf(context, widget.transactionId);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("images/download.svg"),
                        height4,
                        Text("Download Receipt", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400) ),
                      ],
                    ),
                  ),

                  SizedBox(width: 50.w,),
                  InkWell(
                    onTap:(){
                      _takeScreenhot();
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("images/share_m.svg"),
                        height4,
                        Text("Share Receipt", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400) ),
                      ],
                    ),
                  ),


                ],
              ),
              height40,
              buildButton(),
              height22


            ],
          )),
    );
  }

  Widget buildContainer(){
    return Screenshot(
      controller: screenshotController,
      child: Container(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 39.h, top: 10.h),
        decoration: BoxDecoration(
            color:CustomColors.sBackgroundColor,
            // borderRadius: BorderRadius.all(Radius.circular(23.r))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Center(child: Text("Here is your spray details", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700) )),
            // height16,
            dividerWidget,
            height26,
            buildRow(title: "Transaction Amount:", content: "${widget.amount}"),
            height12,
            buildRow(title: "Transaction Type:", content: widget.type),
            height12,
            buildRow(title: "Transaction Date:", content:dateTimeFormat(widget.date)),
            height12,
            buildRow(title: "Meter No:", content: widget.meterNumber),
            height12,
            buildRow(title: "Transaction Reference:", content: widget.transactionRef),
            height12,
            buildContainerRow(title: "Transaction Status:", content: widget.transStatus),
            height16,
            dividerWidget,

          ],
        ),
      ),
    );
  }

  Widget buildRow({required String title, required String content}){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 140.w,
            child: Text(title, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 13.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor500) )),
        Spacer(),

        Text(content, style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w700, fontFamily: "SemiPlusJakartaSans") ),
      ],
    );
  }

  Widget buildContainerRow({required String title, required String content}){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 130.w,
            child: Text(title, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor500) )),
        Spacer(),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: CustomColors.sErrorColor,
            borderRadius: BorderRadius.all(Radius.circular(50.r))
          ),
            child: Text(content, style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w700) )),
      ],
    );
  }


  Widget buildButton(){

    return Container(
      width:double.infinity,
      height: 58.h,
      decoration: BoxDecoration(
          color:CustomColors.sPrimaryColor500,
          borderRadius: BorderRadius.circular(100.r)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (){
            Navigator.push(context, SlideLeftRoute(page: HelpAndSupportScreen()));


          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Speak to Support", style: TextStyle(color: CustomColors.sWhiteColor, fontWeight: FontWeight.w700, fontSize:16.sp, fontFamily: 'Bold',),),
              SizedBox(width: 10.w,),
              SvgPicture.asset("images/headphone.svg")
            ],
          ),

        ),

      ),

    );
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

}
