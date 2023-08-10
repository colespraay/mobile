import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/ui/wallet/withdrawal/select_bank.dart';
import 'package:spraay/ui/wallet/withdrawal/withdrawal_pin.dart';

class ToBankAccount extends StatefulWidget {
  const ToBankAccount({Key? key}) : super(key: key);

  @override
  State<ToBankAccount> createState() => _ToBankAccountState();
}

class _ToBankAccountState extends State<ToBankAccount> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context: context, title: "To Bank Account"),
        body:  Padding(
          padding: horizontalPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height26,

              GestureDetector(
                onTap: (){
                  Navigator.push(context, SlideLeftRoute(page: WithdrawalOtp(fromWhere: 'to_bank_screen',)));
                },
                  child: buildContainer()),

              height18,


              buttonContainer(onTap: (){

                  Navigator.push(context, SlideLeftRoute(page: SelectBankScreen()));

              }),
              height40,

            ],
          ),
        ));
  }

  Widget buttonContainer({required Function()? onTap}){
    return Container(
       width: 380.w,
      height: 58.h,
      decoration: BoxDecoration(
          color: CustomColors.sPrimaryColor500,
          borderRadius: BorderRadius.circular(30.r)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap:onTap,
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Add new bank account",
                  style: TextStyle(color: CustomColors.sWhiteColor, fontWeight: FontWeight.w700, fontSize: 16.sp, fontFamily: 'Bold',),
                ),
                SizedBox(width: 16.w,),
                SvgPicture.asset("images/add_svg.svg")
              ],
            ),
          ),

        ),

      ),

    );
  }
  Widget buildContainer(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: CustomColors.sDarkColor2,
        borderRadius: BorderRadius.all(Radius.circular(16.r))
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset("images/bnk.svg", width: 50.w, height: 50.h,),
          SizedBox(width: 10.w,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Uche Usman", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400)),
                height4,
                Text("1234567890", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor700)),
              ],
            ),
          ),

          SvgPicture.asset("images/arrow_left.svg")

        ],
      ),
    );
  }
}
