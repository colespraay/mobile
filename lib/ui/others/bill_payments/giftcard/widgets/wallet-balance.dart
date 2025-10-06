import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/utils/my_sharedpref.dart';

class WalletBalance extends StatefulWidget {
  WalletBalance({super.key});

  @override
  State<WalletBalance> createState() => _WalletBalanceState();
}

class _WalletBalanceState extends State<WalletBalance> {
  bool _isObscure = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20.r)),
      child: Container(
        width: double.infinity,
        height: 120.h,
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
                Text("Wallet Balance", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 10.sp, fontWeight: FontWeight.w700)),
                height22,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(_isObscure ? '${MySharedPreference.getWalletBalance().replaceAll(RegExp(r"."), "*")}' : "₦${currrency.format(double.parse(MySharedPreference.getWalletBalance()))}",
                          style: CustomTextStyle.kTxtBold.copyWith(fontSize: 24.sp, fontWeight: FontWeight.bold, fontFamily: "PlusJakartaSans")),
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        child: Icon(
                          _isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: CustomColors.sWhiteColor,
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
