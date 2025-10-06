// Transactions Screen
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/wallets-response.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/crypto/buy/buy-amount-page.dart';
import 'package:spraay/ui/crypto/crypto.ui.dart';
import 'package:spraay/ui/crypto/crypto.vm.dart';
import 'package:spraay/ui/crypto/sell/sell-amount-page.dart';
import 'package:spraay/utils/after-layout.dart';

class NewBuyCryptoScreen extends StatefulWidget {
  const NewBuyCryptoScreen({super.key});

  @override
  State<NewBuyCryptoScreen> createState() => _NewBuyCryptoScreenState();
}

class _NewBuyCryptoScreenState extends State<NewBuyCryptoScreen> with AfterLayoutMixin<NewBuyCryptoScreen> {
  CryptoProvider? cryptoProvider;

  @override
  void didChangeDependencies() {
    cryptoProvider = context.watch<CryptoProvider>();

    super.didChangeDependencies();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    Provider.of<CryptoProvider>(context, listen: false).getMarketSummaryWithWatchlist(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppBar(context: context, title: "Buy Asset"),
      body: RefreshIndicator(
        onRefresh: () async {
          await cryptoProvider?.getMarketSummaryWithWatchlist(context);
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomizedTextField(
                textEditingController: TextEditingController(),
                textInputAction: TextInputAction.next,
                hintTxt: "Search",
                // focusNode: _textField1Focus,
                onChanged: (value) {},
              ),
            ),
            const SizedBox(height: 24),
            (cryptoProvider?.loading ?? false)
                ? const Expanded(child: ShimmerList())
                : Expanded(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          if (cryptoProvider?.marketData.isEmpty ?? false)
                            Center(
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
                            )
                          else
                            AnimationLimiter(
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(), // Important!
                                  shrinkWrap: true,
                                  itemCount: cryptoProvider?.marketData.length,
                                  itemBuilder: (context, int position) {
                                    return SlideListAnimationWidget(
                                      position: position,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              FadeRoute(
                                                page: BuyAssetScreen(
                                                  asset: Wallet(),
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
                                                    imageUrl: cryptoProvider?.marketData[position].logo ?? "",
                                                    width: 40.w,
                                                    height: 40.h,
                                                    fit: BoxFit.fill,
                                                    errorWidget: (context, url, error) => Container(
                                                        width: 40.w,
                                                        height: 40.h,
                                                        color: Colors.grey[500],
                                                        child: Center(
                                                          child: Text(
                                                            cryptoProvider?.marketData[position].coinName?[0] ?? "",
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
                                                        cryptoProvider?.marketData[position].coinName ?? "",
                                                        style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, fontFamily: "Dm Sans"),
                                                      ),
                                                      height4,
                                                      Text(
                                                        (cryptoProvider?.marketData![position].baseCoin ?? "").toUpperCase(),
                                                        style: CustomTextStyle.kTxtRegular
                                                            .copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor500, fontFamily: "Dm Sans"),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SvgPicture.asset('images/arrow-right.svg')
                                              ],
                                            ),
                                            height8,
                                            const Divider(color: Color(0xff2F3133))
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            )
                        ],
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

class TradeAssetList extends StatelessWidget {
  List<CAsset>? assetsList;
  List<Wallet>? wallet;
  final bool isBuy;
  bool showAll;
  TradeAssetList({super.key, required this.assetsList, this.isBuy = true, required this.wallet, this.showAll = false});

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
            physics: NeverScrollableScrollPhysics(), // Important!
            shrinkWrap: true,
            itemCount: showAll
                ? wallet?.length
                : (wallet?.length ?? 0) < 5
                    ? wallet?.length
                    : 5,
            itemBuilder: (context, int position) {
              return SlideListAnimationWidget(
                position: position,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        FadeRoute(
                          page: isBuy
                              ? BuyAssetScreen(
                                  asset: wallet![position],
                                )
                              : SellAssetScreen(
                                  asset: wallet![position],
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
                              imageUrl: wallet?[position].imageUrl ?? "",
                              width: 40.w,
                              height: 40.h,
                              fit: BoxFit.fill,
                              errorWidget: (context, url, error) => Container(
                                  width: 40.w,
                                  height: 40.h,
                                  color: Colors.grey[500],
                                  child: Center(
                                    child: Text(
                                      wallet?[position].name?[0] ?? "",
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
                                  wallet?[position].name ?? "",
                                  style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, fontFamily: "Dm Sans"),
                                ),
                                height4,
                                Text(
                                  (wallet![position].currency ?? "").toUpperCase(),
                                  style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor500, fontFamily: "Dm Sans"),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SvgPicture.asset('images/arrow-right.svg')
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
//MIKE2.BLIZE@GMAIL.COM
