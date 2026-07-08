import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:spraay/components/constant.dart';
import 'package:spraay/models/virtual_number/vn_country.dart';
import 'package:spraay/models/virtual_number/vn_dashboard.dart';
import 'package:spraay/models/virtual_number/vn_order.dart';
import 'package:spraay/models/virtual_number/vn_orders_page.dart';
import 'package:spraay/models/virtual_number/vn_price.dart';
import 'package:spraay/models/virtual_number/vn_service.dart';
import 'package:spraay/utils/my_sharedpref.dart';

/// Thrown for any failure talking to the virtual-number endpoints - network
/// errors, timeouts, malformed responses, and API-reported failures are all
/// normalized into this so the UI only has one error type to handle.
class VirtualNumberException implements Exception {
  final String message;
  const VirtualNumberException(this.message);

  @override
  String toString() => message;
}

class VirtualNumberService {
  static const _basePath = '/virtual-number';
  static const _timeout = Duration(seconds: 30);

  final http.Client _client;

  VirtualNumberService({http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> get _headers => {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${MySharedPreference.getToken()}',
      };

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final cleanQuery = query == null ? null : {for (final e in query.entries) if (e.value != null) e.key: e.value.toString()};
    return Uri.parse('$baseUrl$_basePath$path').replace(queryParameters: cleanQuery?.isEmpty ?? true ? null : cleanQuery);
  }

  Future<List<VnService>> getServices() async {
    final data = await _get(_uri('/services'));
    return (data as List).map((e) => VnService.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<List<VnService>> searchServices(String query) async {
    final data = await _get(_uri('/services/search', {'q': query}));
    return (data as List).map((e) => VnService.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<List<VnCountry>> getCountries() async {
    final data = await _get(_uri('/countries'));
    return (data as List).map((e) => VnCountry.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<List<VnCountry>> searchCountries(String query) async {
    final data = await _get(_uri('/countries/search', {'q': query}));
    return (data as List).map((e) => VnCountry.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<VnPrice> getPrice({required String service, required String country}) async {
    final data = await _get(_uri('/price', {'service': service, 'country': country}));
    return VnPrice.fromJson(Map<String, dynamic>.from(data));
  }

  Future<VnDashboard> getDashboard({int recentLimit = 5}) async {
    final userid = MySharedPreference.getUId();
    final data = await _get(_uri('/dashboard/$userid', {'recentLimit': recentLimit}));
    print(data);
    return VnDashboard.fromJson(Map<String, dynamic>.from(data));
  }

  Future<VnOrdersPage> getOrders({String? status, int page = 1, int limit = 20}) async {
    final userid = MySharedPreference.getUId();
    final data = await _get(_uri('/orders/$userid', {'status': status, 'page': page, 'limit': limit}));
    return VnOrdersPage.fromJson(Map<String, dynamic>.from(data));
  }

  Future<VnOrder> getOrder(String id) async {
    final userid = MySharedPreference.getUId();
    final data = await _get(_uri('/order/$id/$userid'));
    return VnOrder.fromJson(Map<String, dynamic>.from(data));
  }

  Future<VnOrder> buyNumber({
    required String service,
    required String country,
    required String transactionPin,
    double maxPrice = 0,
  }) async {
    final data = await _post(_uri('/buy'), {
      'service': service,
      'country': country,
      'maxPrice': maxPrice,
      'transactionPin': transactionPin,
      'userid': MySharedPreference.getUId(),
    });
    print(data);
    return VnOrder.fromJson(Map<String, dynamic>.from(data));
  }

  Future<void> cancelOrder(String id) async {
    await _post(_uri('/order/$id/cancel'), {'userid': MySharedPreference.getUId()}, allowEmptyData: true);
  }

  Future<void> resendOrder(String id) async {
    await _post(_uri('/order/$id/resend'), {'userid': MySharedPreference.getUId()}, allowEmptyData: true);
  }

  Future<dynamic> _get(Uri uri) async {
    try {
      final response = await _client.get(uri, headers: _headers).timeout(_timeout);
      return _unwrap(response);
    } on VirtualNumberException {
      rethrow;
    } on TimeoutException {
      throw const VirtualNumberException('Request timed out. Please try again.');
    } on SocketException {
      throw const VirtualNumberException('Error in network connection');
    } on FormatException {
      throw const VirtualNumberException('Invalid response from server');
    } catch (_) {
      throw const VirtualNumberException('Something went wrong');
    }
  }

  Future<dynamic> _post(Uri uri, Map<String, dynamic> body, {bool allowEmptyData = false}) async {
    try {
      final response = await _client
          .post(uri, headers: {..._headers, 'Content-Type': 'application/json'}, body: jsonEncode(body))
          .timeout(_timeout);
      return _unwrap(response, allowEmptyData: allowEmptyData);
    } on VirtualNumberException {
      rethrow;
    } on TimeoutException {
      throw const VirtualNumberException('Request timed out. Please try again.');
    } on SocketException {
      throw const VirtualNumberException('Error in network connection');
    } on FormatException {
      throw const VirtualNumberException('Invalid response from server');
    } catch (_) {
      throw const VirtualNumberException('Something went wrong');
    }
  }

  dynamic _unwrap(http.Response response, {bool allowEmptyData = false}) {
    final Map<String, dynamic> json = response.body.isEmpty ? {} : Map<String, dynamic>.from(jsonDecode(response.body));
    final success = json['success'] == true || (response.statusCode >= 200 && response.statusCode < 300 && json['success'] == null);
    if (!success) {
      throw VirtualNumberException(json['message']?.toString() ?? 'Something went wrong');
    }
    final data = json['data'];
    if (data == null && !allowEmptyData) {
      throw const VirtualNumberException('Empty response from server');
    }
    return data ?? {};
  }
}
