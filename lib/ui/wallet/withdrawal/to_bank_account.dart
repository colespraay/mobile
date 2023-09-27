import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/ui/wallet/withdrawal/select_bank.dart';
import 'package:spraay/ui/wallet/withdrawal/withdrawal_pin.dart';
import 'package:spraay/view_model/transaction_provider.dart';

class ToBankAccount extends StatefulWidget {
  String amount;
   ToBankAccount({required this.amount, Key? key}) : super(key: key);

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

              buildContainer(),

              height18,


              buttonContainer(onTap: (){

                  Navigator.push(context, SlideLeftRoute(page: SelectBankScreen(amount: widget.amount,)));

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
    if(_transactionProvider?.savedBankList==null){
      return SpinKitFadingCircle(size: 25.r,color: Colors.grey,);
    }
   else if(_transactionProvider!.savedBankList!.isEmpty){
      return  Text("", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400));
    }
    else{
     return  Expanded(
       child: ListView.builder(
           itemCount:_transactionProvider?.savedBankList?.length ,
           itemBuilder: (context, int position){
             return GestureDetector(
               onTap: (){
                 Navigator.push(context, SlideLeftRoute(page: WithdrawalOtp(fromWhere: 'to_bank_screen', bankCode:_transactionProvider?.savedBankList?[position].bankCode??"" ,
                   bankName: _transactionProvider?.savedBankList?[position].bankName??"", amount: widget.amount,
                   accountNumber: _transactionProvider?.savedBankList?[position].accountNumber??"",
                   accountName: _transactionProvider?.savedBankList?[position].accountName??"",)));
               },
               child: Container(
                 padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                 margin: EdgeInsets.only(bottom: 8.h),
                 decoration: BoxDecoration(color: CustomColors.sDarkColor2, borderRadius: BorderRadius.all(Radius.circular(16.r))),
                 child: Row(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     Container(width: 40.w, height: 40.h,
                         decoration: BoxDecoration(color: CustomColors.sTransparentPurplecolor, shape: BoxShape.circle),
                         child: Center(child: Text(getInitials(_transactionProvider?.savedBankList?[position].bankName??""), style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400)))),
                     SizedBox(width: 16.w,),
                     Expanded(child: Text(_transactionProvider?.savedBankList?[position].bankName??"", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400))),

                     SvgPicture.asset("images/arrow_left.svg")

                   ],
                 ),
               ),
             );

           }),
     );
    }

  }

  @override
  void initState() {
    super.initState();
    Provider.of<TransactionProvider>(context, listen: false).fetchSavedBanksInfoApi();
  }

  TransactionProvider? _transactionProvider;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _transactionProvider=context.watch<TransactionProvider>();
  }
}
