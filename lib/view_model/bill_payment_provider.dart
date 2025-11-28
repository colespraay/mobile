import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/models/airtime_topup_model.dart';
import 'package:spraay/models/betting_plan_model.dart';
import 'package:spraay/models/cable_tv_model.dart';
import 'package:spraay/models/game_model_data.dart';
import 'package:spraay/models/giftcard-model.dart';
import 'package:spraay/models/giftcard/fx-rate.dart';
import 'package:spraay/models/giftcard/gc-req.dart';
import 'package:spraay/models/giftcard/giftcard-categories.dart';
import 'package:spraay/models/giftcard/giftcard-country-response.dart';
import 'package:spraay/models/pre_post_model.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/services/api_services.dart';
import 'package:spraay/ui/dashboard/dashboard_screen.dart';
import 'package:spraay/ui/others/bill_payments/giftcard/giftcard-details.ui.dart';
import 'package:spraay/ui/others/payment_receipt.dart';
import 'package:spraay/utils/my_sharedpref.dart';
import 'package:spraay/view_model/auth_provider.dart';
import 'package:spraay/view_model/event_provider.dart';

class BillPaymentProvider extends ChangeNotifier {
  ApiServices service = ApiServices();
  String mytoken = MySharedPreference.getToken();

  // bool get loading => isLoading;
  bool loading = false;
  bool giftCardLoading = false;

  setGcLoading(bool v) async {
    giftCardLoading = v;
    notifyListeners();
  }

  setloading(bool load) async {
    loading = load;
    notifyListeners();
  }

  setloadingNoNotif(bool loadn) async {
    loading = loadn;
  }

  List<AirtimeTopUpDatum> airtimeTopUpList = [];
  fetchAirtimeTopUpList() async {
    setloadingNoNotif(true);
    var apiResponse = await service.airtimeDataTopUpApi(MySharedPreference.getToken());
    if (apiResponse.error == true) {
      airtimeTopUpList = [];
    } else {
      airtimeTopUpList = apiResponse.data?.data ?? [];
    }
    setloadingNoNotif(false);
    notifyListeners();
  }

  List<CableTvDatum> cableTvListList = [];
  fetchCableTvListList() async {
    setloadingNoNotif(true);
    var apiResponse = await service.cableTvModelApi(MySharedPreference.getToken());
    if (apiResponse.error == true) {
      cableTvListList = [];
    } else {
      cableTvListList = apiResponse.data?.data ?? [];
    }
    setloadingNoNotif(false);
    notifyListeners();
  }

  List<CableTvDatum> eletricityList = [];
  fetchEletricityProvidersApiList() async {
    setloadingNoNotif(true);
    var apiResponse = await service.eletricityProvidersApi(MySharedPreference.getToken());
    if (apiResponse.error == true) {
      eletricityList = [];
    } else {
      eletricityList = apiResponse.data?.data ?? [];
    }
    setloadingNoNotif(false);
    notifyListeners();
  }

  List<GameDatum> gameList = [];
  fetchGameProvidersApiList() async {
    setloadingNoNotif(true);
    var apiResponse = await service.gameProvidersApi(MySharedPreference.getToken());
    if (apiResponse.error == true) {
      gameList = [];
    } else {
      gameList = apiResponse.data?.data ?? [];
    }
    setloadingNoNotif(false);
    notifyListeners();
  }

  List<PrePostDatum> prePostList = [];
  fetchPrePostAPIList(String merchantPublicId) async {
    setloadingNoNotif(true);
    var apiResponse = await service.prePostApi(MySharedPreference.getToken(), merchantPublicId);
    if (apiResponse.error == true) {
      prePostList = [];
    } else {
      prePostList = apiResponse.data?.data ?? [];
    }
    setloadingNoNotif(false);
    notifyListeners();
  }

  List<BettingPlanDatum> bettingPlanList = [];
  fetchBettingPlanApiList(String merchantPublicId) async {
    setloadingNoNotif(true);
    var apiResponse = await service.bettingPlanApi(MySharedPreference.getToken(), merchantPublicId);
    if (apiResponse.error == true) {
      bettingPlanList = [];
    } else {
      bettingPlanList = apiResponse.data?.data ?? [];
    }
    setloadingNoNotif(false);
    notifyListeners();
  }

  fetchAirtimePurchaseApi(BuildContext context, String mytoken, String providerId, String phoneNumber, String amount, String transactionPin, String svg_img) async {
    setloading(true);
    var result = await service.airtimePurchaseApi(mytoken, providerId, phoneNumber, amount.replaceAll(",", ""), transactionPin);
    if (result['error'] == true) {
      if (context.mounted) {
        errorCherryToast(context, result['message']);
      }
    } else {
      if (context.mounted) {
        Provider.of<AuthProvider>(context, listen: false).fetchUserDetailApi();
        Provider.of<EventProvider>(context, listen: false).fetchTransactionListApi();

        popupWithTwoBtnDialog(
            context: context,
            title: "Top-up Successful",
            content: result["message"] /*"$phoneNumber has been credited with ₦${amount}"*/,
            buttonTxt: "Okay",
            onTap: () {
              Navigator.pushAndRemoveUntil(context, FadeRoute(page: const DasboardScreen()), (Route<dynamic> route) => false);
              Provider.of<AuthProvider>(context, listen: false).onItemTap(0);
            },
            png_img: "verified",
            btn2Txt: 'View Receipt',
            onTapBtn2: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);

              Navigator.pushReplacement(
                  context,
                  FadeRoute(
                      page: PaymentReceipt(
                    svg_img: svg_img,
                    type: result["message"],
                    date: result["dateCreated"],
                    amount: '₦$amount',
                    meterNumber: result["phoneNumber"],
                    transactionRef: result["transactionId"],
                    transStatus: 'Successful',
                    transactionId: '',
                  )));
            });
      }
    }
    setloading(false);
  }

  fetchelEctricityUnitPurchaseApi(
      BuildContext context, String mytoken, String service_provider, String phoneNumber, String amount, String transactionPin, String svg_img, String plan, String billerName) async {
    setloading(true);
    var result = await service.electricityUnitPurchaseApi(mytoken, service_provider, phoneNumber, amount.replaceAll(",", ""), transactionPin, plan, billerName);
    if (result['error'] == true) {
      if (context.mounted) {
        errorCherryToast(context, result['message']);
      }
    } else {
      if (context.mounted) {
        Provider.of<AuthProvider>(context, listen: false).fetchUserDetailApi();
        Provider.of<EventProvider>(context, listen: false).fetchTransactionListApi();

        popupWithTwoBtnDialog(
            context: context,
            title: "Top-up Successful",
            content: result["message"] /*"$phoneNumber has been credited with ₦${amount}"*/,
            buttonTxt: "Okay",
            onTap: () {
              Navigator.pushAndRemoveUntil(context, FadeRoute(page: const DasboardScreen()), (Route<dynamic> route) => false);
              Provider.of<AuthProvider>(context, listen: false).onItemTap(0);
            },
            png_img: "verified",
            btn2Txt: 'View Receipt',
            onTapBtn2: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);

              Navigator.pushReplacement(
                  context,
                  FadeRoute(
                      page: PaymentReceipt(
                    svg_img: svg_img,
                    type: result["message"],
                    date: result["dateCreated"],
                    amount: '₦$amount',
                    meterNumber: result["phoneNumber"],
                    transactionRef: result["transactionId"],
                    transStatus: 'Successful',
                    transactionId: '',
                  )));
            });
      }
    }
    setloading(false);
  }

  fetchelBetGamePurchaseApi(
      BuildContext context, String mytoken, String service_provider, String phoneNumber, String amount, String transactionPin, String svg_img, String plan, String billerName) async {
    setloading(true);
    var result = await service.betGamePurchaseApi(mytoken, service_provider, phoneNumber, amount.replaceAll(",", ""), transactionPin, plan, billerName);
    if (result['error'] == true) {
      if (context.mounted) {
        errorCherryToast(context, result['message']);
      }
    } else {
      if (context.mounted) {
        Provider.of<AuthProvider>(context, listen: false).fetchUserDetailApi();
        Provider.of<EventProvider>(context, listen: false).fetchTransactionListApi();

        popupWithTwoBtnDialog(
            context: context,
            title: "Top-up Successful",
            content: result["message"] /*"$phoneNumber has been credited with ₦${amount}"*/,
            buttonTxt: "Okay",
            onTap: () {
              Navigator.pushAndRemoveUntil(context, FadeRoute(page: const DasboardScreen()), (Route<dynamic> route) => false);
              Provider.of<AuthProvider>(context, listen: false).onItemTap(0);
            },
            png_img: "verified",
            btn2Txt: 'View Receipt',
            onTapBtn2: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);

              Navigator.pushReplacement(
                  context,
                  FadeRoute(
                      page: PaymentReceipt(
                    svg_img: svg_img,
                    type: result["message"],
                    date: result["dateCreated"],
                    amount: '₦$amount',
                    meterNumber: result["phoneNumber"],
                    transactionRef: result["transactionId"],
                    transStatus: 'Successful',
                    transactionId: '',
                  )));
            });
      }
    }
    setloading(false);
  }

  fetchDataPurchaseApi(
      BuildContext context, String mytoken, String service_provider, String phoneNumber, String amount, String transactionPin, String svg_img, String dataPlanId, String dataSubCode) async {
    setloading(true);
    var result = await service.dataPurchaseApi(mytoken, service_provider, phoneNumber, dataPlanId, transactionPin, dataSubCode);
    if (result['error'] == true) {
      if (context.mounted) {
        errorCherryToast(context, result['message']);
      }
    } else {
      if (context.mounted) {
        Provider.of<AuthProvider>(context, listen: false).fetchUserDetailApi();
        Provider.of<EventProvider>(context, listen: false).fetchTransactionListApi();

        popupWithTwoBtnDialog(
            context: context,
            title: "Top-up Successful",
            content: result["message"] /*"$phoneNumber has been credited with ₦${amount}"*/,
            buttonTxt: "Okay",
            onTap: () {
              Navigator.pushAndRemoveUntil(context, FadeRoute(page: const DasboardScreen()), (Route<dynamic> route) => false);
              Provider.of<AuthProvider>(context, listen: false).onItemTap(0);
            },
            png_img: "verified",
            btn2Txt: 'View Receipt',
            onTapBtn2: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);

              Navigator.pushReplacement(
                  context,
                  FadeRoute(
                      page: PaymentReceipt(
                    svg_img: svg_img,
                    type: result["message"],
                    date: result["dateCreated"],
                    amount: '₦$amount',
                    meterNumber: result["phoneNumber"],
                    transactionRef: result["transactionId"],
                    transStatus: 'Successful',
                    transactionId: '',
                  )));
            });
      }
    }
    setloading(false);
  }

  //cablePurchaseApi
  fetchCablePurchaseApi(
      BuildContext context, String mytoken, String service_provider, String phoneNumber, String amount, String transactionPin, String svg_img, String dataPlanId, String cableCode) async {
    setloading(true);
    var result = await service.cablePurchaseApi(mytoken, service_provider, phoneNumber, dataPlanId, transactionPin, amount, cableCode);
    if (result['error'] == true) {
      if (context.mounted) {
        errorCherryToast(context, result['message']);
      }
    } else {
      if (context.mounted) {
        Provider.of<AuthProvider>(context, listen: false).fetchUserDetailApi();
        Provider.of<EventProvider>(context, listen: false).fetchTransactionListApi();

        popupWithTwoBtnDialog(
            context: context,
            title: "Top-up Successful",
            content: result["message"] /*"$phoneNumber has been credited with ₦${amount}"*/,
            buttonTxt: "Okay",
            onTap: () {
              Navigator.pushAndRemoveUntil(context, FadeRoute(page: const DasboardScreen()), (Route<dynamic> route) => false);
              Provider.of<AuthProvider>(context, listen: false).onItemTap(0);
            },
            png_img: "verified",
            btn2Txt: 'View Receipt',
            onTapBtn2: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);

              Navigator.pushReplacement(
                  context,
                  FadeRoute(
                      page: PaymentReceipt(
                    svg_img: svg_img,
                    type: result["message"],
                    date: result["dateCreated"],
                    amount: '₦$amount',
                    meterNumber: result["phoneNumber"],
                    transactionRef: result["transactionId"],
                    transStatus: 'Successful',
                    transactionId: '',
                    cableSubscriptionId: dataPlanId,
                  )));
            });
      }
    }
    setloading(false);
  }

  ///Gift Card
  GiftCardCountry? selectedGiftCardCountry;
  ValueNotifier<GiftCardCategories?> selectedGiftCardCategory = ValueNotifier(null);
  ValueNotifier<List<GiftCardCategories>> giftCardCategories = ValueNotifier([]);
  ValueNotifier<List<GiftCardCountry>> giftCardCountries = ValueNotifier([]);
  ValueNotifier<List<SingleGiftCardModel>> giftCards = ValueNotifier([]);

  fetchGiftCardCategories() async {
    setloadingNoNotif(true);
    var apiResponse = await service.getGiftCardCategories();
    if (apiResponse.error == true) {
      giftCardCategories.value = [];
    } else {
      giftCardCategories.value = [];
      (apiResponse.data?.data ?? []).forEach((e) {
        giftCardCategories.value.add(GiftCardCategories.fromJson(e));
      });
    }
    setloadingNoNotif(false);
    notifyListeners();
  }

  fetchGiftCardCountries() async {
    setloadingNoNotif(true);
    var apiResponse = await service.getGiftCountries();
    if (apiResponse.error == true) {
      print('error:${apiResponse.errorMessage}');
      giftCardCountries.value = [];
    } else {
      giftCardCountries.value = [];
      (apiResponse.data?.data ?? []).forEach((e) {
        giftCardCountries.value.add(GiftCardCountry.fromJson(e));
      });

      selectedGiftCardCountry = giftCardCountries.value.firstWhere((c) => c.isoName == "US");
    }
    setloadingNoNotif(false);
    notifyListeners();
  }

  fetchGiftCardsByCountry({bool showLoading = false}) async {
    showLoading ? setloading(true) : setloadingNoNotif(true);
    var apiResponse = await service.getCardByCountry(selectedGiftCardCountry?.isoName ?? "US");
    if (apiResponse.error == true) {
      print('error:${apiResponse.errorMessage}');
      giftCards.value = [];
    } else {
      giftCards.value = [];
      (apiResponse.data?.data ?? []).forEach((e) {
        giftCards.value.add(SingleGiftCardModel.fromJson(e));
      });
    }
    showLoading ? setloading(false) : setloadingNoNotif(false);
    notifyListeners();
  }

  fetchGiftCardsByCategories() async {
    setGcLoading(true);
    var apiResponse = await service.getCardByCategory(selectedGiftCardCountry?.isoName ?? "", selectedGiftCardCategory.value?.name ?? "");
    if (apiResponse.error == true) {
      print('error:${apiResponse.errorMessage}');
      giftCards.value = [];
    } else {
      giftCards.value = [];
      (apiResponse.data?.data ?? []).forEach((e) {
        giftCards.value.add(SingleGiftCardModel.fromJson(e));
      });
    }
    setGcLoading(false);
    notifyListeners();
  }

  String? giftCardQuery;
  fetchGiftCardsBySearch() async {
    setGcLoading(true);
    var apiResponse = await service.searchGiftCard(selectedGiftCardCountry?.isoName ?? "", giftCardQuery ?? "");
    if (apiResponse.error == true) {
      print('error:${apiResponse.errorMessage}');
      giftCards.value = [];
    } else {
      giftCards.value = [];
      (apiResponse.data?.data['data'] ?? []).forEach((e) {
        giftCards.value.add(SingleGiftCardModel.fromJson(e));
      });
    }
    setGcLoading(false);
    notifyListeners();
  }

  num quantity = 0;
  GCFxRate? giftCardRate;
  final TextEditingController youPayController = TextEditingController();
  final TextEditingController customPriceController = TextEditingController();
  num? selectedPrice;
  SingleGiftCardModel? giftCardModel;
  getFxRate(String recipientCurrencyCode, num amount) async {
    setGcLoading(true);
    var apiResponse = await service.getFxRate(recipientCurrencyCode, amount);
    if (apiResponse.error == true) {
    } else {
      giftCardRate = GCFxRate.fromJson(apiResponse.data?.data);
    }
    selectedPrice = 0;
    youPayController.text = 0.toString();
    quantity = 0;

    setGcLoading(false);
    notifyListeners();
  }

  void setQuery(String value) {
    giftCardQuery = value;
    notifyListeners();
  }

  num get totalAmount => (giftCardRate?.senderAmount ?? 0) * ((quantity) * (selectedPrice ?? 0));
  setGiftCardQuantity(String value) {
    quantity = num.tryParse(value) ?? 0;
    youPayController.text = ("₦${totalAmount.toString()}");
    notifyListeners();
  }

  void setSelectedPrice(num price) {
    selectedPrice = price;
    youPayController.text = ("₦${totalAmount.toString()}");
    notifyListeners();
  }

  purchaseGiftCard(BuildContext context, String transactionPin) async {
    setloading(true);
    try {
      var result = await service.purchaseGiftCard(GiftCardReq(
          quantity: quantity,
          productId: giftCardModel?.productId,
          recipientEmail: MySharedPreference.getEmail().toLowerCase(),
          transactionPin: transactionPin,
          senderName: '${MySharedPreference.getFname()} ${MySharedPreference.getLastname()}',
          unitPrice: selectedPrice,
          userid: MySharedPreference.getUId(),
          preOrder: true,
          customIdentifier: ''));

      if (result.error == true) {
        if (context.mounted) {
          popupDialogFailedResponse(context, error: result.errorMessage);
        }
      } else {
        if (context.mounted) {
          Provider.of<AuthProvider>(context, listen: false).fetchUserDetailApi();
          Provider.of<EventProvider>(context, listen: false).fetchTransactionListApi();

          popupWithTwoBtnDialog(
              context: context,
              title: "Transaction successful",
              content: "You will receive an Email containing your giftcard details",
              buttonTxt: "Great! Take me Home",
              onTap: () {
                Navigator.pushAndRemoveUntil(context, FadeRoute(page: const DasboardScreen()), (Route<dynamic> route) => false);
                Provider.of<AuthProvider>(context, listen: false).onItemTap(0);
              },
              png_img: "verified",
              btn2Txt: 'View Receipt',
              onTapBtn2: () {
                Navigator.pop(context);
                Navigator.pop(context);

                Navigator.pushReplacement(
                    context,
                    FadeRoute(
                        page: PaymentReceipt(
                      svg_img: "spray_circle",
                      type: "Spray Gift Card",
                      date: DateTime.now().toString(), //dateTimeFormat(DateTime.now().toIso8601String().toString()),
                      amount: totalAmount.toString(),
                      meterNumber: '',
                      transactionRef: '',
                      transStatus: 'Successful',
                      transactionId: '',
                    )));
              });
        }
      }
      setloading(false);
    } catch (e, s) {
      print(e.toString());
      print(s.toString());
    }
  }
}
