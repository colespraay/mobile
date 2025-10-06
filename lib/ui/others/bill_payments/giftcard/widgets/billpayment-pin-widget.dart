import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/giftcard-model.dart';
import 'package:spraay/view_model/bill_payment_provider.dart';

class PinWidget extends StatefulWidget {
  final Function(String) onDone;
  final String? title, ngnPrice, usdPrice;
  SingleGiftCardModel? card;
  PinWidget({super.key, required this.onDone, this.title, this.ngnPrice, this.usdPrice, this.card});

  @override
  State<PinWidget> createState() => _PinWidgetState();
}

class _PinWidgetState extends State<PinWidget> {
  final GlobalKey<FormState> _myKey = GlobalKey<FormState>();
  StreamController<ErrorAnimationType>? errorController;
  String requiredNumber = "";

  BillPaymentProvider? _billPaymentProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _billPaymentProvider = context.watch<BillPaymentProvider>();
  }

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
  }

  @override
  void dispose() {
    errorController!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayWidget(
      loading: _billPaymentProvider?.loading ?? false,
      child: Scaffold(
          appBar: buildAppBar(context: context, title: "${widget.title}"),
          body: Form(
            key: _myKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: horizontalPadding,
              shrinkWrap: true,
              children: [
                height34,
                Center(
                    child: Image.network(
                  widget.card?.logoUrls?[0] ?? "",
                  width: 80.w,
                  height: 80.h,
                )),
                height20,
                Text("You are about to buy ₦${widget.ngnPrice}  (\$${widget.usdPrice}) giftcard",
                    style: CustomTextStyle.kTxtBold.copyWith(fontWeight: FontWeight.bold, fontSize: 21.sp, color: CustomColors.sGreyScaleColor50, fontFamily: "PlusJakartaSans")),
                height16,
                Text("Enter PIN to confirm this transaction", style: CustomTextStyle.kTxtSemiBold.copyWith(fontWeight: FontWeight.w500, fontSize: 18.sp, color: CustomColors.sGreyScaleColor50)),
                height45,
                pincodeTextfield(context),
                height26,
                CustomButton(
                    onTap: () => widget.onDone(requiredNumber),
                    buttonText: 'Continue',
                    borderRadius: 30.r,
                    width: 380.w,
                    buttonColor: requiredNumber.length == 4 ? CustomColors.sPrimaryColor500 : CustomColors.sDisableButtonColor),
                height34,
              ],
            ),
          )),
    );
  }

  Widget pincodeTextfield(BuildContext context) {
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
          keyboardType: TextInputType.phone,
          animationType: AnimationType.fade,
          errorAnimationController: errorController,
          pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 57.h,
              fieldWidth: 57.w,
              // activeFillColor: Colors.red,
              inactiveColor: CustomColors.sDarkColor3,
              activeColor: CustomColors.sDarkColor3,
              selectedColor: CustomColors.sPrimaryColor500),
          animationDuration: Duration(milliseconds: 300),
          // enableActiveFill: true,
          onChanged: (value) {
            setState(() {
              requiredNumber = value;
            });
          },
          onCompleted: (v) {
            if (v == requiredNumber) {
              //  validateTofaTok(context,v);
            } else {
              print('invalid');
            }
          }, // Pass it here
        ),
      ),
    );
  }
}
