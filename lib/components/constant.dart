import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/services/api_services.dart';


bool isLoading=false;
String url="https://spraay-api-577f3dc0a0fe.herokuapp.com";
ApiServices apiResponse=ApiServices();


// String url="https:";
// ApiServices apiResponse=ApiServices();
String onbTitle1="Create and Share Memorable Events";
String onbTitle2="Attend the Biggest Events";
String onbTitle3="Pay your Bills Conveniently";

String onbCont1="Immerse guests in unforgettable experiences! Digitally spray money, igniting the joyous spirit of celebration.";
String onbCont2="Connect with your favourite celebrity. Be the first to get your favorite celebrity’s tickets.";
String onbCont3="Easily pay your bills digitally with just a few taps, making your financial transactions hassle-free.";
final currrency = new NumberFormat("#,##0.00", "en_US");

//Height
var height4=SizedBox(height: 4.h,);
var height8=SizedBox(height: 8.h,);
var height10=SizedBox(height: 10.h,);
var height12=SizedBox(height: 12.h,);
var height13=SizedBox(height: 13.h,);
var height16=SizedBox(height: 16.h,);
var height18=SizedBox(height: 18.h,);
var height20=SizedBox(height: 20.h,);
var height22=SizedBox(height: 22,);
var height26=SizedBox(height: 26.h,);
var height30=SizedBox(height: 30.h,);
var height34=SizedBox(height: 34.h,);
var height40=SizedBox(height: 40.h,);
var height45=SizedBox(height: 45.h,);
var height50=SizedBox(height: 50.h,);
var height60=SizedBox(height: 60.h,);
var height70=SizedBox(height: 70.h,);
var height80=SizedBox(height: 80.h,);
var height90=SizedBox(height: 90.h,);
var height100=SizedBox(height: 100.h,);
var height200=SizedBox(height: 200.h,);


EdgeInsets horizontalPadding=EdgeInsets.symmetric(horizontal: 18.w);

String dollar_sign = "\$";
 actionBar(){
  if(Platform.isAndroid){SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.white,statusBarIconBrightness: Brightness.light ));}
}

// loadingDialog(context){
//  double height=MediaQuery.of(context).size.height;
//  double width=MediaQuery.of(context).size.width;
//  return showDialog(
//      context: context,
//      barrierDismissible: false,
//      barrierColor: Colors.black12,
//      builder: (BuildContext context){
//       return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState){
//            return Dialog(
//             insetPadding: EdgeInsets.all(20.0),
//             shape: RoundedRectangleBorder(
//              borderRadius: BorderRadius.circular(5),
//             ),
//             child: Container(
//              decoration: BoxDecoration(
//               color: CustomColors.sGreyBlack,
//               borderRadius: BorderRadius.circular(5),
//              ),
//              child: Padding(
//               padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
//               child: Row(
//                crossAxisAlignment: CrossAxisAlignment.center,
//                mainAxisSize: MainAxisSize.min,
//                children: [
//                 Text("Loading...", style: TextStyle(color: CustomColors.sWhite),)
//                ],
//               ),
//              ),
//             ),
//            );
//           });
//      });
// }

extension StringExtension on String {
 String capitalize() {
  return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
 }


}

Divider dividerWidget=Divider(color: CustomColors.sGreyScaleColor800,);

 //17 April, 2:48 PM
 String dateTimeFormat(String value){
  return  DateFormat("d MMMM, h:mm a").format(DateTime.parse(value));
 }


// String getInitials(String account_name) => account_name.isNotEmpty
//     ? account_name.trim().split(' ').map((l) => l[0]).take(2).join() : '';

String getInitials(String account_name) => account_name.isNotEmpty
    ? account_name.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join() : '';

NumberFormat formatNumberAndDecimal = NumberFormat.currency(
 locale: 'en_us',
 symbol: '',
 decimalDigits: 2,
);

String dayString(String date){
 final DateTime dateTime = DateTime.parse(date);
 final DateFormat formatter = DateFormat('d');
 return formatter.format(dateTime);
}

String monthString(String date){
 final DateTime dateTime = DateTime.parse(date);
 final DateFormat formatter = DateFormat('MMM');
 return formatter.format(dateTime);
}

void sharePdfFile(BuildContext context ,Uint8List data, String title)async{
 final box = context.findRenderObject() as RenderBox?;
 if (data != null) {
  final directory = await getApplicationDocumentsDirectory();
  final imagePath = await File('${directory.path}/$title.pdf').create();
  await imagePath.writeAsBytes(data);
  await Share.shareFiles([imagePath.path],
   sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
  );
 }
}



