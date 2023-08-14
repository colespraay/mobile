import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/view_model/auth_provider.dart';

class SprayDetail extends StatefulWidget {
  const SprayDetail({Key? key}) : super(key: key);

  @override
  State<SprayDetail> createState() => _SprayDetailState();
}

class _SprayDetailState extends State<SprayDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context: context, title: "Spray details"),
        body:  Padding(
          padding: horizontalPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              height18,
              // SvgPicture.asset("images/spray_anim.svg", width: 80.w, height: 80.h,),
              // height22,
              buildContainer(),

              height40,
              Center(child: buildButton()),
              height22


            ],
          ),
        ));
  }

  Widget buildContainer(){
    return Container(
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
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            Provider.of<AuthProvider>(context, listen: false).onItemTap(0);

          },
          child: Center(child: Text("Home", style: TextStyle(color: CustomColors.sWhiteColor, fontWeight: FontWeight.w700, fontSize:16.sp, fontFamily: 'Bold',),)),


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

}
