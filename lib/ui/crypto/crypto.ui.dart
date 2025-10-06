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
import 'package:spraay/ui/crypto/asset-details.dart';
import 'package:spraay/ui/crypto/buy/buy.ui.dart';
import 'package:spraay/ui/crypto/crypto.vm.dart';
import 'package:spraay/ui/crypto/receive/receive.ui.dart';
import 'package:spraay/ui/crypto/sell/sell.ui.dart';
import 'package:spraay/ui/crypto/swap/swap.ui.dart';
import 'package:spraay/ui/home/fund_wallet.dart';
import 'package:spraay/ui/home/notification_screen.dart';
import 'package:spraay/ui/profile/user_profile/edit_profile.dart';
import 'package:spraay/utils/after-layout.dart';
import 'package:spraay/utils/my_sharedpref.dart';
import 'package:spraay/view_model/auth_provider.dart';
import 'package:spraay/view_model/event_provider.dart';
import 'package:spraay/view_model/home_provider.dart';

class CryptoPage extends StatefulWidget {
  const CryptoPage({Key? key}) : super(key: key);

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> with AfterLayoutMixin<CryptoPage> {
  bool _isObscure = false;

  CryptoProvider? cryptoProvider;
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    Provider.of<CryptoProvider>(context, listen: false).getUserWallets(context);
  }

  @override
  void didChangeDependencies() {
    cryptoProvider = context.watch<CryptoProvider>();
    credentialsProvider = context.watch<AuthProvider>();
    eventProvider = context.watch<EventProvider>();

    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _isObscure = Provider.of<HomeProvider>(context, listen: false).hideWalletvalue ?? false;

    // Provider.of<EventProvider>(context, listen: false).fetchTransactionListApi();
    // Provider.of<EventProvider>(context, listen: false).fetchNotificationApi();
  }

  AuthProvider? credentialsProvider;

  EventProvider? eventProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context: context, title: "Crypto"),
        body: Padding(
          padding: horizontalPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // shrinkWrap: true,
            children: [
              height20,
              buildWalletContainer(),
              const SizedBox(height: 35),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: CryptoActionsEnum.values
                      .map((e) => GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              switch (e) {
                                case CryptoActionsEnum.buy:
                                  Navigator.push(context, FadeRoute(page: BuyCryptoScreen()));
                                case CryptoActionsEnum.send:
                                  Navigator.push(context, FadeRoute(page: const SellCryptoScreen()));
                                case CryptoActionsEnum.swap:
                                  Navigator.push(context, FadeRoute(page: SwapAssetScreen()));
                                case CryptoActionsEnum.receive:
                                  Navigator.push(context, FadeRoute(page: const ReceiveCryptoScreen()));
                              }
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                    padding: EdgeInsets.all(32.r),
                                    decoration: BoxDecoration(color: e.bgColor!.withOpacity(.25), shape: BoxShape.circle),
                                    child: SvgPicture.asset("images/${e.icon}.svg")),
                                const SizedBox(height: 8),
                                Text(e.name.capitalize(), style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ))
                      .toList()),
              height26,
              Expanded(
                  child: RefreshIndicator(
                      onRefresh: () async {
                        cryptoProvider?.getUserWallets(context);
                      },
                      child: buildAssetsList()))
            ],
          ),
        ));
  }

  Widget buildTopRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
            onTap: () {
              Navigator.push(context, FadeRoute(page: EditProfile(credentialsProvider?.dataResponse)));
            },
            child: buildCircularNetworkImage(imageUrl: credentialsProvider?.dataResponse?.profileImageUrl ?? "", radius: 26.r)),
        SizedBox(
          width: 12.w,
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Hello", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400)),
              Text(" ${credentialsProvider?.dataResponse?.firstName ?? ""}", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        InkWell(
            onTap: () {
              showNotification(context);
            },
            child: SvgPicture.asset("images/note_bell.svg"))
      ],
    );
  }

  Widget buildWalletContainer() {
    // pattern.png
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
            // width: 275.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Wallet Balance", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 10.sp, fontWeight: FontWeight.w700)),
                height16,
                // Text("N200,000.00", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 32.sp, fontWeight: FontWeight.w700) ),
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

  Widget buildAssetsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("My Assets", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700)),
          ],
        ),
        height16,
        Expanded(
            child: (cryptoProvider?.loading ?? false)
                ? const ShimmerList()
                : AssetsList(
                    assetsList: assets,
                    wallets: cryptoProvider?.wallets ?? [],
                  ))
      ],
    );
  }

  void showNotification(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: const Color(0xff1A1A21),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(25.r), topLeft: Radius.circular(25.r)),
        ),
        context: context,
        builder: (context) {
          return NotificationScreen(
            notificationlist: eventProvider?.notificationlist ?? [],
          );
        });
  }

  void seeAllTransaction(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: const Color(0xff1A1A21),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(25.r), topLeft: Radius.circular(25.r)),
        ),
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
              return DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 0.92,
                  minChildSize: 0.92,
                  maxChildSize: 0.92,
                  builder: (BuildContext context, ScrollController scrollController) {
                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                        width: double.infinity,
                        height: 30.h,
                        decoration: BoxDecoration(color: CustomColors.sDarkColor2, borderRadius: BorderRadius.only(topLeft: Radius.circular(25.r), topRight: Radius.circular(25.r))),
                        child: Center(child: SvgPicture.asset("images/indicate.svg")),
                      ),
                      height12,
                      Expanded(
                        child: Padding(
                            padding: horizontalPadding,
                            child: AssetsList(
                              assetsList: assets,
                            )),
                      ),
                    ]);
                  });
            }),
          );
        });
  }
}

enum CryptoActionsEnum {
  buy(title: 'Buy', icon: "c-buy", bgColor: Color(0xff5B45FF)), //opacity 25
  send(title: 'Buy', icon: "c-send", bgColor: Color(0xffF6F6F6)),
  swap(title: 'Buy', icon: "c-swap", bgColor: Color(0xff00BCD4)),
  receive(title: 'Receive', icon: "c-receive", bgColor: Color(0xff4CA450));

  final String? title, icon;
  final Color? bgColor;

  const CryptoActionsEnum({this.title, this.icon, this.bgColor});
}

class MyAssetsList extends StatelessWidget {
  const MyAssetsList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class CAsset {
  final String? name;
  final String? icon;
  final String? sub;
  final String? nairaPrice;
  final String? usdPrice;

  CAsset({this.name, this.icon, this.sub, this.nairaPrice, this.usdPrice});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CAsset && runtimeType == other.runtimeType && name == other.name && icon == other.icon && sub == other.sub && nairaPrice == other.nairaPrice && usdPrice == other.usdPrice;

  @override
  int get hashCode => name.hashCode ^ icon.hashCode ^ sub.hashCode ^ nairaPrice.hashCode ^ usdPrice.hashCode;

  @override
  String toString() {
    return 'CAsset{name: $name, icon: $icon, sub: $sub, nairaPrice: $nairaPrice, usdPrice: $usdPrice}';
  }
}

List<CAsset> assets = [
  CAsset(name: "Tether", icon: 'tether', sub: 'USDT', nairaPrice: '10000', usdPrice: '190'),
  CAsset(name: "Bitcoin", icon: 'btc', sub: 'BTC', nairaPrice: '10000', usdPrice: '190'),
  CAsset(name: "Ethereum", icon: 'eth', sub: 'ETH', nairaPrice: '10000', usdPrice: '190'),
  CAsset(name: "Shiba Inu", icon: 'shib', sub: 'SHIB', nairaPrice: '10000', usdPrice: '190'),
  CAsset(name: "Dogecoin", icon: 'dogecoin', sub: 'DOGE', nairaPrice: '10000', usdPrice: '190'),
  CAsset(name: "Litecoin", icon: 'litecoin', sub: 'ltc', nairaPrice: '10000', usdPrice: '190'),
  CAsset(name: "Solana", icon: 'solana', sub: 'SOL', nairaPrice: '10000', usdPrice: '190'),
];

class AssetsList extends StatelessWidget {
  List<CAsset>? assetsList;
  List<Wallet> wallets;
  AssetsList({super.key, required this.assetsList, this.wallets = const []});

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
                          page: AssetDetails(asset: wallets[position]),
                        ));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text((wallets[position].name ?? ""), style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, fontFamily: "Dm Sans")),
                                height4,
                                Text((wallets[position].currency ?? "").toUpperCase(),
                                    style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor500, fontFamily: "Dm Sans"),
                                    textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "NGN ${wallets[position].balance ?? " "}",
                                style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, fontFamily: "Dm Sans"),
                              ),
                              height4,
                              Text(
                                "\$${wallets[position].convertedBalance!}",
                                style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor500, fontFamily: "Dm Sans"),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                      height16,
                    ],
                  ),
                ),
              );
            }),
      );
    }
  }
}
