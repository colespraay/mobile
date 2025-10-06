import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/wallets-response.dart';
import 'package:spraay/ui/crypto/widgets/asset-image.dart';
import 'package:spraay/ui/crypto/widgets/misc.dart';

class ReceiverDetails extends StatelessWidget {
  final Wallet cAsset;
  const ReceiverDetails({super.key, required this.cAsset});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppBar(context: context, title: "Receive Asset"),
      body: Column(
        children: [
          const SizedBox(height: 25),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  CAssetImage(wallet: cAsset),
                  SizedBox(
                    width: 16.w,
                  ),
                  Expanded(
                    child: Text(
                      cAsset.name ?? "",
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
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: CustomColors.cardBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: QrImageView(
                    backgroundColor: Colors.white,
                    data: cAsset.depositAddress ?? "", // The string to be encoded in the QR code
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
                        cAsset.depositAddress ?? "",
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
                    SvgPicture.asset('images/copy.svg')
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: Color(0xff663C0C), borderRadius: BorderRadius.circular(32)),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Color(0xffE6BF00),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Only deposit ${cAsset.currency?.toUpperCase()} to this address',
                        style: TextStyle(
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
            height: 24,
          ),
          buttonWidget(onDone: () {}, title: "Share QR Code")
        ],
      ),
    );
  }
}
