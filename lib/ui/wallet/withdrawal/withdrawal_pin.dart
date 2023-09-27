import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/dashboard/dashboard_screen.dart';
import 'package:spraay/ui/others/payment_receipt.dart';
import 'package:spraay/view_model/auth_provider.dart';
import 'package:spraay/view_model/transaction_provider.dart';

class WithdrawalOtp extends StatefulWidget {
  String fromWhere, accountNumber,bankName,bankCode,amount, accountName;
   WithdrawalOtp({required this.fromWhere, required this.bankCode,required this.bankName,required this.amount,required this.accountNumber, required this.accountName});


  @override
  State<WithdrawalOtp> createState() => _WithdrawalOtpState();
}

class _WithdrawalOtpState extends State<WithdrawalOtp> {
  final GlobalKey<FormState> _myKey = GlobalKey<FormState>();
  StreamController<ErrorAnimationType>? errorController;
  String requiredNumber="";



  TransactionProvider? _transactionProvider;
  @override
  void didChangeDependencies() {
    _transactionProvider=context.watch<TransactionProvider>();
    super.didChangeDependencies();
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
    return  LoadingOverlayWidget(
      loading: _transactionProvider?.loading??false,
      child: Scaffold(
          appBar: buildAppBar(context: context, title: "Withdraw"),
          body: Form(
            key: _myKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: horizontalPadding,
              shrinkWrap: true,
              children: [
                height16,
                Text("You are about to withdraw  ₦${widget.amount} from your wallet to ${widget.accountName} ${widget.accountNumber} (${widget.bankName})", style: CustomTextStyle.kTxtBold.copyWith(fontWeight: FontWeight.bold,
                    fontSize: 20.sp, color: CustomColors.sGreyScaleColor50, fontFamily: "PlusJakartaSans")),
                height8,
                Text("Enter PIN to confirm this transaction", style: CustomTextStyle.kTxtSemiBold.copyWith(fontWeight: FontWeight.w500, fontSize: 18.sp, color: CustomColors.sGreyScaleColor50)),

                height45,
                pincodeTextfield(context),

                height26,
                CustomButton(
                    onTap: () {
                      if(requiredNumber.length==4){
                        _transactionProvider?.fetchWithdrawalApi(context, widget.bankName,
                            widget. accountNumber,  widget.bankCode, requiredNumber,  widget.amount, widget.fromWhere, widget.accountName);

                      }
                    },
                    buttonText: 'Top up', borderRadius: 30.r,width: 380.w,
                    buttonColor: requiredNumber.length==4 ? CustomColors.sPrimaryColor500:
                    CustomColors.sDisableButtonColor),
                height34,
              ],
            ),
          )),
    );
  }

  Widget pincodeTextfield(BuildContext context){
    return Center(
      child: SizedBox(
        width: 300.w,
        child: PinCodeTextField(
          appContext: context,
          autoFocus: true,
          length: 4,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly
          ],
          textStyle: CustomTextStyle.kTxtRegular.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w400),
          obscureText: false,
          keyboardType: TextInputType.phone,
          animationType: AnimationType.fade,
          errorAnimationController: errorController,
          pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 57.h,
              fieldWidth: 57.w,
              // activeFillColor: Colors.red,
              inactiveColor:CustomColors.sDarkColor3,
              activeColor:CustomColors.sDarkColor3,
              selectedColor: CustomColors.sPrimaryColor500

          ),
          animationDuration: Duration(milliseconds: 300),
          // enableActiveFill: true,
          onChanged: (value) {
            setState(() {
              requiredNumber = value;
            });
          },
          onCompleted: (v) {
            if(v==requiredNumber){
              //  validateTofaTok(context,v);

            } else{
              print('invalid');
            }}, // Pass it here
        ),
      ),
    );
  }

}
