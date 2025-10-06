import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/wallets-response.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/crypto/crypto.vm.dart';
import 'package:spraay/ui/crypto/widgets/asset-header.dart';
import 'package:spraay/ui/crypto/widgets/detail-row.dart';
import 'package:spraay/ui/crypto/widgets/misc.dart';
import 'package:spraay/ui/crypto/widgets/number-pad.dart';
import 'package:spraay/utils/after-layout.dart';

// Buy Asset Screen
class NewBuyAssetScreen extends StatefulWidget {
  final MarketData asset;
  NewBuyAssetScreen({required this.asset});

  @override
  _NewBuyAssetScreenState createState() => _NewBuyAssetScreenState();
}

class _NewBuyAssetScreenState extends State<NewBuyAssetScreen> with AfterLayoutMixin<NewBuyAssetScreen> {
  String displayAmount = '0.00';
  String inputBuffer = '';
  bool get hasValue => displayAmount != '0.00';

  @override
  void initState() {
    super.initState();
    // displayAmount = widget.enteredAmount;
  }

  void _onNumberPressed(String number) {
    setState(() {
      if (displayAmount == '0.00') {
        inputBuffer = number;
      } else {
        inputBuffer += number;
      }

      // Format the display amount
      if (inputBuffer.isNotEmpty) {
        double value = double.parse(inputBuffer) / 100;
        displayAmount = moneyFormatter.format(value.toStringAsFixed(2) == '0.00' ? 0 : value);
      } else {
        displayAmount = '0.00';
      }
    });
    // setState(() {
    //   if (displayAmount == '0.00') {
    //     inputBuffer = number;
    //   } else {
    //     inputBuffer += number;
    //   }
    //
    //   // Format the display amount
    //   if (inputBuffer.isNotEmpty) {
    //     double value = double.parse(inputBuffer) / 100;
    //     displayAmount = value.toStringAsFixed(2);
    //   } else {
    //     displayAmount = '0.00';
    //   }
    // });
  }

  void _onBackspace() {
    // setState(() {
    //   if (inputBuffer.isNotEmpty) {
    //     inputBuffer = inputBuffer.substring(0, inputBuffer.length - 1);
    //   }
    //
    //   if (inputBuffer.isNotEmpty) {
    //     double value = double.parse(inputBuffer) / 100;
    //     displayAmount = value.toStringAsFixed(2);
    //   } else {
    //     displayAmount = '0.00';
    //   }
    // });
    setState(() {
      if (inputBuffer.isNotEmpty) {
        inputBuffer = inputBuffer.substring(0, inputBuffer.length - 1);
      }

      if (inputBuffer.isNotEmpty) {
        double value = double.parse(inputBuffer) / 100;
        displayAmount = moneyFormatter.format(value);
      } else {
        displayAmount = '0.00';
      }
    });
  }

  CryptoProvider? cryptoProvider;

  @override
  void didChangeDependencies() {
    cryptoProvider = context.watch<CryptoProvider>();

    super.didChangeDependencies();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    cryptoProvider?.getCurrencyDetails(context, "${widget.asset.currency ?? " "}${widget.asset.referenceCurrency ?? " "}");
  }

  ValueNotifier<num> page = ValueNotifier(0);
  String get quantity =>
      "${widget.asset.referenceCurrency.toUpperCase()}$displayAmount = ${conversionAmount(cryptoProvider?.cryptoData?.ticker?.buyAmount ?? 0, num.tryParse(displayAmount.replaceAll(",", "")) ?? 0)}${widget.asset.currency.toUpperCase()}";
  String get rate => "1 ${widget.asset.currency.toUpperCase()} = ${widget.asset.referenceCurrency.toUpperCase()} ${cryptoProvider?.cryptoData?.ticker?.buy}";
  @override
  Widget build(BuildContext context) {
    return LoadingOverlayWidget(
      loading: (cryptoProvider?.loading ?? false),
      child: ValueListenableBuilder(
          valueListenable: page,
          builder: (context, index, _) => Builder(builder: (context) {
                switch (index) {
                  case 0:
                    return Scaffold(
                      appBar: buildAppBar(context: context, title: "Buy Asset"),
                      backgroundColor: Colors.black,
                      body: Column(
                        children: [
                          const SizedBox(
                            height: 24,
                          ),
                          Center(
                            child: AssetHeader(
                              title: widget.asset.name,
                              icon: widget.asset.imageUrl,
                              subTitle: widget.asset.currency,
                              small: true,
                            ),
                          ),

                          const SizedBox(height: 28),

                          // Amount Display
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: IntrinsicWidth(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    // '₦',
                                    (widget.asset.referenceCurrency ?? "").toUpperCase(),
                                    style: const TextStyle(
                                      color: CustomColors.sWhiteColor,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        displayAmount,
                                        style: const TextStyle(
                                          color: CustomColors.sWhiteColor,
                                          fontSize: 48,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),
                          Text(
                            'approx. ${conversionAmount(cryptoProvider?.cryptoData?.ticker?.buyAmount ?? 0, num.tryParse(displayAmount.replaceAll(",", "")) ?? 0)} ${widget.asset.currency.toUpperCase()}',
                            style: const TextStyle(
                              color: CustomColors.semanticFGMuted,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Wallet balance: ${widget.asset.currency.toUpperCase()} ${widget.asset.numBalance.toStringAsFixed(2)}',
                            style: const TextStyle(color: CustomColors.sWhiteColor, fontSize: 14, fontWeight: FontWeight.w700),
                          ),

                          const SizedBox(height: 24),

                          // Number Pad
                          NumberPad(
                            onNumberPressed: _onNumberPressed,
                            onBackspace: _onBackspace,
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          buttonWidget(
                              onDone: () async {
                                if (cryptoProvider?.cryptoData != null) {
                                  Navigator.push(
                                      context,
                                      FadeRoute(
                                        page: ReviewScreen(
                                          asset: Wallet(), //widget.asset,
                                          amount: displayAmount,
                                          data: {
                                            'amount': displayAmount,
                                            'rate': "1 ${widget.asset.currency.toUpperCase()} = ${widget.asset.referenceCurrency.toUpperCase()} ${cryptoProvider?.cryptoData?.ticker?.buy}",
                                            'quantity':
                                                "${widget.asset.referenceCurrency.toUpperCase()}$displayAmount = ${conversionAmount(cryptoProvider?.cryptoData?.ticker?.buyAmount ?? 0, num.tryParse(displayAmount.replaceAll(",", "")) ?? 0)}${widget.asset.currency.toUpperCase()}"
                                          },
                                        ),
                                      ));
                                }
                              },
                              isActive: hasValue),
                        ],
                      ),
                    );
                  case 1:
                    return Scaffold(
                      appBar: buildAppBar(context: context, title: "Review"),
                      backgroundColor: Colors.black,
                      body: Column(
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            'You are about to buy',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '₦${double.parse(displayAmount.replaceAll(',', '')).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: AssetHeader(
                              title: widget.asset.name ?? "",
                              icon: widget.asset.imageUrl,
                              small: true,
                            ),
                          ),
                          const SizedBox(height: 60),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  DetailRow(
                                    label: 'Order Quantity',
                                    value: quantity,
                                    // '₦${double.parse(amount.replaceAll(',', '')).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} = ${_getUSDTAmount().toStringAsFixed(2)} USDT',
                                  ),
                                  DetailRow(
                                    label: 'Rate',
                                    value: rate, //'1 USDT = ₦1,697.51',
                                  ),
                                  DetailRow(
                                    label: 'Network Fee',
                                    value: '2 USDT = ₦3,400.00',
                                  ),
                                  DetailRow(
                                    label: 'Spraay Fee',
                                    value: '2 USDT = ₦3,400.00',
                                  ),
                                  Container(
                                    height: 1,
                                    color: Colors.grey[800],
                                    margin: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  DetailRow(
                                    label: 'Total',
                                    value: '${widget.asset.referenceCurrency.toUpperCase()} $displayAmount',
                                    isTotal: true,
                                  ),
                                  const Spacer(),
                                  buttonWidget(onDone: () {
                                    cryptoProvider?.buyCrypto(context,
                                        onDone: () => popupSuccessfulDialog(
                                            context: context,
                                            title: 'Transaction Successful',
                                            content: "Your asset purchase was successful",
                                            onTap: () => goHome(context),
                                            buttonTxt: "Okay",
                                            fromWhere: '',
                                            amount: displayAmount),
                                        currency: widget.asset.currency,
                                        amount: convertToNum(displayAmount.toString().replaceAll(",", "")));
                                  }),
                                  const SizedBox(height: 54),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  default:
                    return const SizedBox.shrink();
                }
              })),
    );
  }
}

// Review Screen
class ReviewScreen extends StatefulWidget {
  final Wallet? asset;
  final String amount;
  final Map<String, dynamic> data;

  ReviewScreen({this.asset, required this.amount, required this.data});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  double _getUSDTAmount() {
    double nairaAmount = double.parse(widget.amount.replaceAll(',', ''));
    return nairaAmount / 1697.51;
  }

  double _getNetworkFee() {
    return 2.0; // 2 USDT
  }

  double _getSpraayFee() {
    return 2.0; // 2 USDT
  }

  double _getTotalUSDT() {
    return _getUSDTAmount() + _getNetworkFee() + _getSpraayFee();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayWidget(
      loading: cryptoProvider?.loading ?? false,
      child: Scaffold(
        appBar: buildAppBar(context: context, title: "Review"),
        backgroundColor: Colors.black,
        body: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              'You are about to buy',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '₦${double.parse(widget.amount.replaceAll(',', '')).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: AssetHeader(
                title: widget.asset?.name ?? "",
                icon: widget.asset?.imageUrl,
                small: true,
              ),
            ),
            const SizedBox(height: 60),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    DetailRow(
                      label: 'Order Quantity',
                      value: widget.data['quantity'],
                      // '₦${double.parse(amount.replaceAll(',', '')).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} = ${_getUSDTAmount().toStringAsFixed(2)} USDT',
                    ),
                    DetailRow(
                      label: 'Rate',
                      value: widget.data['rate'], //'1 USDT = ₦1,697.51',
                    ),
                    DetailRow(
                      label: 'Network Fee',
                      value: '2 USDT = ₦3,400.00',
                    ),
                    DetailRow(
                      label: 'Spraay Fee',
                      value: '2 USDT = ₦3,400.00',
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey[800],
                      margin: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    DetailRow(
                      label: 'Total',
                      value: '${widget.asset?.referenceCurrency?.toUpperCase()} ${widget.data['amount']}',
                      isTotal: true,
                    ),
                    const Spacer(),
                    buttonWidget(onDone: () {
                      cryptoProvider?.buyCrypto(context,
                          onDone: () => popupSuccessfulDialog(
                              context: context,
                              title: 'Transaction Successful',
                              content: "Your asset purchase was successful",
                              onTap: () => goHome(context),
                              buttonTxt: "Okay",
                              fromWhere: '',
                              amount: widget.amount),
                          currency: widget.asset?.currency,
                          amount: convertToNum(widget.data['amount'].toString().replaceAll(",", "")));
                    }),
                    const SizedBox(height: 54),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  CryptoProvider? cryptoProvider;

  @override
  void didChangeDependencies() {
    cryptoProvider = context.watch<CryptoProvider>();

    super.didChangeDependencies();
  }
}
