import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/dashboard/dashboard_screen.dart';
import 'package:spraay/ui/others/payment_receipt.dart';
import 'package:spraay/utils/my_sharedpref.dart';
import 'package:spraay/view_model/auth_provider.dart';
import 'package:spraay/view_model/bill_payment_provider.dart';

class PinForBillPayment extends StatefulWidget {
  String title, image,amount,provider,phoneController;
  String? dataPlanId,electricityProvider,billerName,plan, cableSubscriptionId;



   PinForBillPayment({super.key, required this.title, required this.image, required this.amount, required this.provider,
    required this.phoneController, this.dataPlanId, this.electricityProvider, this.billerName, this.plan, this.cableSubscriptionId});

  @override
  State<PinForBillPayment> createState() => _PinForBillPaymentState();
}

class _PinForBillPaymentState extends State<PinForBillPayment> {
  final GlobalKey<FormState> _myKey = GlobalKey<FormState>();
  StreamController<ErrorAnimationType>? errorController;
  String requiredNumber="";

  BillPaymentProvider? _billPaymentProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _billPaymentProvider=context.watch<BillPaymentProvider>();
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
      loading: _billPaymentProvider?.loading??false,
      child: Scaffold(
          appBar: buildAppBar(context: context, title: "Confirm ${widget.title}"),
          body: Form(
            key: _myKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: horizontalPadding,
              shrinkWrap: true,
              children: [
                height34,
                widget.title=="Electricity"?Center(child: Image.asset("images/${widget.image}.png", width: 80.w, height: 80.h,)) : Center(child: SvgPicture.asset("images/${widget.image}.svg", width: 80.w, height: 80.h,)),
                height20,
                Text("You are buying ₦${widget.amount} ${widget.title.toLowerCase()} on ${widget.phoneController}",
                    style: CustomTextStyle.kTxtBold.copyWith(fontWeight: FontWeight.bold, fontSize: 21.sp, color: CustomColors.sGreyScaleColor50,
                fontFamily: "PlusJakartaSans")),
                height16,
                Text("Enter PIN to confirm this transaction", style: CustomTextStyle.kTxtSemiBold.copyWith(fontWeight: FontWeight.w500, fontSize: 18.sp, color: CustomColors.sGreyScaleColor50)),

                height45,
                pincodeTextfield(context),

                height26,
                CustomButton(
                    onTap: () {
                      if(requiredNumber.length==4){
                        //call API for transaction
                        if(widget.dataPlanId !=null) {
                          //Call data purchase API
                          _billPaymentProvider?.fetchDataPurchaseApi(context, MySharedPreference.getToken(), widget.provider, widget.phoneController,
                              widget.amount, requiredNumber, widget.image, widget.dataPlanId??"");

                        }else if(widget.electricityProvider!=null){
                          //call electricityProvider api
                          _billPaymentProvider?.fetchelEctricityUnitPurchaseApi(context,MySharedPreference.getToken(),
                              widget.electricityProvider!, widget.phoneController, widget.amount, requiredNumber, widget.image, widget.plan!, widget.billerName!);
                        }
                        else if(widget.cableSubscriptionId !=null){
                          //DSTV cable subscription
                          //widget.cableSubscriptionId
                          _billPaymentProvider?.fetchCablePurchaseApi(context, MySharedPreference.getToken(),widget.provider, widget.phoneController,
                              widget.amount, requiredNumber, widget.image,widget.cableSubscriptionId!);

                        }
                        else{
                          //call airtime purchase api
                          _billPaymentProvider?.fetchAirtimePurchaseApi(context, MySharedPreference.getToken(), widget.provider,
                              widget.phoneController,widget.amount, requiredNumber, widget.image);

                        }

                      }
                    },
                    buttonText: requiredNumber.length==4?"Top up": 'Continue', borderRadius: 30.r,width: 380.w,
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
