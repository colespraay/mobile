import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/giftcard-model.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/dashboard/dashboard_screen.dart';
import 'package:spraay/ui/home/fund_wallet.dart';
import 'package:spraay/ui/others/bill_payments/giftcard/widgets/billpayment-pin-widget.dart';
import 'package:spraay/ui/others/bill_payments/giftcard/widgets/giftcard-amount.dart';
import 'package:spraay/ui/others/bill_payments/giftcard/widgets/wallet-balance.dart';
import 'package:spraay/view_model/bill_payment_provider.dart';

class GiftCardDetails extends StatefulWidget {
  String title;
  SingleGiftCardModel card;
  GiftCardDetails({super.key, required this.title, required this.card});

  @override
  State<GiftCardDetails> createState() => _GiftCardDetailsState();
}

class _GiftCardDetailsState extends State<GiftCardDetails> {
  final GlobalKey<FormState> _myKey = GlobalKey<FormState>();

  TextEditingController amtController = TextEditingController();

  // FocusNode? _textField1Focus;

  FocusNode? _textField2Focus;

  FocusNode? _textField3Focus;

  bool get hasPrice => (widget.card.minRecipientDenomination != null) && (widget.card.maxRecipientDenomination != null);

  bool get hasFixedPrices => widget.card.fixedRecipientDenominations != null && widget.card.fixedRecipientDenominations!.length != 0;

  List<num> get prices => widget.card.fixedRecipientDenominations != null && widget.card.fixedRecipientDenominations!.length != 0
      ? widget.card.fixedRecipientDenominations!
      : [(widget.card.minRecipientDenomination ?? 3), (widget.card.maxRecipientDenomination ?? 300)];

  @override
  void initState() {
    print('hasPrice ::: $hasFixedPrices');
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BillPaymentProvider>(context, listen: false).getFxRate(widget.card.recipientCurrencyCode ?? "", 1);
    });
    setState(() {
      _textField2Focus = FocusNode();
      _textField3Focus = FocusNode();
    });
  }

  @override
  void dispose() {
    _textField2Focus?.dispose();
    amtController.dispose();
    _textField3Focus?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayWidget(
      loading: Provider.of<BillPaymentProvider>(context, listen: true).giftCardLoading,
      child: Scaffold(
          appBar: buildAppBar(context: context, title: "GiftCard"),
          body: Form(
            key: _myKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: buildGiftCardDetails(),
          )),
    );
  }

  Widget buildGiftCardAmountDropdown(BuildContext context) {
    return Consumer<BillPaymentProvider>(builder: (context, provider, _) {
      return CustomDropdown<num>(
        items: prices,
        selectedItem: provider.selectedPrice,
        onItemSelected: (price) {
          setState(() {
            provider.setSelectedPrice(price);
          });
          // provider.getFxRate(provider.selectedPrice ?? 0);
        },
        itemLabelBuilder: (p) => "\$${p.toString()}",
        itemIdBuilder: (p) => p.toString(),
        hintText: "Choose Denomination",
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

  Widget buildGiftCardDetails() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // hides keyboard
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: horizontalPadding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WalletBalance(),
              height40,
              Center(
                child: Image.network(
                  widget.card.logoUrls?[0] ?? "",
                  fit: BoxFit.cover,
                  height: 100,
                ),
              ),
              height20,
              CustomizedTextField(
                onTap: () {},
                textEditingController: amtController,
                keyboardType: TextInputType.phone,
                // maxLength: 10,
                textInputAction: TextInputAction.next,
                hintTxt: "Quantity (\$)",
                inputFormat: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) => Provider.of<BillPaymentProvider>(context, listen: false).setGiftCardQuantity(value),
              ),
              height20,
              hasFixedPrices
                  ? buildGiftCardAmountDropdown(context)
                  : CustomizedTextField(
                      onTap: () {},
                      textEditingController: Provider.of<BillPaymentProvider>(context, listen: false).customPriceController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      hintTxt: "Price (${widget.card.recipientCurrencyCode})",
                      inputFormat: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) => Provider.of<BillPaymentProvider>(context, listen: false).setSelectedPrice(num.tryParse(value ?? "0") ?? 0),
                    ),
              height20,
              const Text(
                "You Pay",
                style: TextStyle(color: Colors.white),
              ),
              height4,
              CustomizedTextField(
                readOnly: true,
                onTap: () {},
                textEditingController: Provider.of<BillPaymentProvider>(context, listen: false).youPayController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                hintTxt: "",
              ),
              // const Spacer(
              //   flex: 2,
              // ),
              SizedBox(
                height: 100,
              ),
              Consumer<BillPaymentProvider>(
                builder: (context, provider, _) => Center(
                  child: CustomButton(
                      onTap: () {
                        // PinWidget
                        provider.giftCardModel = widget.card;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => PinWidget(
                                      onDone: (v) {
                                        provider.purchaseGiftCard(context, v);
                                      },
                                      title: widget.card.productName,
                                      card: widget.card,
                                      ngnPrice: provider.totalAmount.toString(),
                                      usdPrice: provider.selectedPrice.toString(),
                                    )));
                      },
                      buttonText: 'Continue',
                      borderRadius: 30.r,
                      width: 380.w,
                      buttonColor: provider.totalAmount != 0 ? CustomColors.sPrimaryColor500 : CustomColors.sDisableButtonColor),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              // const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

popupDialogFailedResponse(BuildContext context, {String? error}) {
  return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return Dialog(
            backgroundColor: CustomColors.sDarkColor2,
            insetPadding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.r),
            ),
            child: Container(
              width: 340.w,
              decoration: BoxDecoration(
                color: CustomColors.sDarkColor2,
                borderRadius: BorderRadius.circular(40.r),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 20.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    height40,
                    Image.asset("images/Incorrect_sign.png", width: 140.w, height: 140.h),
                    // Container(width: 140.w, height: 140.h, color: Colors.yellow,),
                    height30,
                    Text(
                      "Transaction Failed",
                      style: CustomTextStyle.kTxtBold.copyWith(fontSize: 24.sp, fontWeight: FontWeight.w700, color: CustomColors.sPrimaryColor400),
                    ),
                    height16,
                    SizedBox(
                        width: 276.w,
                        child: Text(
                          error ?? "Ops!!!! You do not have sufficient balance to purchase this ticket. Please top up your account!",
                          style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: CustomColors.sWhiteColor),
                          textAlign: TextAlign.center,
                        )),
                    height30,
                    CustomButton(
                        onTap: () {
                          Navigator.pushReplacement(context, FadeRoute(page: const FundWallet()));
                        },
                        buttonText: "Top up",
                        borderRadius: 30.r,
                        buttonColor: CustomColors.sPrimaryColor500),
                    height22,
                    CustomButton(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(context, FadeRoute(page: const DasboardScreen()), (Route<dynamic> route) => false);
                        },
                        buttonText: "Take me Home",
                        borderRadius: 30.r,
                        buttonColor: CustomColors.sDarkColor3),
                  ],
                ),
              ),
            ),
          );
        });
      });
}
