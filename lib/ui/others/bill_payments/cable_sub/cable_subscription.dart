import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/data_model.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/services/api_services.dart';
import 'package:spraay/ui/others/bill_payments/pin_for_bill_payment.dart';
import 'package:spraay/utils/contact-utils.dart';
import 'package:spraay/utils/my_sharedpref.dart';
import 'package:spraay/view_model/bill_payment_provider.dart';

class CableSubscriptionscreen extends StatefulWidget {
  String title;
  CableSubscriptionscreen({super.key, required this.title});
  // const CableSubscriptionscreen({Key? key}) : super(key: key);

  @override
  State<CableSubscriptionscreen> createState() => _CableSubscriptionscreenState();
}

class _CableSubscriptionscreenState extends State<CableSubscriptionscreen> {
  final GlobalKey<FormState> _myKey = GlobalKey<FormState>();

  TextEditingController amtController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  FocusNode? _textField1Focus;

  FocusNode? _textField2Focus;

  FocusNode? _textField3Focus;

  @override
  void initState() {
    setState(() {
      _textField1Focus = FocusNode();
      _textField2Focus = FocusNode();
      _textField3Focus = FocusNode();
    });
  }

  String firstBtn = "";

  String secondBtn = "";

  @override
  void dispose() {
    _textField1Focus?.dispose();
    _textField2Focus?.dispose();
    amtController.dispose();
    phoneController.dispose();
    _textField3Focus?.dispose();
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
        buildHorizontalContainer(),
        height20,
        buildDataPlan(),
        Text(
          secondBtn.isEmpty ? "" : "₦$secondBtn",
          style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400, fontFamily: "LightPlusJakartaSans"),
        ),
        height20,
        CustomizedTextField(
          textEditingController: phoneController,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          textInputAction: TextInputAction.next,
          hintTxt: "Enter IUC Number",
          focusNode: _textField1Focus,
          inputFormat: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            setState(() {
              firstBtn = value;
            });
          },
          surffixWidget: GestureDetector(
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
          ),
        ),
        height40,
        Center(
          child: CustomButton(
              onTap: () {
                if (firstBtn.isNotEmpty /*&& secondBtn.isNotEmpty*/) {
                  if (secondBtn.isEmpty) {
                    cherryToastInfo(context, "Info!", "Select provider and plan");
                  } else {
                    fetchCheckbalanceBeforeWithdrawingApiPinApi(context, amtController.text); //cableCode
                  }
                }
              },
              buttonText: 'Continue',
              borderRadius: 30.r,
              width: 380.w,
              buttonColor: (firstBtn.isNotEmpty && secondBtn.isNotEmpty) ? CustomColors.sPrimaryColor500 : CustomColors.sDisableButtonColor),
        ),
        height34,
      ],
    );
  }

  //dstv.png
  // List <String> cableList=["dstv","gotv","startimes"];

  int airtimePosition = -1;
  String imageAirtime = "";
  String cableCode = "";

  Widget buildHorizontalContainer() {
    return Center(
      child: Consumer<BillPaymentProvider>(builder: (context, dataProvider, widget) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setStates) {
          return Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: dataProvider.cableTvListList
                .asMap()
                .entries
                .map((e) => GestureDetector(
                      onTap: () {
                        setStates(() {
                          airtimePosition = e.key; //position
                          imageAirtime = e.value.name?.toLowerCase() ?? "";
                          cableCode = e.value.code ?? "";
                        });

                        fetchGetDataPlanListList(context, imageAirtime.replaceAll("_", "").toUpperCase(), setState, cableCode);
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 14.w, bottom: 40.h),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: airtimePosition == e.key ? CustomColors.sPrimaryColor500 : Colors.transparent, width: 5.r),
                          // borderRadius: BorderRadius.all(Radius.circular(8.r))
                        ),
                        child: Image.asset(
                          "images/${e.value.name?.toLowerCase()}.png",
                          width: 70.w,
                          height: 70.h,
                        ),
                      ),
                    ))
                .toList(),
          );
        });
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
          Text(title, style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0xffEEECFF))),
        ],
      ),
    );
  }

  bool _isLoading = false;

  fetchCheckbalanceBeforeWithdrawingApiPinApi(BuildContext context, String amount) async {
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
      if (context.mounted) {
        Navigator.push(
            context,
            SlideLeftRoute(
                page: PinForBillPayment(
                    title: widget.title,
                    image: imageAirtime,
                    amount: amount,
                    provider: imageAirtime.replaceAll("_", "").toUpperCase(),
                    phoneController: phoneController.text,
                    cableSubscriptionId: dataPlanId,
                    cableName: cableName,
                    cableCode: cableCode)));
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  DataPlan? dataPlan;

  List<DataPlan> getVDataPlans = [];

  bool loadingVplans = false;

  String dataPlanId = "";
  String cableName = "";
  fetchGetDataPlanListList(BuildContext context, String vendingCode, StateSetter setState, String cableCode) async {
    setState(() {
      loadingVplans = true;
    });
    var apiData = await apiResponse.findCablePlanByProvider(MySharedPreference.getToken(), cableCode);
    if (apiData.error == false) {
      setState(() {
        getVDataPlans = apiData.data?.data ?? [];
      });
    } else {
      setState(() {
        getVDataPlans = [];
      });
    }
    setState(() {
      loadingVplans = false;
    });
  }

  Widget buildDataPlan() {
    if (loadingVplans) {
      return CustomizedTextField(
        hintTxt: "Loading...",
        readOnly: true,
        focusNode: _textField3Focus,
      );
    } else if (getVDataPlans.isEmpty) {
      return CustomizedTextField(
        hintTxt: "No Plan",
        readOnly: true,
        focusNode: _textField3Focus,
      );
    } else {
      return DropdownButtonFormField<DataPlan>(
        iconEnabledColor: CustomColors.sDisableButtonColor,
        focusColor: CustomColors.sDarkColor2,
        dropdownColor: CustomColors.sDarkColor2,
        isDense: false,
        items: getVDataPlans.map((DataPlan value) {
          return DropdownMenuItem<DataPlan>(
            value: value,
            child: SizedBox(
                width: 290.w,
                child: Text(
                  value.name?.replaceAll("?", "") ?? "",
                  style: CustomTextStyle.kTxtRegular.copyWith(color: CustomColors.sWhiteColor, fontSize: 14.sp),
                )),
          );
        }).toList(),
        onChanged: (DataPlan? newValue) {
          dataPlan = newValue!;
          setState(() {
            amtController.text = newValue.price.toString() ?? "0.00";
            secondBtn = newValue.price.toString() ?? "0.00";
            dataPlanId = newValue.code.toString();
            cableName = newValue.name ?? "";
          });
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
          hintText: "Choose plan",
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
  }
}
