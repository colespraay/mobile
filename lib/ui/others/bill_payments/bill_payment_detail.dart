import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/cable_tv_model.dart';
import 'package:spraay/models/pre_post_model.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/services/api_services.dart';
import 'package:spraay/ui/others/bill_payments/pin_for_bill_payment.dart';
import 'package:spraay/utils/contact-utils.dart';
import 'package:spraay/utils/my_sharedpref.dart';
import 'package:spraay/view_model/bill_payment_provider.dart';

class PayBilDetail extends StatefulWidget {
  String title;
  PayBilDetail({super.key, required this.title});

  @override
  State<PayBilDetail> createState() => _PayBilDetailState();
}

class _PayBilDetailState extends State<PayBilDetail> {
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

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayWidget(
      loading: _isLoading,
      child: Scaffold(
          appBar: buildAppBar(context: context, title: widget.title),
          body: Form(
            key: _myKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: buildInviWidget(),
          )),
    );
  }

  Widget buildInviWidget() {
    return ListView(
      padding: horizontalPadding,
      shrinkWrap: true,
      children: [
        height45,
        widget.title == "Airtime Top-up" ? buildHorizontalContainer() : buildElectricityDropDown(),
        height20,
        widget.title != "Airtime Top-up" ? _buildPostPaidWidget() : Container(),
        height20,
        CustomizedTextField(
          textEditingController: phoneController,
          keyboardType: TextInputType.phone,
          maxLength: 11,
          textInputAction: TextInputAction.next,
          hintTxt: widget.title == "Airtime Top-up" ? "Enter Phone Number" : "Meter Number",
          focusNode: _textField1Focus,
          inputFormat: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            setState(() {
              firstBtn = value;
            });
          },
          surffixWidget: widget.title == "Airtime Top-up"
              ? GestureDetector(
                  onTap: () async {
                    //TODO: replace this contact picker
                    // final PhoneContact contact = await FlutterContactPicker.pickPhoneContact();
                    // setState(() {
                    //   phoneController.text = contact.phoneNumber?.number?.trim().replaceAll("+234", "0").replaceAll(" ", "").replaceAll("-", "")??"";
                    //   firstBtn=phoneController.text;
                    // });
                    openContactPicker(
                        context: context,
                        function: (c) {
                          phoneController.text = c;
                          firstBtn = phoneController.text;
                        });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: SvgPicture.asset("images/contact_profile.svg"),
                  ),
                )
              : const SizedBox.shrink(),
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
                  if (airtimePosition < 0) {
                    cherryToastInfo(context, "Info!", "Select provider");
                  } else {
                    fetchCheckbalanceBeforeWithdrawingApiPinApi(context, amtController.text, airtimeDataCode);
                  }
                }
              },
              buttonText: 'Continue',
              borderRadius: 30.r,
              width: 380.w,
              buttonColor: (firstBtn.isNotEmpty && secondBtn.isNotEmpty && airtimePosition > -1) ? CustomColors.sPrimaryColor500 : CustomColors.sDisableButtonColor),
        ),
        height34,
      ],
    );
  }

  // List <String> cableList=["mtn","9_mobile","airtel","glo"];
  int airtimePosition = -1;
  String imageAirtime = "";
  String airtimeDataCode = "";
  Widget buildHorizontalContainer() {
    return Center(
      child: Consumer<BillPaymentProvider>(builder: (context, dataProvider, widget) {
        return Wrap(
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: dataProvider.airtimeTopUpList
              .asMap()
              .entries
              .map((e) => GestureDetector(
                    onTap: () {
                      setState(() {
                        airtimePosition = e.key; //position
                        imageAirtime = e.value.name == "9Mobile" ? "9_mobile" : e.value.name!.toLowerCase();
                        airtimeDataCode = e.value.code ?? "";
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 14.w, bottom: 40.h),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: airtimePosition == e.key ? CustomColors.sPrimaryColor500 : Colors.transparent, width: 5.r),
                        // borderRadius: BorderRadius.all(Radius.circular(8.r))
                      ),
                      child: SvgPicture.asset(
                        "images/${e.value.name == "9Mobile" ? "9_mobile" : e.value.name!.toLowerCase()}.svg",
                        width: 70.w,
                        height: 70.h,
                      ),
                    ),
                  ))
              .toList(),
        );
      }),
    );
  }

  Widget buildDateAndLocContainer({required String img, required String title}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(color: CustomColors.sDarkColor3, borderRadius: BorderRadius.all(Radius.circular(4.r))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "images/$img.svg",
            width: 20.w,
            height: 20.h,
          ),
          SizedBox(
            width: 4.w,
          ),
          Text(title, style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500, color: const Color(0xffEEECFF))),
        ],
      ),
    );
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

  bool _isLoading = false;
  fetchCheckbalanceBeforeWithdrawingApiPinApi(BuildContext context, String amount, String airtimeDataCode) async {
    setState(() {
      _isLoading = true;
    });
    var result = await ApiServices().checkbalanceBeforeWithdrawingApi(MySharedPreference.getToken(), amount.replaceAll(",", ""));
    if (result['error'] == true) {
      if (context.mounted) {
        popupDialog(
            context: context,
            title: "Transaction Failed",
            content: result['message'],
            buttonTxt: 'Try again',
            onTap: () {
              Navigator.pop(context);
            },
            png_img: 'Incorrect_sign');
      }
    } else {
      if (context.mounted && widget.title == "Electricity") {
        //call API
        if (shortPrePaidCode.isEmpty) {
          toastMessage("Select Electricity Plan");
        } else {
          fetchverifyElectricityUnitPurchaseApi(context, electricityProvider, phoneController.text, amount, shortPrePaidCode);
        }
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
                    airtimeDataCode: airtimeDataCode)));
      }
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
      if (context.mounted) {
        popupDialog(
            context: context,
            title: "Transaction Failed",
            content: result['message'],
            buttonTxt: 'Try again',
            onTap: () {
              Navigator.pop(context);
            },
            png_img: 'Incorrect_sign');
      }
    } else {
      if (context.mounted) {
        //call API
        Navigator.push(
            context,
            SlideLeftRoute(
                page: PinForBillPayment(
              title: widget.title,
              image: imageAirtime,
              amount: amount,
              provider: imageAirtime.replaceAll("_", "").toUpperCase(),
              phoneController: phoneController.text,
              electricityProvider: provider,
              billerName: result["billerName"],
              plan: plan,
              electricUserName: result["name"],
            )));
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  String electricityProvider = "";
  String displayNameElectricity = '';
  Widget buildElectricityDropDown() {
    return Consumer<BillPaymentProvider>(builder: (context, dataProvider, widget) {
      return DropdownButtonFormField<CableTvDatum>(
        iconEnabledColor: CustomColors.sDisableButtonColor,
        focusColor: CustomColors.sDarkColor2,
        dropdownColor: CustomColors.sDarkColor2,
        isDense: false,
        items: dataProvider.eletricityList.map((CableTvDatum value) {
          return DropdownMenuItem<CableTvDatum>(
            value: value,
            child: SizedBox(
                width: 290.w,
                child: Text(
                  value.displayName ?? "",
                  style: CustomTextStyle.kTxtRegular.copyWith(color: CustomColors.sWhiteColor, fontSize: 14.sp),
                )),
          );
        }).toList(),
        onChanged: (CableTvDatum? newValue) {
          setState(() {
            airtimePosition = 0; //position
            imageAirtime = "ekedc";
            electricityProvider = newValue?.code ?? "";
            displayNameElectricity = newValue?.displayName ?? "";
          });

          Provider.of<BillPaymentProvider>(context, listen: false).fetchPrePostAPIList(electricityProvider);
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
          hintText: "Choose electricity plan",
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

  String shortPrePaidCode = "";
  Widget _buildPostPaidWidget() {
    return Consumer<BillPaymentProvider>(builder: (context, packageData, widget) {
      if (packageData.loading) {
        return Center(child: Text("Loading...", style: CustomTextStyle.kTxtRegular.copyWith(color: CustomColors.sWhiteColor, fontSize: 14.sp)));
      } else if (packageData.prePostList.isEmpty) {
        return const SizedBox.shrink();
      } else {
        return DropdownButtonFormField<PrePostDatum>(
          iconEnabledColor: CustomColors.sDisableButtonColor,
          focusColor: CustomColors.sDarkColor2,
          dropdownColor: CustomColors.sDarkColor2,
          isDense: false,
          items: packageData.prePostList.map((PrePostDatum value) {
            return DropdownMenuItem<PrePostDatum>(
              value: value,
              child: SizedBox(
                  width: 290.w,
                  child: Text(
                    value.name ?? "",
                    style: CustomTextStyle.kTxtRegular.copyWith(color: CustomColors.sWhiteColor, fontSize: 14.sp),
                  )),
            );
          }).toList(),
          onChanged: (PrePostDatum? newValue) {
            setState(() {
              // shortPrePaidCode="MY004";

              shortPrePaidCode = newValue?.shortCode ?? "";
              // airtimePosition = 0;//position
              // imageAirtime="ekedc";
              // electricityProvider=newValue?.code??"";
              // displayNameElectricity=newValue?.displayName??"";
            });
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
            hintText: "Choose paid plan",
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
}
