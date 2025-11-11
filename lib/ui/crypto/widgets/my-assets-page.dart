// Transactions Screen
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/wallets-response.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/crypto/asset-details.dart';
import 'package:spraay/ui/crypto/crypto.vm.dart';
import 'package:spraay/utils/after-layout.dart';

class MyAssetsScreen extends StatefulWidget {
  const MyAssetsScreen({super.key});

  @override
  State<MyAssetsScreen> createState() => _MyAssetsScreenState();
}

class _MyAssetsScreenState extends State<MyAssetsScreen> with AfterLayoutMixin<MyAssetsScreen> {
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
  }

  List<Wallet> _filterAssets(List<Wallet> assets) {
    if (_searchQuery.isEmpty) return assets;
    return assets.where((asset) => asset.name.toString().toLowerCase().contains(_searchQuery) || (asset.currency ?? "").toLowerCase().contains(_searchQuery)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final assetsList = cryptoProvider?.wallets ?? [];
    final filteredAssets = _filterAssets(assetsList);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppBar(context: context, title: "My Asset"),
      body: (cryptoProvider?.loading ?? false)
          ? const ShimmerList()
          : RefreshIndicator(
              onRefresh: () async {
                await cryptoProvider?.getUserWallets(context);
              },
              child: CustomScrollView(
                // ✅ Use CustomScrollView for better scroll handling
                physics: const AlwaysScrollableScrollPhysics(), // ✅ Enable scrolling
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CustomizedTextField(
                        textEditingController: _searchController,
                        textInputAction: TextInputAction.next,
                        hintTxt: "Search",
                        onChanged: (value) {
                          setState(() => _searchQuery = value.toLowerCase());
                        },
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 8)),

                  // ✅ Assets list as sliver
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    sliver: filteredAssets.isEmpty
                        ? SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "You currently have no Assets",
                                    style: CustomTextStyle.kTxtSemiBold.copyWith(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                      color: CustomColors.sGreyScaleColor50,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Buy or Sell to create one",
                                    style: CustomTextStyle.kTxtSemiBold.copyWith(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                      color: CustomColors.sPrimaryColor500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, position) {
                                return SlideListAnimationWidget(
                                  position: position,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        FadeRoute(
                                          page: AssetDetails(asset: filteredAssets[position]),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ClipOval(
                                              child: CachedNetworkImage(
                                                imageUrl: filteredAssets[position].imageUrl ?? "",
                                                width: 40.w,
                                                height: 40.h,
                                                fit: BoxFit.fill,
                                                errorWidget: (context, url, error) => Container(
                                                  width: 40.w,
                                                  height: 40.h,
                                                  color: Colors.grey[500],
                                                  child: Center(
                                                    child: Text(
                                                      filteredAssets[position].name?[0] ?? "",
                                                      style: const TextStyle(color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 16.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    filteredAssets[position].name ?? "",
                                                    style: CustomTextStyle.kTxtRegular.copyWith(
                                                      fontSize: 16.sp,
                                                      fontWeight: FontWeight.w400,
                                                      fontFamily: "Dm Sans",
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    (filteredAssets[position].currency ?? "").toUpperCase(),
                                                    style: CustomTextStyle.kTxtRegular.copyWith(
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.w400,
                                                      color: CustomColors.sGreyScaleColor500,
                                                      fontFamily: "Dm Sans",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "NGN ${filteredAssets[position].balance ?? " "}",
                                                  style: CustomTextStyle.kTxtRegular.copyWith(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "Dm Sans",
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  "\$${filteredAssets[position].convertedBalance!}",
                                                  style: CustomTextStyle.kTxtRegular.copyWith(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: CustomColors.sGreyScaleColor500,
                                                    fontFamily: "Dm Sans",
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              childCount: filteredAssets.length,
                            ),
                          ),
                  ),

                  // ✅ Bottom padding
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            ),
    );
  }
}
