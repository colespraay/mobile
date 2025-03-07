import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/SlideUpRoute.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/navigations/scale_transition.dart';
import 'package:spraay/ui/home/event_slidder.dart';
import 'package:spraay/ui/home/fund_wallet.dart';
import 'package:spraay/ui/home/mini_transaction_history.dart';
import 'package:spraay/ui/home/transaction_history.dart';
import 'package:spraay/ui/wallet/withdrawal/withdrawal.dart';
import 'package:spraay/utils/my_sharedpref.dart';
import 'package:spraay/view_model/event_provider.dart';
import 'package:spraay/view_model/home_provider.dart';

class WalletView extends StatefulWidget {
  const WalletView({Key? key}) : super(key: key);

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {


  @override
  void initState() {
    _isObscure=Provider.of<HomeProvider>(context, listen: false).hideWalletvalue??false;
    Provider.of<EventProvider>(context, listen: false).fetchTransactionListApi();


  }


  EventProvider? eventProvider;
  @override
  void didChangeDependencies() {
    eventProvider=context.watch<EventProvider>();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // shrinkWrap: true,
          children: [
            buildWalletContainer(),
            height30,
            buildHorizontalContainer(),
            height40,
            Expanded(child: buildTransactionList())

          ],
        ));
  }




  bool _isObscure=false;
  String amount="200000";
  Widget buildWalletContainer(){
    // pattern.png
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(40.r)),
      child: Container(
        width: double.infinity,
        height: 200.h,
        padding: EdgeInsets.only(left: 18.w, right: 56.w),
        margin: EdgeInsets.zero,
        decoration: const BoxDecoration(
          color: CustomColors.sPrimaryColor500,
          image: DecorationImage(
            image: AssetImage('images/pattern_endd.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: SizedBox(
            // width: 275.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Wallet Balance", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 10.sp, fontWeight: FontWeight.w700) ),
                height22,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Expanded(
                      child: Text(_isObscure?'${MySharedPreference.getWalletBalance().replaceAll(RegExp(r"."), "*")}':
                      "₦${currrency.format(double.parse(MySharedPreference.getWalletBalance()))}" ,
                          style: CustomTextStyle.kTxtBold.copyWith(fontSize: 24.sp, fontWeight: FontWeight.bold, fontFamily: "PlusJakartaSans")),
                    ),
                    GestureDetector(
                        onTap: (){
                          setState(() {_isObscure = !_isObscure;});
                        },
                        child:  Icon(_isObscure ? Icons.visibility_off_outlined: Icons.visibility_outlined, color: CustomColors.sWhiteColor,)),

                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget buildTransactionList(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Transactions", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700)),

            GestureDetector(
                onTap:(){
                  seeAllTransaction(context);
                },
                child: Text("See all", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400) )),

          ],
        ),
        height16,

        Expanded(child: MiniTransactionHistory(transactionList:eventProvider?.transactionList))
      ],
    );
  }

  void seeAllTransaction(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Color(0xff1A1A21),
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.only(topRight: Radius.circular(25.r), topLeft: Radius.circular(25.r)),),
        context: context,
        builder: (context) {
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
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(width: double.infinity, height: 30.h, decoration: BoxDecoration(color: CustomColors.sDarkColor2,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(25.r), topRight: Radius.circular(25.r))),
                                child: Center(child: SvgPicture.asset("images/indicate.svg")),),

                              height12,
                              Expanded(
                                child: Padding(
                                  padding: horizontalPadding,
                                  child: TransactionHistory(transactionList:eventProvider?.transactionList),
                                ),
                              ),

                            ]);
                      });
                }),
          );
        });
  }

  Widget buildHorizontalContainer(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap:(){
              Navigator.push(context, SlideUpRoute(page: FundWallet()));

            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: CustomColors.sDarkColor2,
                borderRadius: BorderRadius.all(Radius.circular(20.r))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset("images/fund_wallet.svg", width: 40.w, height: 40.h,),
                  height4,
                  Text("Fund Wallet", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700) ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(width: 16.w,),

        Expanded(
          child: GestureDetector(
            onTap:(){
              Navigator.push(context, SlideUpRoute(page: Withdrawal())).then((value){
                Provider.of<EventProvider>(context, listen: false).fetchTransactionListApi();
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                  color: CustomColors.sDarkColor2,
                  borderRadius: BorderRadius.all(Radius.circular(20.r))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset("images/error_withdrawl.svg", width: 40.w, height: 40.h,),
                  height4,
                  Text("Withdraw", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700) ),
                ],
              ),
            ),
          ),
        ),


      ],
    );
  }


}
