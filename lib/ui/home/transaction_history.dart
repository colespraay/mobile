import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/transaction_models.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/home/transaction_detail.dart';

class TransactionHistory extends StatelessWidget {
   List<DatumTransactionModel>? transactionList;
   TransactionHistory({required this.transactionList});


  @override
  Widget build(BuildContext context) {


    if(transactionList!.isEmpty)
    {
      return Center(child:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("No Transactions has been made.", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor50),),
          height4,
          Text("Make one!", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: CustomColors.sPrimaryColor500),),
        ],
      ),);
    }

    else{
      return AnimationLimiter(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: transactionList!.length,
            itemBuilder:(context, int position){
              return SlideListAnimationWidget(
                position: position,
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, FadeRoute(page: TransactionDetail(transactionList?[position])));

                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.h,
                            decoration: BoxDecoration(color: Colors.grey, shape: BoxShape.circle,
                              // image: DecorationImage(image: AssetImage("images/aa.png"), fit: BoxFit.fill,)
                            ),
                          ),

                          SizedBox(width: 10.w,),

                          Expanded(
                            child: SizedBox(
                              width: 175.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(transactionList?[position].narration??"", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400),),
                                  height4,
                                  Text("${DateFormat.MMMd().format(transactionList![position].dateCreated!)}, ${DateFormat.jm().format(transactionList![position].dateCreated!)}",
                                    style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor500),textAlign: TextAlign.center,),
                                ],
                              ),
                            ),
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("${transactionList?[position].type=="Debit"?"-":"+"} ₦${transactionList?[position].amount??0}", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700,
                                  color:transactionList?[position].type=="Debit"? CustomColors.sErrorColor: CustomColors.sSuccessColor, fontFamily: "PlusJakartaSans")),

                              Text("${DateFormat.jm().format(transactionList![position].dateCreated!)}",
                                style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor500),textAlign: TextAlign.center,),

                            ],
                          ),
                        ],
                      ),
                      height10,
                    ],
                  ),
                ),
              );
            }),
      );
    }
  }
}
