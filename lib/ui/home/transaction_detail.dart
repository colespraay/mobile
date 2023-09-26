import 'dart:io';

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
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:pdf/pdf.dart';
import 'package:spraay/models/transaction_models.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/navigations/SlideUpRoute.dart';
import 'package:spraay/ui/profile/help_and_support.dart';

class TransactionDetail extends StatefulWidget {
  DatumTransactionModel? transactionList;
   TransactionDetail(this.transactionList) ;

  @override
  State<TransactionDetail> createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {

  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context: context, title: "Spray details"),
        body:  ListView(
          padding: horizontalPadding,
          children: [
            height18,
            SvgPicture.asset("images/spray_anim.svg", width: 80.w, height: 80.h,),
            height22,
            buildContainer(),

            height40,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              InkWell(
                onTap:(){
                  _captureScreenshotAndSaveAsPdf();
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
        ));
  }

  Widget buildContainer(){
    return Screenshot(
      controller: screenshotController,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 39.h),
        decoration: BoxDecoration(
          color: CustomColors.sDarkColor2,
          borderRadius: BorderRadius.all(Radius.circular(23.r))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text("Here is your spray details", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700) )),
            height16,
            dividerWidget,
            height26,
            buildRow(title: "Spray Amount:", content: "N50,000.00"),
            height8,
            buildRow(title: "Transaction Date:", content: "15 June, 1:23 PM"),
            height8,
            buildRow(title: "Event ID:", content: "xyzrdsa"),
            height8,
            buildRow(title: "Transaction Reference:", content: "SPA2-P9165yz"),
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
        SizedBox(width: 130.w,
            child: Text(title, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400) )),
        Spacer(),

        Text(content, style: CustomTextStyle.kTxtBold.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w700) ),
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

  String _pdfPath = "";

  Future<void> _captureScreenshotAndSaveAsPdf() async {

    await screenshotController.capture(delay: const Duration(milliseconds: 10)).then((Uint8List ?image) async {
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/Downloads/spray.pdf').create();
        await imagePath.writeAsBytes(image);


        final pdf = pdfWidgets.Document();
        pdf.addPage(
          pdfWidgets.Page(
            build: (pdfWidgets.Context context) {
              return pdfWidgets.Image(pdfWidgets.MemoryImage( imagePath.readAsBytesSync()));
            },
          ),
        );

        // await imagePath.create(recursive: true);
        await imagePath.writeAsBytes( await pdf.save());
        setState(() {
          _pdfPath = imagePath.path;
        });

        print("_pdfPath_pdfPath$_pdfPath");

        // await Share.shareFiles([imagePath.path], sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,);
      }
    });


    // Uint8List? screenshotBytes = await screenshotController.capture();

    // Directory? directory = await getExternalStorageDirectory();
    // File pdfFile = File('${directory?.path}/screenshot.pdf');

    // final pdf = pdfWidgets.Document();
    // pdf.addPage(
    //   pdfWidgets.Page(
    //     build: (pdfWidgets.Context context) {
    //       return pdfWidgets.Image(pdfWidgets.MemoryImage(screenshotBytes!));
    //     },
    //   ),
    // );
    //
    // await pdfFile.writeAsBytes( await pdf.save());

    // setState(() {_pdfPath = pdfFile.path;});
  }
}


