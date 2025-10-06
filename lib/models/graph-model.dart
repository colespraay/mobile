import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// Model for your price data
class PriceData {
  final DateTime date;
  final int timestamp;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;

  PriceData({
    required this.date,
    required this.timestamp,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  factory PriceData.fromJson(Map<String, dynamic> json) {
    return PriceData(
      date: DateTime.parse(json['date']),
      timestamp: json['timestamp'],
      open: (json['open'] as num).toDouble(),
      high: (json['high'] as num).toDouble(),
      low: (json['low'] as num).toDouble(),
      close: (json['close'] as num).toDouble(),
      volume: (json['volume'] as num).toDouble(),
    );
  }
}

// Generic Chart Data Handler
class ChartDataHandler<T> {
  final List<T> data;
  final double Function(T) getValue;
  final DateTime Function(T) getDate;

  late List<FlSpot> spots;
  late List<DateTime> timestamps;
  late double minY;
  late double maxY;
  late List<double> values;

  ChartDataHandler({
    required this.data,
    required this.getValue,
    required this.getDate,
    double paddingPercent = 0.1,
  }) {
    _processData(paddingPercent);
  }

  void _processData(double paddingPercent) {
    spots = [];
    timestamps = [];
    values = [];

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final value = getValue(item);

      values.add(value);
      spots.add(FlSpot(i.toDouble(), value));
      timestamps.add(getDate(item));
    }

    if (values.isNotEmpty) {
      minY = values.reduce((a, b) => a < b ? a : b);
      maxY = values.reduce((a, b) => a > b ? a : b);

      // Add padding to Y axis
      final padding = (maxY - minY) * paddingPercent;
      minY -= padding;
      maxY += padding;
    } else {
      minY = 0;
      maxY = 0;
    }
  }

  // Get statistics
  double get average => values.isEmpty ? 0 : values.reduce((a, b) => a + b) / values.length;
  double get min => values.isEmpty ? 0 : values.reduce((a, b) => a < b ? a : b);
  double get max => values.isEmpty ? 0 : values.reduce((a, b) => a > b ? a : b);
  double get latest => values.isEmpty ? 0 : values.last;
  double get first => values.isEmpty ? 0 : values.first;
}

// Multi-value Chart Data Handler (for OHLC data)
class OHLCChartDataHandler {
  final List<PriceData> data;

  late List<FlSpot> openSpots;
  late List<FlSpot> highSpots;
  late List<FlSpot> lowSpots;
  late List<FlSpot> closeSpots;
  late List<FlSpot> volumeSpots;
  late List<DateTime> timestamps;
  late double minPrice;
  late double maxPrice;
  late double minVolume;
  late double maxVolume;

  OHLCChartDataHandler({
    required this.data,
    double paddingPercent = 0.1,
  }) {
    _processData(paddingPercent);
  }

  void _processData(double paddingPercent) {
    openSpots = [];
    highSpots = [];
    lowSpots = [];
    closeSpots = [];
    volumeSpots = [];
    timestamps = [];

    List<double> allPrices = [];
    List<double> allVolumes = [];

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final index = i.toDouble();

      openSpots.add(FlSpot(index, item.open));
      highSpots.add(FlSpot(index, item.high));
      lowSpots.add(FlSpot(index, item.low));
      closeSpots.add(FlSpot(index, item.close));
      volumeSpots.add(FlSpot(index, item.volume));
      timestamps.add(item.date);

      allPrices.addAll([item.open, item.high, item.low, item.close]);
      allVolumes.add(item.volume);
    }

    if (allPrices.isNotEmpty) {
      minPrice = allPrices.reduce((a, b) => a < b ? a : b);
      maxPrice = allPrices.reduce((a, b) => a > b ? a : b);

      final padding = (maxPrice - minPrice) * paddingPercent;
      minPrice -= padding;
      maxPrice += padding;
    } else {
      minPrice = 0;
      maxPrice = 0;
    }

    if (allVolumes.isNotEmpty) {
      minVolume = allVolumes.reduce((a, b) => a < b ? a : b);
      maxVolume = allVolumes.reduce((a, b) => a > b ? a : b);
    } else {
      minVolume = 0;
      maxVolume = 0;
    }
  }

  // Statistics
  double get avgVolume => data.isEmpty ? 0 : data.map((e) => e.volume).reduce((a, b) => a + b) / data.length;
  double get highestPrice => data.isEmpty ? 0 : data.map((e) => e.high).reduce((a, b) => a > b ? a : b);
  double get lowestPrice => data.isEmpty ? 0 : data.map((e) => e.low).reduce((a, b) => a < b ? a : b);
  double get latestClose => data.isEmpty ? 0 : data.last.close;
  double get priceChange => data.isEmpty ? 0 : data.last.close - data.first.open;
  double get priceChangePercent => data.isEmpty ? 0 : (priceChange / data.first.open) * 100;
}

// Example Usage Widget
class ChartExample extends StatefulWidget {
  final List<PriceData> priceData;

  const ChartExample({Key? key, required this.priceData}) : super(key: key);

  @override
  State<ChartExample> createState() => _ChartExampleState();
}

class _ChartExampleState extends State<ChartExample> {
  late ChartDataHandler<PriceData> closeHandler;
  late OHLCChartDataHandler ohlcHandler;

  @override
  void initState() {
    super.initState();
    _initializeHandlers();
  }

  void _initializeHandlers() {
    // Handler for close prices only
    closeHandler = ChartDataHandler<PriceData>(
      data: widget.priceData,
      getValue: (item) => item.close,
      getDate: (item) => item.date,
    );

    // Handler for OHLC data
    ohlcHandler = OHLCChartDataHandler(data: widget.priceData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chart with Data Handler')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Close price line chart
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  titlesData: _buildTitlesData(),
                  borderData: FlBorderData(show: true),
                  minX: 0,
                  maxX: (closeHandler.spots.length - 1).toDouble(),
                  minY: closeHandler.minY,
                  maxY: closeHandler.maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: closeHandler.spots,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Statistics
            _buildStats(),
          ],
        ),
      ),
    );
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: 5,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index < 0 || index >= closeHandler.timestamps.length) {
              return const Text('');
            }
            final time = closeHandler.timestamps[index];
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 10),
              ),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 60,
          getTitlesWidget: (value, meta) {
            return Text(
              value.toStringAsFixed(0),
              style: const TextStyle(fontSize: 10),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Min', closeHandler.min.toStringAsFixed(0)),
              _buildStatItem('Max', closeHandler.max.toStringAsFixed(0)),
              _buildStatItem('Avg', closeHandler.average.toStringAsFixed(0)),
              _buildStatItem('Latest', closeHandler.latest.toStringAsFixed(0)),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('High', ohlcHandler.highestPrice.toStringAsFixed(0)),
              _buildStatItem('Low', ohlcHandler.lowestPrice.toStringAsFixed(0)),
              _buildStatItem('Avg Vol', ohlcHandler.avgVolume.toStringAsFixed(4)),
              _buildStatItem(
                'Change',
                '${ohlcHandler.priceChangePercent >= 0 ? '+' : ''}${ohlcHandler.priceChangePercent.toStringAsFixed(2)}%',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// Example of how to use with different data types
class SimpleDataPoint {
  final DateTime timestamp;
  final double value;

  SimpleDataPoint(this.timestamp, this.value);
}

void exampleUsage() {
  // Example 1: Using with PriceData
  List<PriceData> priceData = []; // Your price data here

  var closeChartHandler = ChartDataHandler<PriceData>(
    data: priceData,
    getValue: (item) => item.close,
    getDate: (item) => item.date,
  );

  // Example 2: Using with any custom data type
  List<SimpleDataPoint> simpleData = []; // Your simple data here

  var simpleChartHandler = ChartDataHandler<SimpleDataPoint>(
    data: simpleData,
    getValue: (item) => item.value,
    getDate: (item) => item.timestamp,
  );

  // Example 3: Using OHLC handler
  var ohlcHandler = OHLCChartDataHandler(data: priceData);

  // Access processed data
  print('Close spots: ${closeChartHandler.spots}');
  print('Min Y: ${closeChartHandler.minY}');
  print('Max Y: ${closeChartHandler.maxY}');
  print('Average: ${closeChartHandler.average}');

  print('High spots: ${ohlcHandler.highSpots}');
  print('Price change: ${ohlcHandler.priceChangePercent}%');
}
