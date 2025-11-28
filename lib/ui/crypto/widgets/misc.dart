import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/dashboard/dashboard_screen.dart';
import 'package:spraay/ui/others/payment_receipt.dart';
import 'package:spraay/view_model/auth_provider.dart';

Widget buttonWidget({required Function() onDone, bool isActive = true, String title = 'Continue'}) {
  return CustomButton(
      onTap: () => isActive ? onDone() : null, buttonText: title, borderRadius: 30.r, width: 380.w, buttonColor: isActive ? CustomColors.sPrimaryColor500 : CustomColors.sDisableButtonColor);
}

popupSuccessfulDialog(
    {required BuildContext context,
    required String title,
    required String content,
    required String buttonTxt,
    required void Function() onTap,
    required String fromWhere,
    String? transactionId,
    String? amount,
    String? type,
    String? dateCreated,
    String? reference,
    Function()? onViewReceipt}) {
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;

  if (dateCreated == null) {
    dateCreated = DateTime.now().toIso8601String();
  }
  return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return Dialog(
            backgroundColor: CustomColors.sDarkColor2,
            insetPadding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.r),
            ),
            child: Container(
              width: 340.w,
              decoration: BoxDecoration(
                color: CustomColors.sDarkColor2,
                borderRadius: BorderRadius.circular(40.r),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 20.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    height40,
                    Image.asset("images/verified.png", width: 140.w, height: 140.h),
                    height30,
                    Text(
                      title,
                      style: CustomTextStyle.kTxtBold.copyWith(fontSize: 24.sp, fontWeight: FontWeight.w700, color: CustomColors.sPrimaryColor400),
                    ),
                    height16,
                    SizedBox(
                        width: 276.w,
                        child: Text(
                          content,
                          style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: CustomColors.sWhiteColor),
                          textAlign: TextAlign.center,
                        )),
                    height30,
                    CustomButton(onTap: onTap, buttonText: buttonTxt, borderRadius: 30.r, buttonColor: CustomColors.sPrimaryColor500),
                    height22,
                    CustomButton(
                        onTap: () {
                          if (onViewReceipt != null) {
                            onViewReceipt();
                          } else {
                            if (fromWhere == "new_bank_screen") {
                              Navigator.pushReplacement(
                                  context,
                                  FadeRoute(
                                      page: PaymentReceipt(
                                    svg_img: 'spray_anim',
                                    type: type ?? "",
                                    date: dateCreated ?? "",
                                    amount: amount ?? "",
                                    meterNumber: '',
                                    transactionRef: reference ?? "",
                                    transStatus: 'Successful',
                                    transactionId: transactionId ?? "",
                                  )));
                            } else {
                              Navigator.pushReplacement(
                                  context,
                                  FadeRoute(
                                      page: PaymentReceipt(
                                    svg_img: 'spray_anim',
                                    type: type ?? "",
                                    date: dateCreated ?? "",
                                    amount: amount ?? "",
                                    meterNumber: '',
                                    transactionRef: reference ?? "",
                                    transStatus: 'Successful',
                                    transactionId: transactionId ?? "",
                                  )));
                            }
                          }
                        },
                        buttonText: "View Receipt",
                        borderRadius: 30.r,
                        buttonColor: CustomColors.sDarkColor3),
                  ],
                ),
              ),
            ),
          );
        });
      });
}

goHome(BuildContext context) {
  Navigator.pushAndRemoveUntil(context, FadeRoute(page: const DasboardScreen()), (Route<dynamic> route) => false);
  Provider.of<AuthProvider>(context, listen: false).onItemTap(0);
}
