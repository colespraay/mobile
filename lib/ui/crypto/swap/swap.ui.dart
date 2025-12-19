// Transactions Screen
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/wallets-response.dart';
import 'package:spraay/ui/crypto/asset-details.dart';
import 'package:spraay/ui/crypto/crypto.ui.dart';
import 'package:spraay/ui/crypto/crypto.vm.dart';
import 'package:spraay/ui/crypto/widgets/asset-image.dart';
import 'package:spraay/ui/crypto/widgets/countdown-widget.dart';
import 'package:spraay/ui/crypto/widgets/detail-row.dart';
import 'package:spraay/ui/crypto/widgets/misc.dart';
import 'package:spraay/ui/crypto/widgets/receipt.dart';
import 'package:spraay/ui/crypto/widgets/text-shimmer.dart';
import 'package:spraay/utils/after-layout.dart';
import 'package:spraay/utils/debounce.dart';
import 'package:spraay/utils/string-utils.dart';

// Asset Selection Dropdown Component
class AssetDropdown extends StatelessWidget {
  final CAsset selectedAsset;
  final List<CAsset> assets;
  final Function(CAsset) onAssetChanged;

  const AssetDropdown({
    super.key,
    required this.selectedAsset,
    required this.assets,
    required this.onAssetChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selectedAssetData = assets.firstWhere(
      (asset) => asset.name == selectedAsset.name,
      orElse: () => assets[0],
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CAsset>(
          padding: EdgeInsets.zero,
          value: selectedAsset,
          dropdownColor: const Color(0xFF1F2937),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          onChanged: (CAsset? newValue) {
            if (newValue != null) {
              onAssetChanged(newValue);
            }
          },
          items: assets.map<DropdownMenuItem<CAsset>>((CAsset asset) {
            return DropdownMenuItem<CAsset>(
              value: asset,
              child: Row(
                children: [
                  CAssetImage(
                    wallet: Wallet(imageUrl: asset.icon, name: selectedAssetData.name),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    (asset.sub ?? "").toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// Swap Input Field Component
class SwapInputField extends StatelessWidget {
  final String amount;
  final String balance;
  final CAsset selectedAsset;
  final List<CAsset> assets;
  final Function(String) onAmountChanged;
  final Function(CAsset) onAssetChanged;
  final bool isReadOnly;

  SwapInputField({
    required this.amount,
    required this.balance,
    required this.selectedAsset,
    required this.assets,
    required this.onAmountChanged,
    required this.onAssetChanged,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        children: [
          // Balance
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Balance: $balance',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Amount and Asset
          Row(
            children: [
              // Amount Input
              Expanded(
                child: TextField(
                  controller: TextEditingController(text: amount),
                  onChanged: isReadOnly ? null : onAmountChanged,
                  readOnly: isReadOnly,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: '0.0',
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),

              const SizedBox(width: 16),

              // Asset Dropdown
              AssetDropdown(
                selectedAsset: selectedAsset,
                assets: assets,
                onAssetChanged: onAssetChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Swap Asset Screen
class SwapAssetScreen extends StatefulWidget {
  CAsset? asset;
  SwapAssetScreen({super.key, this.asset});
  @override
  _SwapAssetScreenState createState() => _SwapAssetScreenState();
}

class _SwapAssetScreenState extends State<SwapAssetScreen> with AfterLayoutMixin<SwapAssetScreen> {
  String fromAmount = '0.0';
  String toAmount = '0.0';
  CAsset? fromAsset; // = assets[0];
  CAsset? toAsset; // = assets[2];

  void _calculateSwap(String amount) {
    if (amount.isEmpty || amount == '0.0') {
      setState(() {
        fromAmount = amount;
        toAmount = '0.0';
      });
      return;
    }

    double inputAmount = double.tryParse(amount) ?? 0.0;
    double convertedAmount = 0.0;

    // Simple conversion logic (USDT to ETH rate)
    if (fromAsset == 'USDT' && toAsset == 'ETH') {
      convertedAmount = inputAmount / 1732.35; // Approximate ETH price
    } else if (fromAsset == 'ETH' && toAsset == 'USDT') {
      convertedAmount = inputAmount * 1732.35;
    }

    setState(() {
      fromAmount = amount;
      toAmount = convertedAmount.toStringAsFixed(6);
    });
  }

  CryptoProvider? cryptoProvider;

  @override
  void didChangeDependencies() {
    cryptoProvider = context.watch<CryptoProvider>();

    super.didChangeDependencies();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    cryptoProvider?.resetSwapData();
    await Provider.of<CryptoProvider>(context, listen: false).getMarketSummaryWithWatchlist(context);
    await Provider.of<CryptoProvider>(context, listen: false).getUserWallets(context);
    await Provider.of<CryptoProvider>(context, listen: false).getFees(context);
    if (cryptoProvider?.wallets.length != 0) {
      var item = cryptoProvider?.wallets[0];
      var item1 = cryptoProvider?.wallets[1];
      fromAsset = widget.asset ?? CAsset(name: item?.name, nairaPrice: item?.balance, icon: item?.imageUrl, sub: item?.currency);
      if (widget.asset != null && widget.asset?.sub == item1?.currency) {
        toAsset = CAsset(name: item?.name, nairaPrice: item?.balance, icon: item?.imageUrl, sub: item?.currency);
      } else {
        toAsset = CAsset(name: item1?.name, nairaPrice: item1?.balance, icon: item1?.imageUrl, sub: item1?.currency);
      }
    }

    setState(() {});
  }

  setToAsset(CAsset v) {
    setState(() {
      toAsset = v;
      cryptoProvider?.resetSwapData();
    });
    if (numAmount > 0 && fromAsset != null && toAsset != null) {
      cryptoProvider?.getSwapQuotation(context, amount: numAmount.toString(), from: fromAsset?.sub, to: toAsset?.sub);
    }
  }

  setFromAsset(CAsset v) {
    setState(() {
      fromAsset = v;
      cryptoProvider?.resetSwapData();
    });
    if (numAmount > 0 && fromAsset != null && toAsset != null) {
      cryptoProvider?.getSwapQuotation(context, amount: numAmount.toString(), from: fromAsset?.sub, to: toAsset?.sub);
    }
  }

  num get numAmount => num.tryParse(fromAmount) ?? 0;

  final IDebouncer _debouncer = IDebouncer(duration: const Duration(milliseconds: 1500));

  ValueNotifier<num> page = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (pop, result) {
        if (pop) return;
        if (page.value != 0) {
          page.value = page.value - 1;
        } else {
          Navigator.pop(context);
        }
      },
      child: LoadingOverlayWidget(
        loading: cryptoProvider?.loading ?? false,
        child: ValueListenableBuilder(
            valueListenable: page,
            builder: (context, index, _) => Builder(builder: (context) {
                  switch (index) {
                    case 0:
                      return Scaffold(
                        appBar: buildAppBar(
                            context: context,
                            title: "Swap Asset",
                            onBackAction: () {
                              if (page.value != 1) {
                                page.value = page.value - 1;
                              } else {
                                Navigator.pop(context);
                              }
                            }),
                        backgroundColor: Colors.black,
                        body: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              const SizedBox(height: 72),
                              Stack(
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: CustomColors.lightCardBg,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const Text(
                                                      'Balance: ',
                                                      style: TextStyle(
                                                        color: CustomColors.semanticFGMuted,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${(fromAsset?.sub ?? "").toUpperCase()} ${(fromAsset?.nairaPrice ?? "")}',
                                                      style: const TextStyle(
                                                        color: CustomColors.sWhiteColor,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: TextField(
                                                    style: const TextStyle(
                                                      color: CustomColors.semanticFGMuted,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                    decoration: const InputDecoration(
                                                      hintText: "0.0",
                                                      border: InputBorder.none,
                                                      isDense: true,
                                                      contentPadding: EdgeInsets.zero,
                                                    ),
                                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                                                    ],
                                                    onChanged: (v) {
                                                      _debouncer.run(action: () {
                                                        fromAmount = v;
                                                        cryptoProvider?.getSwapQuotation(context, to: toAsset?.sub, from: fromAsset?.sub, amount: v);
                                                      });
                                                    },
                                                  ),
                                                ),
                                                if (fromAsset != null)
                                                  AssetDropdown(
                                                    key: const Key('from'),
                                                    selectedAsset: fromAsset ?? CAsset(),
                                                    assets: cryptoProvider?.fromWallets ?? [],
                                                    onAssetChanged: setFromAsset,
                                                  ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 24.h,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: CustomColors.lightCardBg,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const Text(
                                                      'Balance: ',
                                                      style: TextStyle(
                                                        color: CustomColors.semanticFGMuted,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${(toAsset?.sub ?? "").toUpperCase()} ${(toAsset?.nairaPrice ?? "")}',
                                                      style: const TextStyle(
                                                        color: CustomColors.sWhiteColor,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: (cryptoProvider?.isFetchingSwap ?? false)
                                                      ? const TextShimmer(
                                                          // text: '0.00000',
                                                          baseColor: CustomColors.sPrimaryColor500,
                                                          highlightColor: Colors.grey,
                                                        )
                                                      : Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: FittedBox(
                                                            fit: BoxFit.scaleDown,
                                                            child: Text(
                                                              cryptoProvider?.swapQuotationData?.toAmountNotNullable ?? "0.00",
                                                              // formatMoney(cryptoProvider?.swapQuotationData?.toAmountNotNullable, currencySymbol: cryptoProvider?.swapQuotationData?.toCurrency ?? ""),
                                                              style: const TextStyle(
                                                                color: CustomColors.semanticFGMuted,
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w700,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                                Expanded(
                                                    flex: 2,
                                                    child: (toAsset != null)
                                                        ? AssetDropdown(
                                                            key: const Key('toWallet'),
                                                            selectedAsset: toAsset ?? CAsset(),
                                                            assets: cryptoProvider?.fromWallets ?? [],
                                                            onAssetChanged: setToAsset,
                                                          )
                                                        : const SizedBox.shrink())
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    left: 50.w,
                                    right: 50.w,
                                    top: 85.h,
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(decoration: const BoxDecoration(shape: BoxShape.circle), child: SvgPicture.asset('images/swap.svg')),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                decoration: BoxDecoration(
                                  color: CustomColors.lightCardBg,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Network fee',
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      cryptoProvider?.transactionFeesData?.cryptoSwapFee?.feeAndCurrency ?? "",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 32,
                              ),
                              buttonWidget(onDone: () {
                                if (!(cryptoProvider?.swapQuotationData?.isExpired ?? false)) {
                                  page.value = page.value + 1;
                                } else if (cryptoProvider?.swapQuotationData?.isExpired ?? false) {
                                  cryptoProvider?.getSwapQuotation(context, to: toAsset?.sub, from: fromAsset?.sub, amount: numAmount.toString());
                                } else {
                                  cherryToastInfo(context, "Error", "Please complete all fields");
                                }
                              })
                            ],
                          ),
                        ),
                      );

                    case 1:
                      return LoadingOverlayWidget(
                        loading: (cryptoProvider?.loading ?? false),
                        child: Scaffold(
                          appBar: buildAppBar(
                              context: context,
                              title: "Order Summary",
                              onBackAction: () {
                                if (page.value != 0) {
                                  page.value = page.value - 1;
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                              action: [
                                if (cryptoProvider?.swapQuotationData?.isExpired ?? false)
                                  TextButton(
                                      onPressed: () async => await cryptoProvider?.getSwapQuotation(context, from: fromAsset?.sub, to: toAsset?.sub, amount: fromAmount),
                                      child: Text(
                                        "Refresh",
                                        style: TextStyle(color: Colors.white),
                                      ))
                              ]),
                          backgroundColor: Colors.black,
                          body: Column(
                            children: [
                              const SizedBox(height: 40),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // From Asset
                                      Row(
                                        children: [
                                          CAssetImage(
                                            wallet: Wallet(imageUrl: fromAsset?.icon, name: fromAsset?.name),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            "${fromAsset?.name} ${formatMoney(fromAmount) ?? " "}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 24),

                                      // Swap Icon
                                      SvgPicture.asset('images/swap-vert.svg'),

                                      const SizedBox(height: 24),

                                      // To Asset
                                      Row(
                                        children: [
                                          CAssetImage(
                                            wallet: Wallet(imageUrl: toAsset?.icon, name: toAsset?.name),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            "${cryptoProvider?.swapQuotationData?.toCurrency ?? ""} ${cryptoProvider?.swapQuotationData?.toAmountNotNullable ?? ""}",

                                            // "${toAsset?.name} ${formatMoney(numAmount) ?? " "}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 60),

                                      DetailRow(
                                        label: 'From',
                                        value: '${fromAsset?.sub?.toUpperCase()} ${fromAmount}',
                                      ),
                                      DetailRow(
                                        label: 'To',
                                        value: "${cryptoProvider?.swapQuotationData?.toCurrency ?? ""} ${cryptoProvider?.swapQuotationData?.toAmountNotNullable ?? ""}",
                                      ),
                                      DetailRow(label: 'Exchange Rate', value: cryptoProvider?.swapQuotationData?.exchangeRateText ?? ""),
                                      //
                                      DetailRow(
                                        label: 'Network Fee',
                                        value: cryptoProvider?.transactionFeesData?.cryptoSwapFee?.feeAndCurrency ?? "",
                                      ),
                                      DetailRow(
                                        label: 'Spraay Fee ',
                                        value: '${cryptoProvider?.transactionFeesData?.spraayFee?.feeAndCurrency}',
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      if (!(cryptoProvider?.swapQuotationData?.isExpired ?? false))
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Expires in ",
                                              style: TextStyle(
                                                color: Colors.grey[400],
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 16,
                                            ),
                                            CountdownTimer(
                                              duration: cryptoProvider!.swapQuotationData!.timeRemaining!,
                                              onComplete: () async {
                                                if (!(cryptoProvider?.loading ?? false)) {
                                                  await cryptoProvider?.getSwapQuotation(context, from: fromAsset?.sub, to: toAsset?.sub, amount: fromAmount);
                                                }
                                                // Your action here
                                              },
                                              textColor: Colors.white,
                                            ),
                                          ],
                                        ),
                                      const Spacer(),

                                      (cryptoProvider?.isFetchingSwap ?? false)
                                          ? const Center(child: CircularProgressIndicator())
                                          : buttonWidget(
                                              onDone: (cryptoProvider?.swapQuotationData?.isExpired ?? false)
                                                  ? () {}
                                                  : () {
                                                      cryptoProvider?.confirmQuote(context, onDone: (v) {
                                                        popupSuccessfulDialog(
                                                            onViewReceipt: () {
                                                              navigate(context: context, page: ReceiptScreen(item: v));
                                                            },
                                                            context: context,
                                                            title: 'Transaction Successful',
                                                            content: "Your asset swap was successful",
                                                            onTap: () => goHome(context),
                                                            buttonTxt: "Okay",
                                                            fromWhere: '',
                                                            amount: numAmount.toString());
                                                      }, currency: widget.asset?.sub, amount: numAmount.toString(), from: fromAsset?.sub, to: toAsset?.sub);
                                                    },
                                              isActive: !(cryptoProvider?.isFetchingSwap ?? false)),

                                      const SizedBox(height: 32),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );

                    default:
                      return const SizedBox.shrink();
                  }
                })),
      ),
    );
  }
}

// Order Summary Screen
class OrderSummaryScreen extends StatelessWidget {
  final CAsset? asset1;
  final CAsset? asset2;
  final String fromAmount;
  final String toAmount;
  Function() onDone;
  bool isLoading;
  OrderSummaryScreen({required this.asset1, required this.asset2, required this.fromAmount, required this.toAmount, required this.onDone, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context: context, title: "Order Summary"),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 60),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // From Asset
                  Row(
                    children: [
                      CAssetImage(
                        wallet: Wallet(imageUrl: asset1?.icon, name: asset1?.name),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "${asset1?.name} ${formatMoney(fromAmount) ?? " "}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Swap Icon
                  SvgPicture.asset('images/swap-vert.svg'),

                  const SizedBox(height: 24),

                  // To Asset
                  Row(
                    children: [
                      CAssetImage(
                        wallet: Wallet(imageUrl: asset2?.icon, name: asset2?.name),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "${asset2?.name} ${formatMoney(toAmount) ?? " "}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),

                  // Network Fee
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Network Fee',
                        style: TextStyle(color: Colors.grey[400], fontSize: 16),
                      ),
                      const Text(
                        '2 USDT = ₦3,400.00',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  // const Spacer(),

                  buttonWidget(onDone: onDone),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

var result = '''
{"success":true,"code":200,"message":"Successfully swap Quotation",
"data":{"id":"5ab0b867-7c2f-4037-a060-cc02a83945b5","from_currency":"USDT",
"to_currency":"BTC","quoted_price":"0.0000106855080383",
"quoted_currency":"BTC","from_amount":"2.0","to_amount":"0.00002137",
"confirmed":false,"expires_at":"2025-11-18T14:52:01.000Z",
"created_at":"2025-11-18T14:51:46.000Z","updated_at":"2025-11-18T14:51:46.000Z",
"user":{"id":"7cc10ba7-b3bd-4e03-844b-530d80250373","sn":"QDXZNSNHY6D",
"email":"fametrain.tv@gmail.com","reference":null,"first_name":"GODSWILL",
"last_name":"CHIORI","display_name":null,"created_at":"2025-10-27T21:21:59.000Z",
"updated_at":"2025-10-27T21:21:59.000Z"}}}
''';
