class CryptoData {
  final num? at;
  final Ticker? ticker;
  final String? market;

  CryptoData({this.at, this.ticker, this.market});

  factory CryptoData.fromJson(Map<String, dynamic> json) {
    return CryptoData(
      at: json['at'] as num?,
      ticker: json['ticker'] != null ? Ticker.fromJson(json['ticker']) : null,
      market: json['market'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'at': at,
      'ticker': ticker?.toJson(),
      'market': market,
    };
  }

  @override
  String toString() {
    return 'CryptoData{at: $at, ticker: ${ticker.toString()}, market: $market}';
  }
}

class Ticker {
  final String? buy;
  final String? sell;
  final String? low;
  final String? high;
  final String? open;
  final String? last;
  final String? vol;

  num get buyAmount => num.tryParse(buy ?? "0") ?? 0;
  num get sellAmount => num.tryParse(sell ?? "0") ?? 0;
  Ticker({
    this.buy,
    this.sell,
    this.low,
    this.high,
    this.open,
    this.last,
    this.vol,
  });

  factory Ticker.fromJson(Map<String, dynamic> json) {
    return Ticker(
      buy: json['buy'] as String?,
      sell: json['sell'] as String?,
      low: json['low'] as String?,
      high: json['high'] as String?,
      open: json['open'] as String?,
      last: json['last'] as String?,
      vol: json['vol'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'buy': buy,
      'sell': sell,
      'low': low,
      'high': high,
      'open': open,
      'last': last,
      'vol': vol,
    };
  }

  @override
  String toString() {
    return 'Ticker{buy: $buy, sell: $sell, low: $low, high: $high, open: $open, last: $last, vol: $vol}';
  }
}
