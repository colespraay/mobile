// Transactions Screen
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/wallets-response.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/crypto/crypto.vm.dart';
import 'package:spraay/ui/crypto/receive/receiver-details.dart';

class ReceiveAssetList extends StatelessWidget {
  List<Wallet>? assetsList;
  final bool isBuy;
  ReceiveAssetList({super.key, required this.assetsList, this.isBuy = true});

  List<Wallet> get wallets => (assetsList ?? []).where((e) => e.depositAddress != null).toList();
  @override
  Widget build(BuildContext context) {
    if (wallets.isEmpty) {
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
            itemCount: wallets.length < 5 ? wallets.length : 5,
            itemBuilder: (context, int position) {
              return SlideListAnimationWidget(
                position: position,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        FadeRoute(
                          page: ReceiverDetails(
                            cAsset: wallets[position],
                          ),
                        ));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: wallets[position].imageUrl ?? "",
                              width: 40.w,
                              height: 40.h,
                              fit: BoxFit.fill,
                              errorWidget: (context, url, error) => Container(
                                  width: 40.w,
                                  height: 40.h,
                                  color: Colors.grey[500],
                                  child: Center(
                                    child: Text(
                                      wallets[position].name?[0] ?? "",
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  wallets[position].name ?? "",
                                  style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, fontFamily: "Dm Sans"),
                                ),
                                height4,
                                Text(
                                  obscureString(input: wallets[position].depositAddress ?? "", firstDigits: 6, lastDigits: 4),
                                  style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor500, fontFamily: "Dm Sans"),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(12.r),
                                  decoration: BoxDecoration(color: CustomColors.cardBg, shape: BoxShape.circle),
                                  child: SvgPicture.asset(
                                    'images/qr-flat.svg',
                                    color: CustomColors.sWhiteColor,
                                  )),
                              SizedBox(
                                width: 16.w,
                              ),
                              // GestureDetector(
                              //     onTap: () async {
                              //       await copyToClipboardWithFeedback(wallets[position].depositAddress ?? "", successMessage: "Address Copied to Clipboard");
                              //     },
                              //     child: Container(
                              //         padding: EdgeInsets.all(12.r), decoration: BoxDecoration(color: CustomColors.cardBg, shape: BoxShape.circle), child: SvgPicture.asset('images/copy-flat.svg'))),
                            ],
                          )
                        ],
                      ),
                      height8,
                      const Divider(color: Color(0xff2F3133))
                    ],
                  ),
                ),
              );
            }),
      );
    }
  }
}
