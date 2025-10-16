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

class BuyCryptoScreen extends StatefulWidget {
  const BuyCryptoScreen({super.key});

  @override
  State<BuyCryptoScreen> createState() => _BuyCryptoScreenState();
}

class _BuyCryptoScreenState extends State<BuyCryptoScreen> with AfterLayoutMixin<BuyCryptoScreen> {
  CryptoProvider? cryptoProvider;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    cryptoProvider = context.watch<CryptoProvider>();

    super.didChangeDependencies();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    Provider.of<CryptoProvider>(context, listen: false).getUserWallets(context);
    Provider.of<CryptoProvider>(context, listen: false).getFees(context);
  }

  List<Wallet> _filterAssets(List<Wallet> assets) {
    if (_searchQuery.isEmpty) return assets;
    return assets.where((asset) => asset.name.toString().toLowerCase().contains(_searchQuery) || (asset.currency ?? "").toLowerCase().contains(_searchQuery)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final assetsList = cryptoProvider?.wallets ?? []; // from your global or provider
    final filteredAssets = _filterAssets(assetsList);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppBar(context: context, title: "Buy Asset"),
      body: RefreshIndicator(
        onRefresh: () async {
          await cryptoProvider?.getUserWallets(context);
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomizedTextField(
                textEditingController: _searchController,
                textInputAction: TextInputAction.next,
                hintTxt: "Search",
                onChanged: (value) {
                  setState(() => _searchQuery = value.toLowerCase());
                },
              ),
            ),
            const SizedBox(height: 24),
            (cryptoProvider?.loading ?? false)
                ? const Expanded(child: ShimmerList())
                : Expanded(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: TradeAssetList(
                        assetsList: assets,
                        wallet: filteredAssets, //(cryptoProvider?.wallets ?? []),
                        showAll: true,
                      ),
                    ),
                  )
            // Expanded(
            //   child: SingleChildScrollView(
            //     padding: const EdgeInsets.symmetric(horizontal: 16),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         TradeAssetList(
            //           assetsList: assets,
            //           wallet: cryptoProvider?.wallets ?? [],
            //           showAll: true,
            //         )
            //       ],
            //     ),
            //   ),
            // ),
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
            physics: const NeverScrollableScrollPhysics(), // Important!
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
