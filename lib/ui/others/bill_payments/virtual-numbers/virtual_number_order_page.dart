import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/virtual_number/vn_order.dart';
import 'package:spraay/services/virtual_number_service.dart';
import 'package:spraay/ui/others/bill_payments/virtual-numbers/providers/virtual_number_providers.dart';
import 'package:spraay/ui/others/bill_payments/virtual-numbers/widgets/vn_order_card.dart';

/// Live-updating detail screen for a single order: shows the number, polls
/// for the incoming SMS code while waiting, and exposes cancel/resend.
class VnOrderDetailPage extends ConsumerStatefulWidget {
  final String orderId;

  const VnOrderDetailPage({super.key, required this.orderId});

  @override
  ConsumerState<VnOrderDetailPage> createState() => _VnOrderDetailPageState();
}

class _VnOrderDetailPageState extends ConsumerState<VnOrderDetailPage> {
  Timer? _ticker;
  int? _secondsLeft;
  bool _busy = false;

  void _syncTicker(VnOrder order) {
    _secondsLeft = order.secondsLeft;
    _ticker?.cancel();
    if (order.status.isActive && _secondsLeft != null) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() => _secondsLeft = order.secondsLeft);
      });
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _cancel() async {
    setState(() => _busy = true);
    try {
      await ref.read(vnOrderProvider(widget.orderId).notifier).cancel();
      if (mounted) toastMessage('Order cancelled and wallet refunded');
    } on VirtualNumberException catch (e) {
      if (mounted) errorCherryToast(context, e.message);
    } catch (_) {
      if (mounted) errorCherryToast(context, 'Something went wrong');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resend() async {
    setState(() => _busy = true);
    try {
      await ref.read(vnOrderProvider(widget.orderId).notifier).resend();
      if (mounted) toastMessage('Requested a new code');
    } on VirtualNumberException catch (e) {
      if (mounted) errorCherryToast(context, e.message);
    } catch (_) {
      if (mounted) errorCherryToast(context, 'Something went wrong');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(1, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final orderAsync = ref.watch(vnOrderProvider(widget.orderId));

    return Scaffold(
      backgroundColor: CustomColors.sBackgroundColor,
      appBar: buildAppBar(context: context, title: 'Order Details'),
      body: orderAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => _ErrorState(
          message: err is VirtualNumberException ? err.message : 'Something went wrong',
          onRetry: () => ref.invalidate(vnOrderProvider(widget.orderId)),
        ),
        data: (order) {
          _syncTicker(order);
          return LoadingOverlayWidget(
            loading: _busy,
            child: ListView(
              padding: horizontalPadding,
              children: [
                height26,
                Center(child: VnServiceAvatar(service: order.service, size: 72)),
                height16,
                Center(
                  child: Text(order.service.name, style: CustomTextStyle.kTxtBold.copyWith(fontSize: 20.sp)),
                ),
                height8,
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(color: vnStatusColor(order.status).withOpacity(0.15), borderRadius: BorderRadius.circular(20.r)),
                    child: Text(order.status.label, style: CustomTextStyle.kTxtMedium.copyWith(fontSize: 13.sp, color: vnStatusColor(order.status))),
                  ),
                ),
                height30,
                _infoRow('Phone number', order.phone, onCopy: () {
                  Clipboard.setData(ClipboardData(text: order.phone));
                  toastMessage('Phone number copied');
                }),
                height16,
                _infoRow('Country', order.country.name),
                height16,
                _infoRow('Amount', '₦${currrency.format(order.amountNgn)}'),
                if (order.status.isActive && _secondsLeft != null) ...[
                  height16,
                  _infoRow('Time left', _formatTime(_secondsLeft!)),
                ],
                height26,
                if (order.code != null && order.code!.isNotEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(18.w),
                    decoration: BoxDecoration(color: CustomColors.sDarkColor2, borderRadius: BorderRadius.circular(14.r)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Verification code', style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 13.sp, color: CustomColors.sGreyScaleColor500)),
                        height8,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(order.code!, style: CustomTextStyle.kTxtBold.copyWith(fontSize: 28.sp, letterSpacing: 4)),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: order.code!));
                                toastMessage('Code copied');
                              },
                              child: Container(
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(color: CustomColors.sDarkColor3, borderRadius: BorderRadius.circular(10.r)),
                                child: Icon(Icons.copy_outlined, size: 18.sp),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  height26,
                ] else if (order.status.isActive) ...[
                  Center(
                    child: Column(
                      children: [
                        const CircularProgressIndicator(),
                        height16,
                        Text('Waiting for SMS...', style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, color: CustomColors.sGreyScaleColor400)),
                      ],
                    ),
                  ),
                  height26,
                ],
                if (order.status.isActive)
                  CustomButton(onTap: _cancel, buttonText: 'Cancel order', buttonColor: CustomColors.sErrorColor)
                else if (order.status == VnOrderStatus.received)
                  CustomButton(onTap: _resend, buttonText: 'Request another code', buttonColor: CustomColors.sPrimaryColor500),
                height34,
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(String label, String value, {VoidCallback? onCopy}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, color: CustomColors.sGreyScaleColor500)),
        Row(
          children: [
            Text(value, style: CustomTextStyle.kTxtMedium.copyWith(fontSize: 14.sp)),
            if (onCopy != null) ...[
              SizedBox(width: 6.w),
              GestureDetector(onTap: onCopy, child: Icon(Icons.copy_outlined, size: 16.sp, color: CustomColors.sGreyScaleColor500)),
            ],
          ],
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: horizontalPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: CustomColors.sErrorColor, size: 40.sp),
            height16,
            Text(message, textAlign: TextAlign.center, style: CustomTextStyle.kTxtRegular.copyWith(color: CustomColors.sGreyScaleColor400)),
            height16,
            CustomButton(onTap: onRetry, buttonText: 'Retry', buttonColor: CustomColors.sPrimaryColor500),
          ],
        ),
      ),
    );
  }
}
