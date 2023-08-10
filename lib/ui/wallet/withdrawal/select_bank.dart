import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/ui/wallet/withdrawal/receiver_detail.dart';

class SelectBankScreen extends StatefulWidget {
  const SelectBankScreen({Key? key}) : super(key: key);

  @override
  State<SelectBankScreen> createState() => _SelectBankScreenState();
}

class _SelectBankScreenState extends State<SelectBankScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context: context, title: "Select Bank"),
        body:  Padding(
          padding: horizontalPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height26,
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                    itemBuilder: (_, int position){
                  return InkWell(
                    onTap:(){
                      Navigator.push(context, SlideLeftRoute(page: ReceiverDetailScreen()));
                      },
                      child: buildContainer());
                },
                    separatorBuilder: (_, int posit){
                  return height26;
                    },
                    itemCount: 20
                ),
              ),

              height18,



            ],
          ),
        ));
  }

  Widget buildContainer(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset("images/bnk.svg", width: 40.w, height: 40.h,),
        SizedBox(width: 16.w,),
        Text("Access Bank", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400)),

      ],
    );
  }

}
