// Receipt Screen
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/file_storage.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/crypto-history.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/ui/crypto/asset-details.dart';
import 'package:spraay/ui/crypto/crypto.ui.dart';
import 'package:spraay/ui/profile/help_and_support.dart';
import 'package:spraay/utils/logger.dart';
import 'package:spraay/view_model/transaction_provider.dart';

class ReceiptScreen extends StatefulWidget {
  final Function(int)? onNavigate;
  final GeneralTransaction? item;

  ReceiptScreen({this.onNavigate, this.item});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  ScreenshotController screenshotController = ScreenshotController();
  TransactionProvider? _transactionProvider;

  @override
  void initState() {
    super.initState();
    FileStorage.getExternalDocumentPath();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _transactionProvider = context.watch<TransactionProvider>();
  }

  GeneralTransaction get data => widget.item ?? GeneralTransaction(id: "", transactionType: TransactionType.deposit);
  Map<String, dynamic> get view => data.view ?? {};
  @override
  Widget build(BuildContext context) {
    printWrapped(data.view.toString());
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (pop, result) {
        if (pop) return;
        navigate(context: context, page: const CryptoPage(), isPushReplacement: true);
      },
      child: LoadingOverlayWidget(
        loading: _transactionProvider?.loading ?? false,
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: buildAppBar(context: context, title: "Receipt"),
          body: Column(
            children: [
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // Amount Section
                      Text("${(widget.item?.amount).toPlainNumber().shortenNumber() ?? " "}", style: TextStyle(color: Colors.grey[400], fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('${(widget.item?.amount).toPlainNumber().shortenNumber()} ${widget.item?.currency.toString().toUpperCase()}',
                          style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),

                      buildContainer(),
                      const SizedBox(height: 24),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () async {
                              await save();
                              // Provider.of<TransactionProvider>(context, listen: false).downloadPdf(context, data.txid ?? data.id ?? "");
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(color: CustomColors.sDarkColor2, shape: BoxShape.circle),
                                  child: SvgPicture.asset(
                                    'images/receipt-2.svg',
                                    color: CustomColors.sPrimaryColor500,
                                    height: 24,
                                    width: 24,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text('Download Receipt', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 32),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              _takeScreenhot();
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(color: CustomColors.sDarkColor2, shape: BoxShape.circle),
                                  child: SvgPicture.asset(
                                    'images/Send.svg',
                                    color: CustomColors.sPrimaryColor500,
                                    height: 24,
                                    width: 24,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text('Share Receipt', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Support Button
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, SlideLeftRoute(page: const HelpAndSupportScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.headset_mic, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text('Speak to Support', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContainer() {
    return Screenshot(
      controller: screenshotController,
      child: Container(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 39.h, top: 10.h),
        decoration: const BoxDecoration(
          color: CustomColors.sBackgroundColor,
          // borderRadius: BorderRadius.all(Radius.circular(23.r))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Center(child: Text("Here is your spray details", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700) )),
            // height16,
            dividerWidget,
            height26,
            // Receipt Details
            if (view['reference'] != null) _buildReceiptRow('Reference', '${view['reference']}'),
            _buildReceiptRow('Order Quantity', '${data.amount.toPlainNumber().shortenNumber()} ${data.currency.toString().toUpperCase()}'),
            // _buildReceiptRow('Rate:', '1 USDT = ₦1,697.51'),
            _buildReceiptRow(' Fee:', '${view['fee'] ?? "0"} ${data.currency.toString().toUpperCase()}'),
            _buildReceiptRow('Spraay Fee:', '100 NGN'),
            _buildReceiptRow('Date & Time:', data.formattedDate ?? ""),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Transaction Status:', style: TextStyle(color: Colors.grey[400], fontSize: 16)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: data.isSuccess ? const Color(0xFF10B981) : Colors.amber,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(data.status ?? "", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            dividerWidget,
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 16)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }

  void _takeScreenhot() async {
    final box = context.findRenderObject() as RenderBox?;
    await screenshotController.capture(delay: const Duration(milliseconds: 10)).then((Uint8List? image) async {
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/image.png').create();
        await imagePath.writeAsBytes(image);
        await Share.shareFiles(
          [imagePath.path],
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
        );
      }
    });
  }

  Future save() async {
    try {
      final Uint8List? image = await screenshotController.capture(
        delay: const Duration(milliseconds: 10),
      );

      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final imagePath = File('${directory.path}/screenshot_$timestamp.png');
        print(imagePath);
        await imagePath.writeAsBytes(image).then((v) {
          print(v.toString());
        });

        Fluttertoast.showToast(
          msg: "Screenshot saved successfully!",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error saving screenshot",
        backgroundColor: Colors.red,
      );
    }
  }
}

double parseDouble(dynamic v) {
  if (v == null) return 0.0;
  return double.tryParse(v.toString()) ?? 0.0;
}

extension StringScientificExt on String? {
  /// Converts scientific notation string ("5.204e-10") to a plain decimal string.
  /// Returns null if the original string is null or empty.
  String? toPlainNumber() {
    if (this == null || this!.trim().isEmpty) return null;

    final value = double.tryParse(this!.trim());
    if (value == null) return this; // return original if not a valid number

    // Convert to plain string without scientific notation
    String plain = value.toStringAsFixed(20);

    // Remove trailing zeros and dot
    plain = plain.replaceFirst(RegExp(r'\.?0+$'), '');

    return plain;
  }

  String shortenNumber({int fractionDigits = 2}) {
    if (this == null || this!.trim().isEmpty) return "";

    final parsed = double.tryParse(this!.trim());
    if (parsed == null) return this!; // return original string if invalid

    // If it's extremely small or extremely large → scientific notation.
    if ((parsed != 0.0 && parsed.abs() < 0.001) || parsed.abs() >= 1e6) {
      return parsed.toStringAsExponential(fractionDigits);
    }

    // Normal formatting with rounding
    return parsed.toStringAsFixed(fractionDigits);
  }
}
