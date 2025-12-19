import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/models/crypto-data.dart';
import 'package:spraay/models/crypto-history.dart' hide Wallet;
import 'package:spraay/models/crypto-network-model.dart';
import 'package:spraay/models/graph-model.dart';
import 'package:spraay/models/loading-states.dart';
import 'package:spraay/models/quote-currency.dart';
import 'package:spraay/models/result-model.dart';
import 'package:spraay/models/transaction-fee-usd-value.dart';
import 'package:spraay/models/transaction-fees.dart';
import 'package:spraay/models/user_profile.dart';
import 'package:spraay/models/wallets-response.dart';
import 'package:spraay/services/api_services.dart';
import 'package:spraay/ui/crypto/crypto.ui.dart';
import 'package:spraay/utils/my_sharedpref.dart';
import 'package:spraay/utils/secure_storage.dart';

class CryptoProvider extends ChangeNotifier {
  //routing page for bottom nav
  int selectedIndex = 0;
  void onItemTap(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  bool get loading => isLoading;
  setloading(bool loading, {bool isError = false}) async {
    isLoading = loading;
    if (loading) {
      state = LoadState.loading;
    } else {
      if (isError) {
        state = LoadState.error;
      } else {
        state = LoadState.success;
      }
    }
    notifyListeners();
  }

  setloadingNoNotif(bool loading) async {
    isLoading = loading;
  }

  //Inactivity Session timeout
  final sessionStateStream = StreamController<SessionState>();

  // bool sWvalueFaceId = false;
  bool? value = MySharedPreference.getSwitchValuesForTouchID() == null ? false : MySharedPreference.getSwitchValuesForTouchID();
  void changeSwitch(bool myvalue) {
    value = myvalue;
    notifyListeners();
  }

  ApiServices service = ApiServices();
  String mytoken = MySharedPreference.getToken();
  DataResponse? dataResponse;
  fetchUserDetailApi() async {
    setloadingNoNotif(true);
    var apiResponse = await service.userDetailApi(mytoken, MySharedPreference.getUId());
    if (apiResponse.error == true) {
      log("UserDetailApi:${apiResponse.errorMessage}");
      // errorCherryToast(context, apiResponse.errorMessage??"");
    } else {
      dataResponse = apiResponse.data?.data;
      await MySharedPreference.saveWalletBalance(apiResponse.data?.data?.walletBalance.toString() ?? "");
      if (dataResponse?.bvn != null) {
        await SecureStorage().saveVn(dataResponse?.bvn);

        await MySharedPreference.saveVAccName(dataResponse?.virtualAccountName.toString() ?? "");
        await MySharedPreference.saveVAccNumber(dataResponse?.virtualAccountNumber.toString() ?? "");
        await MySharedPreference.saveVBankName(dataResponse?.bankName.toString() ?? "");
      }
    }
    setloadingNoNotif(false);
    notifyListeners();
  }

  fetchuploadImageUrl(context, String profileImageUrl, String userId) async {
    setloading(true);
    var result = await apiResponse.uploadImageUrl(profileImageUrl, userId);
    if (result['error'] == true) {
      errorCherryToast(context, result['message']);
    } else {
      fetchUserDetailApi();
    }
    setloading(false);
  }

  fetchUploadFile(context, File image, String filename) async {
    setloading(true);
    var result = await apiResponse.uploadFile(image, filename);
    if (result['error'] == true) {
      errorCherryToast(context, result['message']);
    } else {
      fetchuploadImageUrl(context, result['file_url'], MySharedPreference.getUId());
    }
    setloading(false);
  }

  Future<String?> uploadFile(context, File image, String filename) async {
    setloading(true);
    var result = await apiResponse.uploadFile(image, filename);
    print(result.toString());
    if (result['error'] == true) {
      errorCherryToast(context, result['message']);
      setloading(false);
      return null;
    } else {
      setloading(false);
      return result['file_url'];
    }
    return null;
  }

  List<Wallet> wallets = [];
  Future getUserWallets(context) async {
    setloading(true);
    ResModel result = await cryptoServices.getCryptoAssets(data: {});
    if (result.success == true) {
      setloading(false);
      wallets = [];
      result.data['data'].forEach((e) {
        if (
            // e['currency'] != "ngn" &&
            e['currency'] != "usd") {
          wallets.add(Wallet.fromJson(e));
        }
      });
      notifyListeners();
    } else {
      setloading(false);
      errorCherryToast(context, result.message ?? "Something went wrong");
    }
  }

  CryptoData? cryptoData;
  getCurrencyDetails(context, String currency) async {
    setloading(true);
    ResModel result = await cryptoServices.getCurrencyDetails(currency: currency);
    if (result.success == true) {
      print('hii');
      setloading(false);
      cryptoData = null;
      cryptoData = CryptoData.fromJson(result.data['data']);
      notifyListeners();
    } else {
      print('haha');
      setloading(false);
      errorCherryToast(context, result.message ?? "Something went wrong");
    }
  }

  NetworkFeeData? networkFeeData;
  getTransactionFeesUSDValue(context, String currency, String ticker, {bool isBuy = true, Function()? onDone}) async {
    setloading(true);
    ResModel result = await cryptoServices.getTransactionFeesUSDValue(currency: currency, tickerPair: ticker, isBuy: isBuy);
    if (result.success == true) {
      setloading(false);
      networkFeeData = null;
      networkFeeData = NetworkFeeData.fromJson(result.data['data']);
      notifyListeners();
      if (onDone != null) {
        onDone();
      }
    } else {
      setloading(false);
      errorCherryToast(context, result.message ?? "Something went wrong");
    }
  }

  List<PriceData> assetGraphs = [];
  LoadState state = LoadState.idle;

  getTickers(context, {required ChartInterval interval, DateTime? date, required String market}) async {
    setloading(true);
    ResModel result = await cryptoServices.getAssetGraph(currency: market, queryParams: {
      "date": getDate(date: date),
      "period": interval.minutes.toString(),
      "limit": 50.toString(),
    });
    if (result.success == true) {
      assetGraphs = [];
      result.data['data'].forEach((e) {
        if (e != null) {
          assetGraphs.add(PriceData.fromJson(e));
        }
      });
      notifyListeners();
      setloading(false);
    } else {
      setloading(false);
      errorCherryToast(context, result.message ?? "Something went wrong");
    }
  }

  void buyCrypto(BuildContext context, {required Function(GeneralTransaction?) onDone, num? amount, String? currency}) async {
    setloading(true);
    ResModel result = await cryptoServices.buyCrypto(data: {
      "amount": amount.toString(),
      "currency": currency,
      "userId": MySharedPreference.getUId(),
      "frequency": "string",
    });

    if (result.success == true) {
      notifyListeners();
      await getTransactions(context, currency!);

      onDone(transactions[0]);
      setloading(false);
    } else {
      setloading(false);
      errorCherryToast(context, result.message ?? "Something went wrong");
    }
  }

  bool get hasAddress => sellCryptoAddress != null && sellCryptoAddress!.isNotEmpty;
  String? sellCryptoAddress;
  updateAddress(String v) {
    sellCryptoAddress = v;
    notifyListeners();
  }

  void sellCrypto(BuildContext context, {required Function(GeneralTransaction?) onDone, num? amount, String? currency, String? fundId}) async {
    setloading(true);
    ResModel result = await cryptoServices.sendCrypto(data: {
      "amount": amount.toString(),
      "currency": currency,
      "userId": MySharedPreference.getQuidaxUserId(),
      "fund_uid": fundId,
    });
    if (result.success == true) {
      await getTransactions(context, currency!);

      onDone(transactions[0]);
      notifyListeners();
      setloading(false);
    } else {
      setloading(false);
      errorCherryToast(context, result.message ?? "Something went wrong");
    }
  }

  List<GeneralTransaction> transactions = [];
  Future getTransactions(BuildContext context, String currency) async {
    setloading(true);
    ResModel result = await cryptoServices.getTransaction(currency);
    if (result.success == true) {
      transactions = CryptoTransactionResponse.fromJson(result.data).allTransactions;
      print(transactions.length);

      notifyListeners();
      setloading(false);
    } else {
      setloading(false);
      errorCherryToast(context, result.message ?? "Something went wrong");
    }
  }

  void sendCrypto(BuildContext context, {required Function() onDone, num? amount, String? currency}) async {
    setloading(true);
    ResModel result = await cryptoServices.sellCrypto(data: {
      "amount": amount,
      "currency": currency,
      "userId": MySharedPreference.getQuidaxUserId(),
      "frequency": "string",
    });
    if (result.success == true) {
      onDone();
      notifyListeners();
      setloading(false);
    } else {
      setloading(false);
      errorCherryToast(context, result.message ?? "Something went wrong");
    }
  }

  List<MarketData> marketData = [];
  Future getMarketSummaryWithWatchlist(BuildContext context) async {
    setloading(true);
    ResModel result = await cryptoServices.getMarketSummaryWithWatchlist();
    if (result.success == true) {
      marketData = [];
      result.data['data'].forEach((e) {
        if (e != null) {
          marketData.add(MarketData.fromJson(e));
        }
      });

      notifyListeners();
      setloading(false);
    } else {
      setloading(false);
      errorCherryToast(context, result.message ?? "Something went wrong");
    }
  }

  bool _isFetchingSwap = false;

  bool get isFetchingSwap => _isFetchingSwap;

  set isFetchingSwap(bool value) {
    _isFetchingSwap = value;
    notifyListeners();
  }

  SwapQuotationData? swapQuotationData;
  Future getSwapQuotation(BuildContext context, {String? from, String? to, String? amount}) async {
    if (from == to) {
      errorCherryToast(context, "Please select different assets");
      return;
    }
    isFetchingSwap = (true);
    ResModel result = await cryptoServices.getSwapQuotation(data: {
      "quidax_userId": MySharedPreference.getQuidaxUserId(),
      "from_currency": from,
      "to_currency": to,
      "from_amount": amount,
    });
    if (result.success == true) {
      swapQuotationData = SwapQuotationData.fromJson(result.data['data']);
      notifyListeners();
      isFetchingSwap = (false);
    } else {
      isFetchingSwap = (false);
      errorCherryToast(context, result.message ?? "Something went wrong");
    }
  }

  Future confirmQuote(BuildContext context, {required Function(GeneralTransaction?) onDone, String? currency, String? amount, String? to, String? from}) async {
    setloading(true);
    ResModel result = await cryptoServices
        .confirmSwapQuotation(data: {"quidax_userId": MySharedPreference.getQuidaxUserId(), "swapId": swapQuotationData?.id, "amount": amount, "toCurrency": to, "fromCurrency": from});
    if (result.success == true) {
      notifyListeners();
      final generalTx = mapSwapQuotationToGeneralTransaction(result.data['data']);
      onDone(generalTx);
      setloading(false);
    } else {
      setloading(false);
      errorCherryToast(context, result.message ?? "Something went wrong");
    }
  }

  TransactionFeesData? transactionFeesData;
  num get sellNetworkFee => (transactionFeesData?.cryptoWithdrawalFee?.value ?? 0) * (networkFeeData?.usdValue ?? 0);
  num get networkFee => (transactionFeesData?.depositFee?.value ?? 0) * (networkFeeData?.usdValue ?? 0);
  num get sprayFee => (transactionFeesData?.spraayFee?.value ?? 0);
  num get coinConversionAmount => displayAmount; //conversionAmount(cryptoData?.ticker?.buyAmount ?? 0, displayAmount);
  num displayAmount = 0;
  setDisplayAmount(num v) {
    displayAmount = v;
    notifyListeners();
    print('set $v $displayAmount');
  }

  num get allTotal => networkFee + sprayFee + coinConversionAmount;
  Future getFees(BuildContext context) async {
    setloading(true);
    ResModel result = await cryptoServices.getTransactionFees();
    if (result.success == true) {
      transactionFeesData = TransactionFeesData.fromJson(result.data['data']);
      notifyListeners();
      setloading(false);
    } else {
      setloading(false);
      errorCherryToast(context, result.message ?? "Something went wrong");
    }
  }

  List<CAsset> convertWalletsToCAssets(List<Wallet>? wallets) {
    List<String> swapAssets = ['usdt', 'btc', 'eth', 'ltc', 'bch'];
    if (wallets == null || wallets.isEmpty) {
      return [];
    }
    // Usdt
    // Bitcoin
    // Eth
    // Litecoin
    // Bitcoin cash

    //swapAssets.contains(item.currency)

    return wallets.
        // where((e) => swapAssets.contains(e.currency?.toLowerCase())).
        map((item) {
      return CAsset(
        name: item.name,
        nairaPrice: item.balance,
        icon: item.imageUrl,
        sub: item.currency,
      );
    }).toList();
  }

  List<CAsset> convertMarketDataToCAssets(List<MarketData>? marketDataList) {
    if (marketDataList == null || marketDataList.isEmpty) {
      return [];
    }

    return marketDataList.map((item) {
      return CAsset(
        name: item.coinName,
        nairaPrice: "0", // Default value as shown in your example
        icon: item.logo,
        sub: item.baseCoin,
      );
    }).toList();
  }

  List<CAsset> get toWallets => convertMarketDataToCAssets(marketData);
  List<CAsset> get fromWallets => convertWalletsToCAssets(wallets);

  void resetSwapData() {
    swapQuotationData = null;
    notifyListeners();
  }

  List<CryptoNetwork> networks = [];

  CryptoNetwork? selectedNetwork;
  setSelectedNetwork(CryptoNetwork c) {
    selectedNetwork = c;
    notifyListeners();
  }

  Future getReceiveCryptoNetworks(BuildContext context, String? currency) async {
    setloading(true);
    ResModel result = await cryptoServices.getAssetNetworks(currency: currency);
    if (result.success == true) {
      networks = [];
      result.data['data'].forEach((e) {
        networks.add(CryptoNetwork.fromJson(e));
      });
      setSelectedNetwork(networks[0]);
      notifyListeners();
      setloading(false);
    } else {
      setloading(false);
      errorCherryToast(context, result.message ?? "Something went wrong");
    }
  }
}

getDate({DateTime? date}) {
  date ??= DateTime(2024, 1, 1, 0, 0, 0);
  return date.toUtc().toIso8601String();
}

enum ChartInterval {
  oneMin(1, "1M"),
  fiveMin(5, "5M"),
  fifteenMin(15, "15M"),
  thirtyMin(30, "30M"),
  oneHour(60, "1H"),
  twoHours(120, "2H"),
  fourHours(240, "4H"),
  sixHours(360, "6H"),
  twelveHours(720, "12H"),
  oneDay(1440, "1D"),
  threeDays(4320, "3D");

  final int minutes;
  final String label;

  const ChartInterval(this.minutes, this.label);
}

num conversionAmount(num btcPriceInNgn, num ngnAmount) {
  if (btcPriceInNgn <= 0) return 0; // avoid division by zero
  final result = ngnAmount / btcPriceInNgn;
  return num.parse(result.toStringAsFixed(6));
}

final NumberFormat moneyFormatter = NumberFormat.decimalPattern('en_NG');

extension on String {
  get toNum => num.tryParse(this ?? "0") ?? 0;
}

num convertToNum(String? v) {
  return num.tryParse(v ?? "0") ?? 0;
}

String obscureString({required String input, required int firstDigits, required int lastDigits, String obscureChar = '.'}) {
  // Handle null or empty input
  if (input.isEmpty) return input;

  // If the string is shorter than the total digits we want to show, return as is
  if (input.length <= firstDigits + lastDigits) {
    return input;
  }

  // Get the first digits
  final firstPart = input.substring(0, firstDigits);

  // Get the last digits
  final lastPart = input.substring(input.length - lastDigits);

  // Create the obscured middle part
  final middlePart = obscureChar * 4; //(input.length - firstDigits - lastDigits);

  return '$firstPart$middlePart$lastPart';
}

// With success feedback
Future<void> copyToClipboardWithFeedback(String text, {String? successMessage}) async {
  await Clipboard.setData(ClipboardData(text: text));

  if (successMessage != null) {
    toastMessage(successMessage);
  }
}
