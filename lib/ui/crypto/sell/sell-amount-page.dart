import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/custom-dropdown.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/wallets-response.dart';
import 'package:spraay/ui/crypto/asset-details.dart';
import 'package:spraay/ui/crypto/crypto.vm.dart';
import 'package:spraay/ui/crypto/widgets/asset-header.dart';
import 'package:spraay/ui/crypto/widgets/detail-row.dart';
import 'package:spraay/ui/crypto/widgets/misc.dart';
import 'package:spraay/ui/crypto/widgets/number-pad.dart';
import 'package:spraay/ui/crypto/widgets/receipt.dart';
import 'package:spraay/utils/after-layout.dart';
import 'package:spraay/utils/string-utils.dart';
import 'package:spraay/view_model/bill_payment_provider.dart';

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
    print(displayAmount);
    cryptoProvider?.setDisplayAmount(num.tryParse(displayAmount.replaceAll(",", "").replaceAll(".", "")) ?? 0);
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
    cryptoProvider?.setDisplayAmount(num.tryParse(displayAmount.replaceAll(",", "").replaceAll(".", "")) ?? 0);
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
  String get ticker => "${widget.asset.currency ?? " "}${widget.asset.referenceCurrency ?? " "}";
  String get currency => widget.asset.currency ?? " ";

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayWidget(
      loading: cryptoProvider?.loading ?? false,
      child: ValueListenableBuilder(
        valueListenable: pageIndex,
        builder: (context, page, _) => Builder(builder: (context) {
          switch (page) {
            case 0:
              return Scaffold(
                appBar: buildAppBar(context: context, title: "Send Asset"),
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
                        const Text(
                          '₦',
                          style: TextStyle(
                            color: CustomColors.sWhiteColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '$displayAmount',
                          style: const TextStyle(
                            color: CustomColors.sWhiteColor,
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    Text(
                      'approx. ${conversionAmount(cryptoProvider?.cryptoData?.ticker?.buyAmount ?? 0, num.tryParse(displayAmount.replaceAll(",", "")) ?? 0)} ${widget.asset.currency?.toUpperCase()}',
                      style: const TextStyle(
                        color: CustomColors.semanticFGMuted,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Wallet balance: ${widget.asset.currency?.toUpperCase()} ${widget.asset.numBalance.toStringAsFixed(2)}',
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
                            await Provider.of<CryptoProvider>(context, listen: false).getTransactionFeesUSDValue(context, currency, ticker, isBuy: false, onDone: () {
                              pageIndex.value = pageIndex.value + 1;
                            });
                          }
                        },
                        isActive: hasValue),
                  ],
                ),
              );
            case 1:
              return Scaffold(
                backgroundColor: Colors.black,
                appBar: buildAppBar(context: context, title: "Choose Recipient"),
                body: Column(
                  children: [
                    height16,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Consumer<BillPaymentProvider>(
                        builder: (context, dataProvider, _) {
                          return GenericDropdown<Network>(
                            items: (widget.asset.networks ?? []).where((e) => e.withdrawsEnabled == true).toList(),
                            hintText: "Choose Network",
                            displayText: (item) => "${item.id?.toUpperCase()} - ${item.name ?? " "}",
                            onSelected: (selected) {
                              //   final provider = Provider.of<BillPaymentProvider>(context, listen: false);
                              //   provider.fetchBettingPlanApiList(selected ?? "");
                            },
                          );
                        },
                      ),
                    ),
                    height16,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CustomizedTextField(
                        textEditingController: addressController,
                        textInputAction: TextInputAction.next,
                        hintTxt: "Enter Address",
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.content_paste),
                              label: const Text('Paste'),
                              onPressed: () async {
                                final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                                if (clipboardData?.text != null) {
                                  addressController.text = clipboardData!.text!;
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.qr_code_scanner),
                              label: const Text('Scan'),
                              onPressed: () {
                                showScannerSheet(context, controller: addressController, onDone: () {
                                  pageIndex.value = pageIndex.value + 1;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          buttonWidget(
                            onDone: () async {
                              // var result = await Navigator.push(context, MaterialPageRoute(builder: (_) => QrCodeScanner()));
                              if (addressController.text.isNotEmpty) {
                                pageIndex.value = pageIndex.value + 1;
                              }
                            },
                          ),
                          const SizedBox(
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
                      'You are about to send',
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
                              label: 'Recipient',
                              value: '${addressController.text}',
                            ),
                            DetailRow(
                              label: 'Order Quantity',
                              value:
                                  "${widget.asset.referenceCurrency?.toUpperCase()} $displayAmount = ${conversionAmount(cryptoProvider?.cryptoData?.ticker?.buyAmount ?? 0, num.tryParse(displayAmount.replaceAll(",", "")) ?? 0)} ${widget.asset.currency?.toUpperCase()}",
                            ),
                            DetailRow(
                              label: 'Rate',
                              value: "1 ${widget.asset.currency?.toUpperCase()} = ${widget.asset.referenceCurrency?.toUpperCase()} ${cryptoProvider?.cryptoData?.ticker?.buy}",
                            ),
                            DetailRow(
                              label: 'Network Fee',
                              value:
                                  "${cryptoProvider?.transactionFeesData?.cryptoWithdrawalFee?.feeAndCurrency ?? " "}  = ${(cryptoProvider?.sellNetworkFee)} ${cryptoProvider?.transactionFeesData?.cryptoWithdrawalFee?.currency ?? " "}",
                            ),
                            DetailRow(
                              label: 'Spraay Fee',
                              value: '${cryptoProvider?.transactionFeesData?.spraayFee?.feeAndCurrency} ',
                            ),
                            Container(
                              height: 1,
                              color: Colors.grey[800],
                              margin: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            DetailRow(
                              label: 'Total',
                              value: "${widget.asset.referenceCurrency?.toUpperCase()} ${(cryptoProvider?.allTotal).toString().formatAsAmountWithDecimals()}",
                              // '${widget.asset.referenceCurrency?.toUpperCase()} $displayAmount = ${conversionAmount(cryptoProvider?.cryptoData?.ticker?.buyAmount ?? 0, num.tryParse(displayAmount.replaceAll(",", "")) ?? 0)}${widget.asset.currency?.toUpperCase()} + ${cryptoProvider?.transactionFeesData?.cashWithdrawalFee ?? ""}',
                              isTotal: true,
                            ),
                            const Spacer(),
                            buttonWidget(
                              onDone: () {
                                cryptoProvider?.sellCrypto(context, onDone: (transaction) {
                                  popupSuccessfulDialog(
                                      onViewReceipt: () {
                                        navigate(context: context, page: ReceiptScreen(item: transaction));
                                      },
                                      context: context,
                                      title: 'Transaction Successful',
                                      content: "Your asset sale was successful",
                                      onTap: () => goHome(context),
                                      buttonTxt: "Okay",
                                      fromWhere: widget.asset.currency?.toUpperCase() ?? "",
                                      type: "Crypto Withdrawal",
                                      amount: amount.toString());
                                },
                                    fundId: addressController.text,
                                    amount: conversionAmount(cryptoProvider?.cryptoData?.ticker?.buyAmount ?? 0, num.tryParse(displayAmount.replaceAll(",", "")) ?? 0),
                                    currency: widget.asset.currency);
                              },
                            ),
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
      ),
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
            'You are about to send',
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

void showScannerSheet(BuildContext context, {TextEditingController? controller, Function()? onDone}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.black,
    isScrollControlled: true,
    builder: (context) => SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Stack(
        children: [
          MobileScanner(
            onDetect: (result) {
              final scannedValue = result.barcodes.first.rawValue;
              if (scannedValue != null) {
                Navigator.pop(context); // Close sheet
                controller?.text = scannedValue;
                if (onDone != null) {
                  onDone();
                }
                // pageIndex.value = pageIndex.value + 1;
              }
            },
          ),

          // Close button
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                    const Spacer(),
                    const Text(
                      'Scan QR Code',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
          ),

          // Frame guide
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
