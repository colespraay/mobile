import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import 'package:spraay/ui/crypto/widgets/qr-scanner.dart';
import 'package:spraay/utils/after-layout.dart';

// Buy Asset Screen
class SellAssetScreen extends StatefulWidget {
  final Wallet asset;
  SellAssetScreen({required this.asset});

  @override
  _SellAssetScreenState createState() => _SellAssetScreenState();
}

class _SellAssetScreenState extends State<SellAssetScreen> with AfterLayoutMixin<SellAssetScreen> {
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
        // format with commas and exactly 2 decimals
        displayAmount = moneyFormatter.format(value.toStringAsFixed(2) == '0.00' ? 0 : value);
      } else {
        displayAmount = '0.00';
      }
    });
  }

  void _onBackspace() {
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

  double _getUSDTAmount() {
    double nairaAmount = double.parse(displayAmount.replaceAll(',', ''));
    return nairaAmount / 1697.51; // Using the rate from the image
  }

  ValueNotifier<num> pageIndex = ValueNotifier(0);
  TextEditingController addressController = TextEditingController();
  num get amount => num.tryParse(displayAmount.toString().replaceAll(",", "")) ?? 0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: pageIndex,
      builder: (context, page, _) => Builder(builder: (context) {
        switch (page) {
          case 0:
            return Scaffold(
              appBar: buildAppBar(context: context, title: "Sell Asset"),
              backgroundColor: Colors.black,
              body: Column(
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Center(
                    child: AssetHeader(
                      title: widget.asset.name,
                      icon: "${widget.asset.imageUrl}",
                      subTitle: widget.asset.currency,
                      small: true,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Amount Display
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '₦',
                        style: TextStyle(
                          color: CustomColors.sWhiteColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '$displayAmount',
                        style: TextStyle(
                          color: CustomColors.sWhiteColor,
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Text(
                    'approx. ${_getUSDTAmount().toStringAsFixed(2)} USDT',
                    style: const TextStyle(
                      color: CustomColors.semanticFGMuted,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Wallet balance: ₦100,000',
                    style: TextStyle(color: CustomColors.sWhiteColor, fontSize: 14, fontWeight: FontWeight.w700),
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
                  buttonWidget(onDone: () => pageIndex.value = pageIndex.value + 1, isActive: hasValue),
                ],
              ),
            );
          case 1:
            return Scaffold(
              backgroundColor: Colors.black,
              appBar: buildAppBar(context: context, title: "Choose Recipient"),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomizedTextField(
                      textEditingController: addressController,
                      textInputAction: TextInputAction.next,
                      hintTxt: "Search",
                      // focusNode: _textField1Focus,
                      onChanged: (value) {},
                      surffixWidget: GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(context, FadeRoute(page: const QrCodeScanner()));
                          if (result != null) {
                            addressController.text = result.toString();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0, top: 8, bottom: 8),
                          child: SvgPicture.asset(
                            'images/qr-flat.svg',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Spacer(),
                        buttonWidget(
                          onDone: () {
                            // Navigator.push(
                            //     context,
                            //     FadeRoute(
                            //       page: ReviewScreen(
                            //         asset: widget.asset,
                            //         amount: displayAmount,
                            //       ),
                            //     ));
                          },
                        ),
                        SizedBox(
                          height: 32,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          case 2:
            return Scaffold(
              appBar: buildAppBar(context: context, title: "Review"),
              backgroundColor: Colors.black,
              body: Column(
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'You are about to sell',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '₦$amount',
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
                      icon: "${widget.asset.imageUrl}",
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
                            value: '₦$amount USDT',
                          ),
                          DetailRow(
                            label: 'Rate',
                            value: '1 USDT = ₦1,697.51',
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
                            value: '',
                            isTotal: true,
                          ),
                          const Spacer(),
                          buttonWidget(onDone: () {
                            popupSuccessfulDialog(
                                context: context,
                                title: 'Transaction Successful',
                                content: "Your asset purchase was successful",
                                onTap: () => goHome(context),
                                buttonTxt: "Okay",
                                fromWhere: '',
                                amount: amount.toString());
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
      }),
    );
  }
}

// Review Screen
class ReviewScreen extends StatelessWidget {
  final Wallet? asset;
  final String amount;
  ReviewScreen({this.asset, required this.amount});

  double _getUSDTAmount() {
    double nairaAmount = double.parse(amount.replaceAll(',', ''));
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

  double _getTotalNaira() {
    return _getTotalUSDT() * 1697.51;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context: context, title: "Review"),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            'You are about to sell',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '₦${double.parse(amount.replaceAll(',', '')).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: AssetHeader(
              title: asset?.name ?? "",
              icon: "${asset?.imageUrl}",
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
                    value:
                        '₦${double.parse(amount.replaceAll(',', '')).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} = ${_getUSDTAmount().toStringAsFixed(2)} USDT',
                  ),
                  DetailRow(
                    label: 'Rate',
                    value: '1 USDT = ₦1,697.51',
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
                    value: '${_getTotalUSDT().toStringAsFixed(2)} USDT = ₦${_getTotalNaira().toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                    isTotal: true,
                  ),
                  const Spacer(),
                  buttonWidget(onDone: () {
                    popupSuccessfulDialog(
                        context: context,
                        title: 'Transaction Successful',
                        content: "Your asset purchase was successful",
                        onTap: () => goHome(context),
                        buttonTxt: "Okay",
                        fromWhere: '',
                        amount: amount);
                  }),
                  const SizedBox(height: 54),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
