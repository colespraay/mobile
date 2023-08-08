import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/ui/wallet/wallet_view.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {

  PageController ?_pageController;
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  int currentIndex = 0;
  onChangedFunction(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarSize(),
        body:  Padding(
          padding: horizontalPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text("Transactions", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 24.sp, fontWeight: FontWeight.w700) )),
              height26,
              _buildContainer(),
              height26,
              Expanded(
                child: PageView(
                  controller: _pageController=PageController(initialPage: 0),
                  onPageChanged: onChangedFunction,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    WalletView(),
                    Container(color: Colors.green,),
                    // OngoingEvent(),
                    // MyEvents()
                  ],),),



            ],
          ),
        ));

  }

  Widget _buildContainer(){
    // double width=MediaQuery.of(context).size.width/2.3;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GestureDetector(
            onTap:(){
              _pageController!.animateToPage(0,duration: _kDuration, curve: _kCurve);
            },
            child: Container(
                width:double.infinity ,
                height: 38.h,
                decoration: BoxDecoration(
                    color:currentIndex==0? CustomColors.sGreenColor500: CustomColors.sDarkColor2,
                    borderRadius: BorderRadius.all(Radius.circular(8.r))
                ),
                child: Center(child: Text("Wallet View", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, color:currentIndex==0? CustomColors.sGreyScaleColor900: CustomColors.sGreyScaleColor500,
                    fontWeight: FontWeight.w400),))),
          ),
        ),


        Expanded(
          child: GestureDetector(
            onTap:(){
              _pageController!.animateToPage(1,duration: _kDuration, curve: _kCurve);
            },
            child: Container(
                width:double.infinity ,
                height: 38.h,
                decoration: BoxDecoration(
                    color:currentIndex==1? CustomColors.sGreenColor500: CustomColors.sDarkColor2,
                    borderRadius: BorderRadius.all(Radius.circular(8.r))
                ),
                child: Center(child: Text("Chart View", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp,
                    color:currentIndex==1? CustomColors.sGreyScaleColor900: CustomColors.sGreyScaleColor500, fontWeight: FontWeight.w400),))),
          ),
        )

      ],
    );
  }
}
