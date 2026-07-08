import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/virtual_number/vn_country.dart';
import 'package:spraay/models/virtual_number/vn_price.dart';
import 'package:spraay/models/virtual_number/vn_service.dart';
import 'package:spraay/services/virtual_number_service.dart';
import 'package:spraay/ui/others/bill_payments/virtual-numbers/providers/virtual_number_providers.dart';
import 'package:spraay/ui/others/bill_payments/virtual-numbers/virtual_number_order_page.dart';
import 'package:spraay/ui/others/bill_payments/virtual-numbers/widgets/vn_order_card.dart';
import 'package:spraay/view_model/auth_provider.dart';

/// Confirms the transaction PIN and executes the purchase. Kept as its own
/// page (rather than a bottom sheet) to match the PIN-confirmation pattern
/// used across the rest of the bill-payment flows in this app.
class VnPinConfirmPage extends ConsumerStatefulWidget {
  final VnService service;
  final VnCountry country;
  final VnPrice price;

  const VnPinConfirmPage({super.key, required this.service, required this.country, required this.price});

  @override
  ConsumerState<VnPinConfirmPage> createState() => _VnPinConfirmPageState();
}

class _VnPinConfirmPageState extends ConsumerState<VnPinConfirmPage> {
  StreamController<ErrorAnimationType>? _errorController;
  String _pin = '';

  @override
  void initState() {
    super.initState();
    _errorController = StreamController<ErrorAnimationType>();
  }

  @override
  void dispose() {
    _errorController?.close();
    super.dispose();
  }

  Future<void> _confirm() async {
    if (_pin.length != 4) return;
    try {
      final order = await ref.read(vnBuyNotifierProvider.notifier).buy(
            service: widget.service.code,
            country: widget.country.code,
            transactionPin: _pin,
          );
      if (!mounted) return;
      Provider.of<AuthProvider>(context, listen: false).fetchUserDetailApi();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => VnOrderDetailPage(orderId: order.id)));
    } on VirtualNumberException catch (e) {
      _errorController?.add(ErrorAnimationType.shake);
      if (mounted) errorCherryToast(context, e.message);
    } catch (_) {
      _errorController?.add(ErrorAnimationType.shake);
      if (mounted) errorCherryToast(context, 'Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(vnBuyNotifierProvider).isLoading;

    return LoadingOverlayWidget(
      loading: loading,
      child: Scaffold(
        appBar: buildAppBar(context: context, title: 'Confirm Purchase'),
        body: ListView(
          padding: horizontalPadding,
          shrinkWrap: true,
          children: [
            height34,
            Center(child: VnServiceAvatar(service: widget.service, size: 64)),
            height20,
            Text(
              'You are buying a ${widget.service.name} number in ${widget.country.name} for ₦${currrency.format(widget.price.amountNgn)}',
              textAlign: TextAlign.center,
              style: CustomTextStyle.kTxtBold.copyWith(fontWeight: FontWeight.bold, fontSize: 21.sp, color: CustomColors.sGreyScaleColor50, fontFamily: 'PlusJakartaSans'),
            ),
            height16,
            Text(
              'Enter PIN to confirm this transaction',
              textAlign: TextAlign.center,
              style: CustomTextStyle.kTxtSemiBold.copyWith(fontWeight: FontWeight.w500, fontSize: 18.sp, color: CustomColors.sGreyScaleColor50),
            ),
            height45,
            _pinField(),
            height26,
            CustomButton(
              onTap: _pin.length == 4 ? _confirm : null,
              buttonText: 'Buy Number',
              borderRadius: 30.r,
              width: 380.w,
              buttonColor: _pin.length == 4 ? CustomColors.sPrimaryColor500 : CustomColors.sDisableButtonColor,
            ),
            height34,
          ],
        ),
      ),
    );
  }

  Widget _pinField() {
    return Center(
      child: SizedBox(
        width: 300.w,
        child: PinCodeTextField(
          appContext: context,
          autoFocus: true,
          length: 4,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textStyle: CustomTextStyle.kTxtRegular.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w400),
          obscureText: true,
          keyboardType: TextInputType.number,
          animationType: AnimationType.fade,
          errorAnimationController: _errorController,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 57.h,
            fieldWidth: 57.w,
            inactiveColor: CustomColors.sDarkColor3,
            activeColor: CustomColors.sDarkColor3,
            selectedColor: CustomColors.sPrimaryColor500,
          ),
          animationDuration: const Duration(milliseconds: 300),
          onChanged: (value) => setState(() => _pin = value),
          onCompleted: (_) => _confirm(),
        ),
      ),
    );
  }
}
