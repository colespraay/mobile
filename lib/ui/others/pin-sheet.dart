import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';

Future<String?> showPinForBillPaymentSheet({
  required BuildContext context,

  /// ✅ Optional callback when the user types each digit
  ValueChanged<String>? onPinChanged,
}) {
  final StreamController<ErrorAnimationType> errorController = StreamController<ErrorAnimationType>();
  String requiredNumber = "";

  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.onSurface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24.h,
          top: 24.h,
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- Drag handle ---
                  Center(
                    child: Container(
                      width: 50.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  Text(
                    "You are about to pay for this transaction",
                    textAlign: TextAlign.center,
                    style: CustomTextStyle.kTxtBold.copyWith(
                      fontSize: 18.sp,
                      color: CustomColors.sGreyScaleColor50,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  // --- Instruction ---
                  Text(
                    "Enter PIN to confirm this transaction",
                    style: CustomTextStyle.kTxtSemiBold.copyWith(
                      fontSize: 16.sp,
                      color: CustomColors.sGreyScaleColor50,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  // --- PIN input ---
                  SizedBox(
                    width: 280.w,
                    child: PinCodeTextField(
                      appContext: context,
                      length: 4,
                      autoFocus: true,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textStyle: CustomTextStyle.kTxtRegular.copyWith(fontSize: 18.sp),
                      keyboardType: TextInputType.number,
                      animationType: AnimationType.fade,
                      errorAnimationController: errorController,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(8),
                        fieldHeight: 55.h,
                        fieldWidth: 55.w,
                        inactiveColor: CustomColors.sDarkColor3,
                        activeColor: CustomColors.sPrimaryColor500,
                        selectedColor: CustomColors.sPrimaryColor500,
                      ),
                      onChanged: (v) {
                        setState(() => requiredNumber = v);
                        if (onPinChanged != null) onPinChanged(v);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 26,
                  ),

                  // --- Confirm button ---
                  CustomButton(
                    onTap: () {
                      if (requiredNumber.length == 4) {
                        Navigator.pop(context, requiredNumber);
                        if (onPinChanged != null) onPinChanged(requiredNumber);
                      }
                    },
                    buttonText: requiredNumber.length == 4 ? "Confirm" : "Continue",
                    borderRadius: 30.r,
                    width: 380.w,
                    buttonColor: requiredNumber.length == 4 ? CustomColors.sPrimaryColor500 : CustomColors.sDisableButtonColor,
                  ),
                  SizedBox(height: 24)
                ],
              ),
            );
          },
        ),
      );
    },
  ).whenComplete(() => errorController.close());
}
