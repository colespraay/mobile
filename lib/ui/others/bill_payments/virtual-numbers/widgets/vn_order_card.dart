import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/virtual_number/vn_order.dart';
import 'package:spraay/models/virtual_number/vn_service.dart';

Color vnStatusColor(VnOrderStatus status) {
  switch (status) {
    case VnOrderStatus.pending:
    case VnOrderStatus.waitingSms:
      return CustomColors.sGreenColor500;
    case VnOrderStatus.received:
      return CustomColors.sSuccessColor;
    case VnOrderStatus.cancelled:
    case VnOrderStatus.expired:
      return CustomColors.sErrorColor;
    case VnOrderStatus.unknown:
      return CustomColors.sGreyScaleColor500;
  }
}

const _avatarPalette = [
  CustomColors.sPrimaryColor500,
  CustomColors.sSecondaryColor500,
  CustomColors.sSuccessColor,
  Color(0xFFFF9900),
  Color(0xFF25D366),
  CustomColors.sPrimaryColor400,
  Color(0xFFEF5DA8),
  Color(0xFF00B8D9),
];

/// Every virtual-number service is rendered with a deterministic
/// initial-letter avatar rather than a hardcoded icon map, since the
/// catalog has hundreds of services and grows over time.
class VnServiceAvatar extends StatelessWidget {
  final VnService service;
  final double size;

  const VnServiceAvatar({super.key, required this.service, this.size = 36});

  @override
  Widget build(BuildContext context) {
    final color = _avatarPalette[service.code.hashCode.abs() % _avatarPalette.length];
    final initial = service.name.isNotEmpty ? service.name[0].toUpperCase() : '?';
    return Container(
      width: size.w,
      height: size.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color.withOpacity(0.18), borderRadius: BorderRadius.circular(10.r)),
      child: Text(
        initial,
        style: CustomTextStyle.kTxtBold.copyWith(color: color, fontSize: (size * 0.42).sp),
      ),
    );
  }
}

class VnOrderCard extends StatefulWidget {
  final VnOrder order;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;

  const VnOrderCard({super.key, required this.order, this.onTap, this.onCancel});

  @override
  State<VnOrderCard> createState() => _VnOrderCardState();
}

class _VnOrderCardState extends State<VnOrderCard> {
  Timer? _ticker;
  int? _secondsLeft;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.order.secondsLeft;
    if (widget.order.status.isActive && _secondsLeft != null) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() => _secondsLeft = widget.order.secondsLeft);
      });
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(1, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final color = vnStatusColor(order.status);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: CustomColors.sDarkColor2,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: CustomColors.sDarkColor3, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(width: 6.w, height: 6.w, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                SizedBox(width: 6.w),
                Text(order.status.label, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 12.sp, color: color)),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                VnServiceAvatar(service: order.service),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.service.name, style: CustomTextStyle.kTxtMedium.copyWith(fontSize: 14.sp)),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              order.phone,
                              style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 13.sp, color: CustomColors.sGreyScaleColor400),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: order.phone));
                              toastMessage('Phone number copied');
                            },
                            child: Icon(Icons.copy_outlined, size: 14.sp, color: CustomColors.sGreyScaleColor500),
                          ),
                        ],
                      ),
                      if (order.code != null && order.code!.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Text('Code: ${order.code}', style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 13.sp, color: CustomColors.sGreyScaleColor400)),
                            SizedBox(width: 6.w),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: order.code!));
                                toastMessage('Code copied');
                              },
                              child: Icon(Icons.copy_outlined, size: 14.sp, color: CustomColors.sGreyScaleColor500),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Text('₦${currrency.format(order.amountNgn)}', style: CustomTextStyle.kTxtMedium.copyWith(fontSize: 14.sp)),
              ],
            ),
            if (order.status.isActive && _secondsLeft != null) ...[
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Left: ${_formatTime(_secondsLeft!)}', style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 13.sp, color: CustomColors.sGreyScaleColor400)),
                  if (widget.onCancel != null)
                    GestureDetector(
                      onTap: widget.onCancel,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 7.h),
                        decoration: BoxDecoration(color: CustomColors.sErrorColor, borderRadius: BorderRadius.circular(20.r)),
                        child: Text('Cancel', style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 13.sp)),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
