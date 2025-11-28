import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/crypto-network-model.dart';
import 'package:spraay/models/wallets-response.dart';
import 'package:spraay/ui/crypto/crypto.vm.dart';
import 'package:spraay/ui/crypto/widgets/asset-image.dart';
import 'package:spraay/ui/crypto/widgets/misc.dart';
import 'package:spraay/ui/others/bill_payments/giftcard/widgets/giftcard-amount.dart';
import 'package:spraay/utils/after-layout.dart';
import 'package:spraay/utils/screen-capture-utils.dart';

class ReceiverDetails extends StatefulWidget {
  final Wallet cAsset;
  ReceiverDetails({super.key, required this.cAsset});

  @override
  State<ReceiverDetails> createState() => _ReceiverDetailsState();
}

class _ReceiverDetailsState extends State<ReceiverDetails> with AfterLayoutMixin<ReceiverDetails> {
  CryptoProvider? cryptoProvider;

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    Provider.of<CryptoProvider>(context, listen: false).getReceiveCryptoNetworks(context, widget.cAsset.currency);
  }

  @override
  void didChangeDependencies() {
    cryptoProvider = context.watch<CryptoProvider>();

    super.didChangeDependencies();
  }

  final ShareWidgetController _shareController = ShareWidgetController();

  @override
  Widget build(BuildContext context) {
    // print(widget.cAsset.toString());
    return LoadingOverlayWidget(
      loading: cryptoProvider?.loading ?? false,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: buildAppBar(context: context, title: "Receive Asset"),
        body: Column(
          children: [
            const SizedBox(height: 25),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    CAssetImage(wallet: widget.cAsset),
                    SizedBox(
                      width: 16.w,
                    ),
                    Expanded(
                      child: Text(
                        widget.cAsset.name ?? "",
                        style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700, fontFamily: "Dm Sans"),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        "Change",
                        style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w700, fontFamily: "Dm Sans", color: CustomColors.sPrimaryColor500),
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: CustomColors.cardBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShareableWidget(
                    controller: _shareController,
                    // backgroundColor: Colors.white,
                    child: Center(
                      child: QrImageView(
                        backgroundColor: Colors.white,
                        data: widget.cAsset.depositAddress ?? "", // The string to be encoded in the QR code
                        version: QrVersions.auto, // Automatically determines the QR code version
                        size: 200.0, // Size of the QR code image
                        gapless: true, // Set to true for a more compact QR code without a white border
                        errorCorrectionLevel: QrErrorCorrectLevel.L, // Error correction level (L, M, Q, H)
                        // You can also add an embedded image in the center:
                        // embeddedImage: AssetImage('assets/your_logo.png'),
                        // embeddedImageStyle: QrEmbeddedImageStyle(
                        //   size: Size(80, 80),
                        // ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Address",
                    style: CustomTextStyle.kTxtRegular.copyWith(color: CustomColors.semanticFGMuted, fontSize: 12.sp, fontWeight: FontWeight.w400),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          cryptoProvider?.selectedNetwork?.address ?? widget.cAsset.depositAddress ?? "",
                          style: CustomTextStyle.kTxtRegular.copyWith(
                            color: CustomColors.sWhiteColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                          onTap: () => copyToClipboardWithFeedback(cryptoProvider?.selectedNetwork?.address ?? widget.cAsset.depositAddress ?? "", successMessage: "Address Copied to Clipboard"),
                          behavior: HitTestBehavior.opaque,
                          child: SvgPicture.asset('images/copy.svg'))
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: const Color(0xff663C0C), borderRadius: BorderRadius.circular(32)),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Color(0xffE6BF00),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Only deposit ${widget.cAsset.currency?.toUpperCase()} to this address',
                          style: const TextStyle(
                            color: Color(0xffE6BF00),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    "Network:",
                    style: CustomTextStyle.kTxtRegular.copyWith(color: CustomColors.sWhiteColor, fontSize: 14.sp, fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 200,
                  child: networkDropDown(context),
                ),
                // Text(
                //   "${widget.cAsset.defaultNetworkObject?.name} (${widget.cAsset.defaultNetworkObject?.id?.toUpperCase()})",
                //   style: CustomTextStyle.kTxtRegular.copyWith(
                //     color: CustomColors.sWhiteColor,
                //     fontSize: 16.sp,
                //     fontWeight: FontWeight.w400,
                //   ),
                // ),
              ]),
            ),
            const SizedBox(
              height: 24,
            ),
            buttonWidget(
                onDone: () => _shareController.shareAsImage(
                      text: '${widget.cAsset.name} (${widget.cAsset.currency?.toUpperCase()}) Deposit Address',
                      fileName: widget.cAsset.hashCode.toString(),
                    ),
                title: "Share QR Code")
          ],
        ),
      ),
    );
  }

  Widget networkDropDown(BuildContext context) {
    return Consumer<CryptoProvider>(builder: (context, provider, _) {
      return CustomDropdown<CryptoNetwork>(
        items: cryptoProvider?.networks ?? [],
        selectedItem: cryptoProvider?.selectedNetwork,
        onItemSelected: (network) => cryptoProvider?.setSelectedNetwork(network),
        itemLabelBuilder: (p) => p.network?.toUpperCase() ?? "",
        itemIdBuilder: (p) => p.network?.toUpperCase(),
        hintText: "Choose Network",
        backgroundColor: CustomColors.sDarkColor2,
        dropdownColor: CustomColors.sDarkColor2,
        focusBorderColor: CustomColors.sPrimaryColor500,
        iconColor: CustomColors.sDisableButtonColor,
        selectedItemColor: CustomColors.sPrimaryColor500,
        selectedItemTextStyle: CustomTextStyle.kTxtRegular.copyWith(
          color: CustomColors.sWhiteColor,
          fontSize: 14.sp,
        ),
        hintTextStyle: CustomTextStyle.kTxtRegular.copyWith(
          color: CustomColors.sGreyScaleColor500,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        itemTextStyle: CustomTextStyle.kTxtRegular.copyWith(
          color: CustomColors.sWhiteColor,
          fontSize: 14.sp,
        ),
      );
    });
  }
}
