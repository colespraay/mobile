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

class MiniTransactionHistory extends StatelessWidget {
  // const MiniTransactionHistory({Key? key}) : super(key: key);

  List<DatumTransactionModel>? assetsList;
  MiniTransactionHistory({super.key, required this.assetsList});

  @override
  Widget build(BuildContext context) {
    if (assetsList!.isEmpty) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "You currently have no Assets",
              style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor50),
            ),
            height4,
            Text(
              "Buy or Sell to create one",
              style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: CustomColors.sPrimaryColor500),
            ),
          ],
        ),
      );
    } else {
      return AnimationLimiter(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: assetsList!.length < 5 ? assetsList!.length : 5,
            itemBuilder: (context, int position) {
              return SlideListAnimationWidget(
                position: position,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, FadeRoute(page: TransactionDetail(assetsList?[position])));
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
                            decoration: const BoxDecoration(
                                color: CustomColors.sDarkColor3,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage("images/cash_png.png"),
                                  fit: BoxFit.fill,
                                )),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            child: SizedBox(
                              width: 175.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    assetsList?[position].narration ?? "",
                                    style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, fontFamily: "LightPlusJakartaSans"),
                                  ),
                                  height4,
                                  Text(
                                    "${DateFormat.MMMd().format(assetsList![position].dateCreated!)}, ${DateFormat.jm().format(assetsList![position].dateCreated!)}",
                                    style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor500),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 110.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${assetsList?[position].type == "Debit" ? "-" : "+"} ₦${assetsList?[position].amount ?? 0}",
                                  style: CustomTextStyle.kTxtBold.copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: assetsList?[position].type == "Debit" ? CustomColors.sErrorColor : CustomColors.sSuccessColor,
                                    fontFamily: "PlusJakartaSans",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 1,
                                ),
                                Text(
                                  "${DateFormat.jm().format(assetsList![position].dateCreated!)}",
                                  style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor500),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
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
