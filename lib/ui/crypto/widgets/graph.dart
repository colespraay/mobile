import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spraay/models/graph-model.dart';
import 'package:spraay/ui/crypto/crypto.vm.dart';

class ChartPages extends StatefulWidget {
  final List<PriceData> priceData;
  final ChartInterval selectedPeriod;
  final Function(ChartInterval) onPeriodChanged;
  const ChartPages({
    Key? key,
    required this.priceData,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  }) : super(key: key);

  @override
  State<ChartPages> createState() => _ChartPagesState();
}

class _ChartPagesState extends State<ChartPages> {
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false, drawVerticalLine: false),
                titlesData: _buildTitlesData(),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (closeHandler.spots.length - 1).toDouble(),
                minY: closeHandler.minY,
                maxY: closeHandler.maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: closeHandler.spots,
                    isCurved: false,
                    color: Colors.green,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          // Period Selector
          SizedBox(
            height: 40,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ChartInterval.values
                    .map((period) => GestureDetector(
                          onTap: () => widget.onPeriodChanged(period),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: widget.selectedPeriod == period ? const Color(0xFF2563EB) : const Color(0xFF1F2937),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              period.label,
                              style: TextStyle(
                                color: widget.selectedPeriod == period ? Colors.white : Colors.grey[400],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
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
          showTitles: false,
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
}
