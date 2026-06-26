import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/home/fund_wallet.dart';
import 'package:spraay/utils/my_sharedpref.dart';

class WalletCard extends StatefulWidget {
  const WalletCard({super.key});

  @override
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  bool _isObscure = false;

  @override
  Widget build(BuildContext context) {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Wallet Balance", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 10.sp, fontWeight: FontWeight.w700)),
                height16,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _isObscure ? '${MySharedPreference.getWalletBalance().replaceAll(RegExp(r"."), "*")}' : "₦${currrency.format(double.parse(MySharedPreference.getWalletBalance()))}",
                        style: CustomTextStyle.kTxtBold.copyWith(fontSize: 24.sp, fontWeight: FontWeight.bold, fontFamily: "PlusJakartaSans"),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
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
                height18,
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, FadeRoute(page: const FundWallet()));
                  },
                  child: Align(alignment: Alignment.bottomRight, child: SvgPicture.asset("images/top_up.svg")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
