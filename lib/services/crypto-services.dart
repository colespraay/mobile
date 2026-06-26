import 'dart:convert' as convert;
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/models/result-model.dart';
import 'package:spraay/utils/logger.dart';
import 'package:spraay/utils/my_sharedpref.dart';
import 'package:spraay/utils/uri-utils.dart';

class CryptoServices {
  final String url;
  final http.Client _client;
  final Logger _logger;

  CryptoServices({
    this.url = "$baseUrl/",
    http.Client? client,
    Logger? logger,
  })  : _logger = logger ?? Logger(level: Level.debug),
        _client = client ?? HttpLogger().createLoggingClient();

  Future<ResModel> getCryptoAssets({required Map<String, dynamic> data, String? path}) async {
    String? token = MySharedPreference.getToken();
    ResModel result = ResModel();
    var id = MySharedPreference.getQuidaxUserId();

    print(id);
    try {
      var response = await http.get(Uri.parse("${url}crypto/$id/wallets"), headers: getHeaders()).timeout(const Duration(seconds: 30));
      printWrapped(response.headers.toString());

      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse["code"] == 200) {
        // var loginResponse = LoginResponse.fromJson(jsonResponse);
        return ResModel(data: jsonResponse, success: true, message: "Success");
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        print(response.body);
        result = ResModel(success: false, message: jsonResponse['message'], error: jsonResponse['message'], status: false);
      }
    } on HttpException {
      result = ResModel(success: false, message: "Error in network connection", error: "Error in network connection", status: false);
    } on SocketException {
      result = ResModel(success: false, message: "Error in network connection", error: "Error in network connection", status: false);
    } on FormatException {
      result = ResModel(success: false, message: "invalid format", error: "invalid format", status: false);
    } catch (e) {
      result = ResModel(success: false, message: "Something went wrong", error: "Something went wrong", status: false);
    }
    return result;
  }

  Future<ResModel> getMarketSummaryWithWatchlist() async {
    ResModel result = ResModel();
    var id = MySharedPreference.getQuidaxUserId();
    try {
      var response = await http.get(Uri.parse("${url}crypto/quidax/detailed/market-summary/$id"), headers: getHeaders()).timeout(const Duration(seconds: 30));
      printWrapped(response.body);
      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse["code"] == 200) {
        return ResModel(data: jsonResponse, success: true, message: "Success");
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result = ResModel(success: false, message: jsonResponse['message'], error: jsonResponse['message'], status: false);
      }
    } on HttpException {
      result = ResModel(success: false, message: "Error in network connection", error: "Error in network connection", status: false);
    } on SocketException {
      result = ResModel(success: false, message: "Error in network connection", error: "Error in network connection", status: false);
    } on FormatException {
      result = ResModel(success: false, message: "invalid format", error: "invalid format", status: false);
    } catch (e) {
      result = ResModel(success: false, message: "Something went wrong", error: "Something went wrong", status: false);
    }
    return result;
  }

  Future<ResModel> getSwapQuotation({required Map<String, dynamic> data}) async {
    ResModel result = ResModel();
    print(data.toString());
    try {
      var response = await http
          .post(
              Uri.parse(
                "${url}crypto/swap/swap-quotation",
              ),
              body: data,
              headers: getHeaders())
          .timeout(const Duration(seconds: 30));
      printWrapped(response.body);
      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse["code"] == 200) {
        return ResModel(data: jsonResponse, success: true, message: "Success");
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result = ResModel(success: false, message: jsonResponse['message'], error: jsonResponse['message'], status: false);
      }
    } on HttpException {
      result = ResModel(success: false, message: "Error in network connection", error: "Error in network connection", status: false);
    } on SocketException {
      result = ResModel(success: false, message: "Error in network connection", error: "Error in network connection", status: false);
    } on FormatException {
      result = ResModel(success: false, message: "invalid format", error: "invalid format", status: false);
    } catch (e) {
      result = ResModel(success: false, message: "Something went wrong", error: "Something went wrong", status: false);
    }
    return result;
  }

  Future<ResModel> getTransactionFees() async {
    ResModel result = ResModel();
    try {
      var response = await http.get(Uri.parse("${url}crypto/transaction-fees/get-all-transaction-fees"), headers: getHeaders()).timeout(const Duration(seconds: 30));
      printWrapped(response.body);
      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse["code"] == 200) {
        return ResModel(data: jsonResponse, success: true, message: "Success");
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result = ResModel(success: false, message: jsonResponse['message'], error: jsonResponse['message'], status: false);
      }
    } on HttpException {
      result = ResModel(success: false, message: "Error in network connection", error: "Error in network connection", status: false);
    } on SocketException {
      result = ResModel(success: false, message: "Error in network connection", error: "Error in network connection", status: false);
    } on FormatException {
      result = ResModel(success: false, message: "invalid format", error: "invalid format", status: false);
    } catch (e) {
      result = ResModel(success: false, message: "Something went wrong", error: "Something went wrong", status: false);
    }
    return result;
  }

  Future<ResModel> getTransaction(String currency) async {
    ResModel result = ResModel();
    var id = MySharedPreference.getUId();
    try {
      final uri = buildUri(
        url,
        "crypto/user/transactions",
        {
          "currency": currency,
          "userId": id,
        },
      );
      var response = await http
          .get(
            uri,
            headers: getHeaders(),
          )
          .timeout(const Duration(seconds: 30));
      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse["code"] == 200) {
        return ResModel(data: jsonResponse, success: true, message: "Success");
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result = ResModel(success: false, message: jsonResponse['message'], error: jsonResponse['message'], status: false);
      }
    } on HttpException {
      result = ResModel(success: false, message: "Error in network connection", error: "Error in network connection", status: false);
    } on SocketException {
      result = ResModel(success: false, message: "Error in network connection", error: "Error in network connection", status: false);
    } on FormatException {
      result = ResModel(success: false, message: "invalid format", error: "invalid format", status: false);
    } catch (e) {
      result = ResModel(success: false, message: "Something went wrong", error: "Something went wrong", status: false);
    }
    return result;
  }

  Future<ResModel> confirmSwapQuotation({required Map<String, dynamic> data}) async {
    ResModel result = ResModel();
    print(data.toString());
    try {
      var response = await http
          .post(
            Uri.parse(
              "${url}crypto/swap-quotation/confirm",
            ),
            body: data,
            headers: getHeaders(),
          )
          .timeout(const Duration(seconds: 30));
      printWrapped(response.body);
      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse["code"] == 200) {
        return ResModel(data: jsonResponse, success: true, message: "Success");
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result = ResModel(success: false, message: jsonResponse['message'], error: jsonResponse['message'], status: false);
      }
    } on HttpException {
      result = ResModel(success: false, message: "Error in network connection", error: "Error in network connection", status: false);
    } on SocketException {
      result = ResModel(success: false, message: "Error in network connection", error: "Error in network connection", status: false);
    } on FormatException {
      result = ResModel(success: false, message: "invalid format", error: "invalid format", status: false);
    } catch (e) {
      result = ResModel(success: false, message: "Something went wrong", error: "Something went wrong", status: false);
    }
    return result;
  }

  Future<ResModel> getCurrencyDetails({required String currency}) async {
    ResModel result = ResModel();
    print(currency);
    try {
      var response = await http
          .get(
            Uri.parse("${url}crypto/tickers/${currency.toLowerCase()}"),
            headers: getHeaders(),
          )
          .timeout(const Duration(seconds: 30));
      printWrapped(response.body);
      var jsonResponse = convert.jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // var loginResponse = LoginResponse.fromJson(jsonResponse);
        return ResModel(data: jsonResponse, success: true, message: "Success", status: true);
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result = ResModel(success: false, message: jsonResponse['message'], error: jsonResponse['message'], status: false);
      }
    } on HttpException {
      result = ResModel(success: false, message: "Error in network connection", error: "Error in network connection", status: false);
    } on SocketException {
      result = ResModel(success: false, message: "Error in network connection", error: "Error in network connection", status: false);
    } on FormatException {
      result = ResModel(success: false, message: "invalid format", error: "invalid format", status: false);
    } catch (e) {
      result = ResModel(success: false, message: "Something went wrong", error: "Something went wrong", status: false);
    }
    return result;
  }

  Future<ResModel> getTransactionFeesUSDValue({required String currency, required String tickerPair, bool isBuy = false}) async {
    ResModel result = ResModel();
    try {
      var response = await http
          .get(
            Uri.parse("${url}crypto/network-fee/usd-value/").replace(queryParameters: {
              'currency': currency,
              'ticker': tickerPair,
              'priceType': isBuy ? "buy" : 'sell',
            }),
            headers: getHeaders(),
          )
          .timeout(const Duration(seconds: 30));
      printWrapped(response.body);
      var jsonResponse = convert.jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // var loginResponse = LoginResponse.fromJson(jsonResponse);
        return ResModel(data: jsonResponse, success: true, message: "Success", status: true);
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result = ResModel(success: false, message: jsonResponse['message'], error: jsonResponse['message'], status: false);
      }
    } on HttpException {
      result = ResModel(success: false, message: "Error in network connection", error: "Error in network connection", status: false);
    } on SocketException {
      result = ResModel(success: false, message: "Error in network connection", error: "Error in network connection", status: false);
    } on FormatException {
      result = ResModel(success: false, message: "invalid format", error: "invalid format", status: false);
    } catch (e) {
      result = ResModel(success: false, message: "Something went wrong", error: "Something went wrong", status: false);
    }
    return result;
  }

  Future<ResModel> getAssetGraph({required String currency, required Map<String, dynamic> queryParams}) async {
    ResModel result = ResModel();
    print(currency);
    final uri = Uri.parse(url).replace(
      path: "crypto/crypto-graphs/markets/$currency",
      queryParameters: queryParams,
    );

    try {
      var response = await http
          .get(
            uri,
            headers: getHeaders(),
          )
          .timeout(
            const Duration(seconds: 30),
          );
      printWrapped(response.body);
      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse["code"] == 200) {
        // var loginResponse = LoginResponse.fromJson(jsonResponse);
        return ResModel(data: jsonResponse, success: true, message: "Success");
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result = ResModel(success: false, message: jsonResponse['message'], error: jsonResponse['message'], status: false);
      }
    } on HttpException {
      result = ResModel(success: false, message: "Error in network connection", error: "Error in network connection", status: false);
    } on SocketException {
      result = ResModel(success: false, message: "Error in network connection", error: "Error in network connection", status: false);
    } on FormatException {
      result = ResModel(success: false, message: "invalid format", error: "invalid format", status: false);
    } catch (e) {
      result = ResModel(success: false, message: "Something went wrong", error: "Something went wrong", status: false);
    }
    return result;
  }

  Future<ResModel> buyCrypto({required Map<String, dynamic> data}) async {
    ResModel result = ResModel();
    print(data.toString());
    try {
      print('12a');
      var response = await http.post(Uri.parse("${url}crypto/buy/user-buy-crypto"), headers: getHeaders(), body: data).timeout(const Duration(seconds: 30));
      print('12b');
      printWrapped(response.body);
      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse["code"] == 200) {
        // var loginResponse = LoginResponse.fromJson(jsonResponse);
        return ResModel(data: jsonResponse, success: true, message: "Success");
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result = ResModel(success: false, message: jsonResponse['message'], error: jsonResponse['message'], status: false);
      }
    } on HttpException {
      result = ResModel(success: false, message: "Error in network connection", error: "Error in network connection", status: false);
    } on SocketException {
      result = ResModel(success: false, message: "Error in network connection", error: "Error in network connection", status: false);
    } on FormatException {
      result = ResModel(success: false, message: "invalid format", error: "invalid format", status: false);
    } catch (e) {
      print(e.toString());
      result = ResModel(success: false, message: "Something went wrong", error: "Something went wrong", status: false);
    }
    return result;
  }

  Future<ResModel> sellCrypto({required Map<String, dynamic> data}) async {
    ResModel result = ResModel();
    print(data.toString());
    try {
      var response = await http.post(Uri.parse("${url}crypto/buy/sell-crypto/user-sell-crypto"), headers: getHeaders(), body: data).timeout(const Duration(seconds: 30));
      printWrapped(response.body);
      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse["code"] == 200) {
        // var loginResponse = LoginResponse.fromJson(jsonResponse);
        return ResModel(data: jsonResponse, success: true, message: "Success");
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result = ResModel(success: false, message: jsonResponse['message'], error: jsonResponse['message'], status: false);
      }
    } on HttpException {
      result = ResModel(success: false, message: "Error in network connection", error: "Error in network connection", status: false);
    } on SocketException {
      result = ResModel(success: false, message: "Error in network connection", error: "Error in network connection", status: false);
    } on FormatException {
      result = ResModel(success: false, message: "invalid format", error: "invalid format", status: false);
    } catch (e) {
      result = ResModel(success: false, message: "Something went wrong", error: "Something went wrong", status: false);
    }
    return result;
  }

  Future<ResModel> sendCrypto({required Map<String, dynamic> data}) async {
    ResModel result = ResModel();
    print(data.toString());
    try {
      var response = await http.post(Uri.parse("${url}crypto/send/withdraw"), headers: getHeaders(), body: data).timeout(const Duration(seconds: 30));
      printWrapped(response.body);
      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse["code"] == 200) {
        // var loginResponse = LoginResponse.fromJson(jsonResponse);
        return ResModel(data: jsonResponse, success: true, message: "Success");
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result = ResModel(success: false, message: jsonResponse['message'], error: jsonResponse['message'], status: false);
      }
    } on HttpException {
      result = ResModel(success: false, message: "Error in network connection", error: "Error in network connection", status: false);
    } on SocketException {
      result = ResModel(success: false, message: "Error in network connection", error: "Error in network connection", status: false);
    } on FormatException {
      result = ResModel(success: false, message: "invalid format", error: "invalid format", status: false);
    } catch (e) {
      print(e.toString());
      result = ResModel(success: false, message: "Something went wrong", error: "Something went wrong", status: false);
    }
    return result;
  }

  Future<ResModel> getAssetNetworks({required String? currency}) async {
    ResModel result = ResModel();
    var id = MySharedPreference.getQuidaxUserId();
    try {
      var response = await http.get(Uri.parse("${url}crypto/$id/$currency/addresses"), headers: getHeaders()).timeout(const Duration(seconds: 30));
      printWrapped(response.body);
      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse["code"] == 200 || jsonResponse["status"] == 200) {
        return ResModel(data: jsonResponse, success: true, message: "Success");
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result = ResModel(success: false, message: jsonResponse['message'], error: jsonResponse['message'], status: false);
      }
    } on HttpException {
      result = ResModel(success: false, message: "Error in network connection", error: "Error in network connection", status: false);
    } on SocketException {
      result = ResModel(success: false, message: "Error in network connection", error: "Error in network connection", status: false);
    } on FormatException {
      result = ResModel(success: false, message: "invalid format", error: "invalid format", status: false);
    } catch (e) {
      print(e.toString());
      result = ResModel(success: false, message: "Something went wrong", error: "Something went wrong", status: false);
    }
    return result;
  }
}

getHeaders() {
  String? mytoken = MySharedPreference.getToken();
  return {'Accept': 'application/json', if (mytoken != null && mytoken.isNotEmpty) 'Authorization': 'Bearer $mytoken'};
}
