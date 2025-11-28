class NetworkFeeResponse {
  final bool? success;
  final int? code;
  final String? message;
  final NetworkFeeData? data;

  NetworkFeeResponse({
    this.success,
    this.code,
    this.message,
    this.data,
  });

  factory NetworkFeeResponse.fromJson(Map<String, dynamic> json) {
    return NetworkFeeResponse(
      success: json['success'],
      code: json['code'],
      message: json['message'],
      data: json['data'] != null ? NetworkFeeData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'code': code,
        'message': message,
        'data': data?.toJson(),
      };
}

/// ---------------------------------------------------------------------------
/// MAIN DATA
/// ---------------------------------------------------------------------------
class NetworkFeeData {
  final num? feeCrypto;
  final String? feeType;
  final num? usdPerUnit;
  final String? priceTypeUsed;
  final num? usdValue;
  final String? tickerUsed;
  final OriginalFeeResponse? originalFeeResponse;
  final OriginalTickerResponse? originalTickerResponse;

  NetworkFeeData({
    this.feeCrypto,
    this.feeType,
    this.usdPerUnit,
    this.priceTypeUsed,
    this.usdValue,
    this.tickerUsed,
    this.originalFeeResponse,
    this.originalTickerResponse,
  });

  factory NetworkFeeData.fromJson(Map<String, dynamic> json) {
    return NetworkFeeData(
      feeCrypto: json['fee_crypto'],
      feeType: json['fee_type'],
      usdPerUnit: json['usd_per_unit'],
      priceTypeUsed: json['price_type_used'],
      usdValue: json['usd_value'],
      tickerUsed: json['ticker_used'],
      originalFeeResponse: json['original_fee_response'] != null ? OriginalFeeResponse.fromJson(json['original_fee_response']) : null,
      originalTickerResponse: json['original_ticker_response'] != null
          ? OriginalTickerResponse.fromJson(
              json['original_ticker_response'],
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'fee_crypto': feeCrypto,
        'fee_type': feeType,
        'usd_per_unit': usdPerUnit,
        'price_type_used': priceTypeUsed,
        'usd_value': usdValue,
        'ticker_used': tickerUsed,
        'original_fee_response': originalFeeResponse?.toJson(),
        'original_ticker_response': originalTickerResponse?.toJson(),
      };
}

/// ---------------------------------------------------------------------------
/// ORIGINAL FEE RESPONSE
/// ---------------------------------------------------------------------------
class OriginalFeeResponse {
  final String? status;
  final String? message;
  final OriginalFeeData? data;

  OriginalFeeResponse({
    this.status,
    this.message,
    this.data,
  });

  factory OriginalFeeResponse.fromJson(Map<String, dynamic> json) {
    return OriginalFeeResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? OriginalFeeData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}

class OriginalFeeData {
  final num? fee;
  final String? type;

  OriginalFeeData({
    this.fee,
    this.type,
  });

  factory OriginalFeeData.fromJson(Map<String, dynamic> json) {
    return OriginalFeeData(
      fee: json['fee'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() => {
        'fee': fee,
        'type': type,
      };
}

/// ---------------------------------------------------------------------------
/// ORIGINAL TICKER RESPONSE
/// ---------------------------------------------------------------------------
class OriginalTickerResponse {
  final String? status;
  final String? message;
  final TickerData? data;

  OriginalTickerResponse({
    this.status,
    this.message,
    this.data,
  });

  factory OriginalTickerResponse.fromJson(Map<String, dynamic> json) {
    return OriginalTickerResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? TickerData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}

class TickerData {
  final int? at;
  final MarketTicker? ticker;
  final String? market;

  TickerData({
    this.at,
    this.ticker,
    this.market,
  });

  factory TickerData.fromJson(Map<String, dynamic> json) {
    return TickerData(
      at: json['at'],
      ticker: json['ticker'] != null ? MarketTicker.fromJson(json['ticker']) : null,
      market: json['market'],
    );
  }

  Map<String, dynamic> toJson() => {
        'at': at,
        'ticker': ticker?.toJson(),
        'market': market,
      };
}

class MarketTicker {
  final String? buy;
  final String? sell;
  final String? low;
  final String? high;
  final String? open;
  final String? last;
  final String? vol;

  MarketTicker({
    this.buy,
    this.sell,
    this.low,
    this.high,
    this.open,
    this.last,
    this.vol,
  });

  factory MarketTicker.fromJson(Map<String, dynamic> json) => MarketTicker(
        buy: json['buy'],
        sell: json['sell'],
        low: json['low'],
        high: json['high'],
        open: json['open'],
        last: json['last'],
        vol: json['vol'],
      );

  Map<String, dynamic> toJson() => {
        'buy': buy,
        'sell': sell,
        'low': low,
        'high': high,
        'open': open,
        'last': last,
        'vol': vol,
      };
}
