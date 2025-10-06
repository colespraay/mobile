import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spraay/models/wallets-response.dart';

class CAssetImage extends StatelessWidget {
  final num size;
  final Wallet? wallet;
  const CAssetImage({super.key, this.size = 40, this.wallet});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: wallet?.imageUrl ?? "",
        width: size.w,
        height: size.h,
        fit: BoxFit.fill,
        errorWidget: (context, url, error) => Container(
            width: size.w,
            height: size.h,
            color: Colors.grey[500],
            child: Center(
              child: Text(
                wallet?.name?[0] ?? "",
                style: const TextStyle(color: Colors.white),
              ),
            )),
      ),
    );
  }
}
