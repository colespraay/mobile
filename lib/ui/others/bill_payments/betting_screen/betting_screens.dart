import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/betting_plan_model.dart';
import 'package:spraay/models/game_model_data.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/services/api_services.dart';
import 'package:spraay/ui/others/bill_payments/pin_for_bill_payment.dart';
import 'package:spraay/utils/my_sharedpref.dart';
import 'package:spraay/view_model/bill_payment_provider.dart';

class BettingScreen extends StatefulWidget {
  final String title;
  const BettingScreen({super.key, required this.title});

  @override
  State<BettingScreen> createState() => _BettingScreenState();
}

class _BettingScreenState extends State<BettingScreen> {
  final GlobalKey<FormState> _myKey = GlobalKey<FormState>();
  TextEditingController amtController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  FocusNode? _textField1Focus;
  FocusNode? _textField2Focus;

  @override
  void initState() {
    setState(() {
      _textField1Focus = FocusNode();
      _textField2Focus = FocusNode();
    });

    super.initState();
  }

  String firstBtn = "";
  String secondBtn = "";
  @override
  void dispose() {
    _textField1Focus?.dispose();
    _textField2Focus?.dispose();
    amtController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  fetchCheckbalanceBeforeWithdrawingApiPinApi(BuildContext context, String amount) async {
    setState(() {
      _isLoading = true;
    });
    var result = await ApiServices().checkbalanceBeforeWithdrawingApi(MySharedPreference.getToken(), amount.replaceAll(",", ""));
    if (result['error'] == true) {
      popupDialog(
          context: context,
          title: "Transaction Failed",
          content: result['message'],
          buttonTxt: 'Try again',
          onTap: () {
            Navigator.pop(context);
          },
          png_img: 'Incorrect_sign');
      // if(context.mounted){
      //   popupDialog(context: context, title: "Transaction Failed", content:result['message'],
      //       buttonTxt: 'Try again', onTap: () {Navigator.pop(context);}, png_img: 'Incorrect_sign');
      // }
    } else {
      fetchverifyElectricityUnitPurchaseApi(context, providerGameIdCode, phoneController.text, amount, shortCodeBetin);
    }

    setState(() {
      _isLoading = false;
    });
  }

  fetchverifyElectricityUnitPurchaseApi(BuildContext context, String provider, String meterNumber, String amount, String plan) async {
    setState(() {
      _isLoading = true;
    });
    var result = await ApiServices().verifyElectricityUnitPurchaseApi(MySharedPreference.getToken(), provider, meterNumber, amount, plan);
    if (result['error'] == true) {
      popupDialog(
          context: context,
          title: "Transaction Failed",
          content: result['message'],
          buttonTxt: 'Try again',
          onTap: () {
            Navigator.pop(context);
          },
          png_img: 'Incorrect_sign');
      // if(context.mounted){
      //   popupDialog(context: context, title: "Transaction Failed", content:result['message'],
      //       buttonTxt: 'Try again', onTap: () {Navigator.pop(context);}, png_img: 'Incorrect_sign');
      // }
    } else {
      Navigator.push(
          context,
          SlideLeftRoute(
              page: PinForBillPayment(
            title: widget.title,
            image: imageAirtime,
            amount: amount,
            provider: imageAirtime.replaceAll("_", "").toUpperCase(),
            phoneController: phoneController.text,
            providerGameIdCode: provider,
            billerName: result["billerName"],
            plan: plan,
            electricUserName: result["name"],
          )));
      // if(context.mounted){
      //   //call API
      //   Navigator.push(context, SlideLeftRoute(page: PinForBillPayment(title: widget.title, image: imageAirtime, amount: amount,
      //     provider: imageAirtime.replaceAll("_", "").toUpperCase(), phoneController: phoneController.text,providerGameIdCode: provider,billerName: result["billerName"],plan: plan,
      //     electricUserName: result["name"],)));
      // }
    }

    setState(() {
      _isLoading = false;
    });
  }

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return LoadingOverlayWidget(
      loading: _isLoading,
      child: Scaffold(
          appBar: buildAppBar(context: context, title: widget.title),
          body: Form(
            key: _myKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: horizontalPadding,
              shrinkWrap: true,
              children: [
                height45,
                buildElectricityDropDown(),
                height20,
                _buildPostPaidWidget(),
                height20,
                CustomizedTextField(
                  textEditingController: phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 11,
                  textInputAction: TextInputAction.next,
                  hintTxt: "Meter Number",
                  focusNode: _textField1Focus,
                  inputFormat: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    setState(() {
                      firstBtn = value;
                    });
                  },
                ),
                height22,
                CustomizedTextField(
                  textEditingController: amtController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  hintTxt: "Enter Amount",
                  focusNode: _textField2Focus,
                  prefixText: "₦ ",
                  inputFormat: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')), NumberTextInputFormatter()],
                  onChanged: (value) {
                    setState(() {
                      secondBtn = value;
                    });
                  },
                ),
                height34,
                buildHorizontalTicket(),
                height40,
                Center(
                  child: CustomButton(
                      onTap: () {
                        if (firstBtn.isNotEmpty && secondBtn.isNotEmpty) {
                          fetchCheckbalanceBeforeWithdrawingApiPinApi(context, amtController.text);

                          // if(shortCodeBetin.isEmpty){
                          //   cherryToastInfo(context, "Info!", "Select betting plan");
                          // }else{
                          //   fetchCheckbalanceBeforeWithdrawingApiPinApi(context, amtController.text,shortCodeBetin);
                          // }
                        }
                      },
                      buttonText: 'Continue',
                      borderRadius: 30.r,
                      width: 380.w,
                      buttonColor: (firstBtn.isNotEmpty && secondBtn.isNotEmpty) ? CustomColors.sPrimaryColor500 : CustomColors.sDisableButtonColor),
                ),
                height34,
              ],
            ),
          )),
    );
  }

  String providerGameIdCode = "";
  String displayNameGame = '';
  String imageAirtime = "";

  Widget buildElectricityDropDown() {
    return Consumer<BillPaymentProvider>(builder: (context, dataProvider, widget) {
      return DropdownButtonFormField<GameDatum>(
        iconEnabledColor: CustomColors.sDisableButtonColor,
        focusColor: CustomColors.sDarkColor2,
        dropdownColor: CustomColors.sDarkColor2,
        isDense: false,
        items: dataProvider.gameList.map((GameDatum value) {
          return DropdownMenuItem<GameDatum>(
            value: value,
            child: SizedBox(
                width: 290.w,
                child: Text(
                  value.displayName ?? "",
                  style: CustomTextStyle.kTxtRegular.copyWith(color: CustomColors.sWhiteColor, fontSize: 14.sp),
                )),
          );
        }).toList(),
        onChanged: (GameDatum? newValue) {
          setState(() {
            // airtimePosition = 0;//position
            imageAirtime = "game";
            providerGameIdCode = newValue?.code ?? "";
            displayNameGame = newValue?.displayName ?? "";
          });

          Provider.of<BillPaymentProvider>(context, listen: false).fetchBettingPlanApiList(providerGameIdCode);
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
          hintText: "Choose Betting platform",
          isDense: true,
          fillColor: CustomColors.sDarkColor2,
          filled: true,
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 0.2.w),
            borderRadius: BorderRadius.circular(8.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent, width: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: CustomColors.sPrimaryColor500, width: 0.5),
            borderRadius: BorderRadius.circular(8.r),
          ),
          hintStyle: CustomTextStyle.kTxtRegular.copyWith(color: CustomColors.sGreyScaleColor500, fontSize: 14.sp, fontWeight: FontWeight.w400),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: const Color(0xff0166F4), width: 0.2.w),
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      );
    });
  }

  String shortCodeBetin = "";
  Widget _buildPostPaidWidget() {
    return Consumer<BillPaymentProvider>(builder: (context, packageData, widget) {
      if (packageData.loading) {
        return Center(child: Text("Loading...", style: CustomTextStyle.kTxtRegular.copyWith(color: CustomColors.sWhiteColor, fontSize: 14.sp)));
      } else if (packageData.bettingPlanList.isEmpty) {
        return const SizedBox.shrink();
      } else {
        return DropdownButtonFormField<BettingPlanDatum>(
          iconEnabledColor: CustomColors.sDisableButtonColor,
          focusColor: CustomColors.sDarkColor2,
          dropdownColor: CustomColors.sDarkColor2,
          isDense: false,
          items: packageData.bettingPlanList.map((BettingPlanDatum value) {
            return DropdownMenuItem<BettingPlanDatum>(
              value: value,
              child: SizedBox(
                  width: 290.w,
                  child: Text(
                    value.name ?? "",
                    style: CustomTextStyle.kTxtRegular.copyWith(color: CustomColors.sWhiteColor, fontSize: 14.sp),
                  )),
            );
          }).toList(),
          onChanged: (BettingPlanDatum? newValue) {
            setState(() {
              shortCodeBetin = newValue?.shortCode ?? "";
              // airtimePosition = 0;//position
              // imageAirtime="ekedc";
              // electricityProvider=newValue?.code??"";
              // displayNameElectricity=newValue?.displayName??"";
            });
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
            hintText: "Choose Betting plan",
            isDense: true,
            fillColor: CustomColors.sDarkColor2,
            filled: true,
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 0.2.w),
              borderRadius: BorderRadius.circular(8.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent, width: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: CustomColors.sPrimaryColor500, width: 0.5),
              borderRadius: BorderRadius.circular(8.r),
            ),
            hintStyle: CustomTextStyle.kTxtRegular.copyWith(color: CustomColors.sGreyScaleColor500, fontSize: 14.sp, fontWeight: FontWeight.w400),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: const Color(0xff0166F4), width: 0.2.w),
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        );
      }
    });
  }

  int index_pos = -1;
  List<String> cashList = ["500", "1000", "3000", "5000", "10,000", "15,000", "20,000", "30,000", "50,000"];
  Widget buildHorizontalTicket() {
    return Wrap(
      alignment: WrapAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: cashList
          .asMap()
          .entries
          .map((e) => GestureDetector(
                onTap: () {
                  int position = e.key; //position
                  setState(() {
                    index_pos = position;
                    secondBtn = e.value;
                  });

                  amtController.text = e.value;
                },
                child: Container(
                  width: 100.w,
                  height: 46.h,
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  margin: EdgeInsets.only(right: 16.w, bottom: 16.h),
                  decoration: BoxDecoration(
                      color: index_pos == e.key ? CustomColors.sPrimaryColor500 : const Color(0x40335EF7),
                      border: Border.all(color: index_pos == e.key ? Colors.transparent : const Color(0xffFAFAFA)),
                      borderRadius: BorderRadius.all(Radius.circular(8.r))),
                  child: FittedBox(
                      child: Text("₦${e.value.toString()}",
                          style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w700, color: CustomColors.sWhiteColor, fontFamily: "SemiPlusJakartaSans"))),
                ),
              ))
          .toList(),
    );
  }
}
