import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/wallets-response.dart';
import 'package:spraay/ui/crypto/widgets/asset-image.dart';

class AssetHeader extends StatelessWidget {
  final String? title;
  final String? icon;
  final String? subTitle;
  final bool small;
  AssetHeader({super.key, this.title, this.icon, this.subTitle, this.small = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: subTitle != null ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        CAssetImage(
          wallet: Wallet(name: title, imageUrl: icon, currency: subTitle),
        ),
        SizedBox(
          width: 16.w,
        ),
        small
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? "",
                    style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, fontFamily: "Dm Sans"),
                  ),
                  if (subTitle != null) height4,
                  if (subTitle != null)
                    Text(
                      (subTitle ?? "").toUpperCase(),
                      style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor500, fontFamily: "Dm Sans"),
                      textAlign: TextAlign.center,
                    ),
                ],
              )
            : Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? "",
                      style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, fontFamily: "Dm Sans"),
                    ),
                    height4,
                    Text(
                      subTitle ?? "",
                      style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor500, fontFamily: "Dm Sans"),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
        if (!small)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "",
                style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, fontFamily: "Dm Sans"),
              ),
              height4,
              Text(
                "",
                style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor500, fontFamily: "Dm Sans"),
                textAlign: TextAlign.center,
              ),
            ],
          ),
      ],
    );
  }
}
