import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/crypto-history.dart' hide Wallet;
import 'package:spraay/models/graph-model.dart';
import 'package:spraay/models/loading-states.dart';
import 'package:spraay/models/wallets-response.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/crypto/buy/buy-amount-page.dart';
import 'package:spraay/ui/crypto/crypto.ui.dart';
import 'package:spraay/ui/crypto/crypto.vm.dart';
import 'package:spraay/ui/crypto/receive/receiver-details.dart';
import 'package:spraay/ui/crypto/sell/sell-amount-page.dart';
import 'package:spraay/ui/crypto/swap/swap.ui.dart';
import 'package:spraay/ui/crypto/widgets/asset-header.dart';
import 'package:spraay/ui/crypto/widgets/graph.dart';
import 'package:spraay/ui/crypto/widgets/receipt.dart';
import 'package:spraay/utils/after-layout.dart';
import 'package:spraay/utils/string-utils.dart';

class CryptoWalletApp extends StatefulWidget {
  final CAsset asset;
  const CryptoWalletApp({required this.asset});
  @override
  _CryptoWalletAppState createState() => _CryptoWalletAppState();
}

class _CryptoWalletAppState extends State<CryptoWalletApp> {
  int currentScreen = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentScreen,
        children: [
          AssetDetails(onNavigate: (screen) => setState(() => currentScreen = screen), asset: Wallet()),
          TransactionsScreen(onNavigate: (screen) => setState(() => currentScreen = screen)),
          ReceiptScreen(onNavigate: (screen) => setState(() => currentScreen = screen)),
        ],
      ),
      // Demo navigation
      bottomNavigationBar: Container(
        color: Colors.grey[900],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () => setState(() => currentScreen = 0),
              child: Text('Home', style: TextStyle(color: currentScreen == 0 ? Colors.blue : Colors.grey)),
            ),
            TextButton(
              onPressed: () => setState(() => currentScreen = 1),
              child: Text('Transactions', style: TextStyle(color: currentScreen == 1 ? Colors.blue : Colors.grey)),
            ),
            TextButton(
              onPressed: () => setState(() => currentScreen = 2),
              child: Text('Receipt', style: TextStyle(color: currentScreen == 2 ? Colors.blue : Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }
}

// Chart Component
class PriceChart extends StatefulWidget {
  final List<double> data;
  final ChartInterval selectedPeriod;
  final Function(ChartInterval) onPeriodChanged;

  PriceChart({
    required this.data,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  _PriceChartState createState() => _PriceChartState();
}

class _PriceChartState extends State<PriceChart> {
  final List<String> periods = ['1H', '1D', '1W', '1M', '1Y'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chart
        Container(
          height: 120,
          width: double.infinity,
          child: CustomPaint(
            painter: ChartPainter(widget.data),
          ),
        ),
        const SizedBox(height: 24),
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
    );
  }
}

// Chart Painter
class ChartPainter extends CustomPainter {
  final List<double> data;

  ChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = const Color(0xFF10B981)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final double maxValue = data.reduce((a, b) => a > b ? a : b);
    final double minValue = data.reduce((a, b) => a < b ? a : b);
    final double range = maxValue - minValue;

    for (int i = 0; i < data.length; i++) {
      final double x = (i / (data.length - 1)) * size.width;
      final double y = size.height - ((data[i] - minValue) / range) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Action Button Component
class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  ActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: CustomColors.sDarkBlue,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        ],
      ),
    );
  }
}

// Transaction Item Component
class TransactionItem extends StatelessWidget {
  final String amount;
  final String description;
  final String date;
  final VoidCallback? onTap;

  TransactionItem({
    required this.amount,
    required this.description,
    required this.date,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: const Color(0xff1F2224), borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(amount, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                Text(date, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(description, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Home Screen
class AssetDetails extends StatefulWidget {
  final Wallet asset;
  final Function(int)? onNavigate;

  AssetDetails({this.onNavigate, required this.asset});

  @override
  _AssetDetailsState createState() => _AssetDetailsState();
}

class _AssetDetailsState extends State<AssetDetails> with AfterLayoutMixin<AssetDetails> {
  String selectedPeriod = '1H';
  ChartInterval selectedInterval = ChartInterval.oneHour;

  final List<double> chartData = [45, 52, 48, 61, 55, 67, 58, 72, 65, 78, 73, 69, 75];

  CryptoProvider? cryptoProvider;
  CAsset get asset => CAsset(name: widget.asset.name, nairaPrice: widget.asset.balance, icon: widget.asset.imageUrl, sub: widget.asset.currency);

  String get market => "${widget.asset.currency}${widget.asset.referenceCurrency ?? ""}";
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    Provider.of<CryptoProvider>(context, listen: false).getTickers(context, interval: selectedInterval, market: market);
    Provider.of<CryptoProvider>(context, listen: false).getTransactions(context, (widget.asset.currency ?? "").toLowerCase());
  }

  @override
  void didChangeDependencies() {
    cryptoProvider = context.watch<CryptoProvider>();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppBar(context: context, title: "Details"),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tether Price Section
                  AssetHeader(title: widget.asset.name, icon: widget.asset.imageUrl, subTitle: widget.asset.currency),
                  const SizedBox(height: 16),
                  if (cryptoProvider?.assetGraphs.length != 0)
                    Text('₦${(cryptoProvider?.assetGraphs.latestData?.actualPrice).toString().formatAsAmountWithDecimals()}',
                        style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                  Text("${(widget.asset.currency ?? "").toUpperCase()} ${widget.asset.balance}", style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                  const SizedBox(height: 32),

                  // Chart
                  // PriceChart(data: chartData, selectedPeriod: selectedInterval, onPeriodChanged: (period) => setState(() => selectedInterval = period)),
                  if (cryptoProvider?.assetGraphs.length == 0)
                    (cryptoProvider?.state == LoadState.success)
                        ? const Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 24,
                                ),
                                Icon(Icons.egg_alt_outlined, color: Colors.white),
                                Text(
                                  "No Information Available",
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                              ],
                            ),
                          )
                        : const Center(child: CircularProgressIndicator())
                  else
                    SizedBox(
                        height: 200,
                        child: ChartPages(
                            priceData: cryptoProvider?.assetGraphs ?? [],
                            selectedPeriod: selectedInterval,
                            onPeriodChanged: (period) {
                              setState(() {
                                selectedInterval = period;
                              });
                              cryptoProvider?.getTickers(context, interval: selectedInterval, market: market);
                            })),
                  const SizedBox(height: 32),

                  // Balance
                  Text('Your balance', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('₦${(widget.asset.convertedBalance).formatAsAmountWithDecimals()}', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  Text("${(widget.asset.currency ?? " ").toUpperCase()} ${widget.asset.balance}", style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ActionButton(
                          icon: Icons.add,
                          label: 'Buy',
                          onTap: () {
                            Navigator.push(
                                context,
                                FadeRoute(
                                    page: BuyAssetScreen(
                                  asset: widget.asset,
                                )));
                          }),
                      ActionButton(
                          icon: Icons.arrow_upward,
                          label: 'Send',
                          onTap: () {
                            Navigator.push(
                                context,
                                FadeRoute(
                                  page: SellAssetScreen(
                                    asset: widget.asset,
                                  ),
                                ));
                          }),
                      ActionButton(
                          icon: Icons.swap_horiz,
                          label: 'Swap',
                          onTap: () {
                            Navigator.push(context, FadeRoute(page: SwapAssetScreen(asset: asset)));
                          }),
                      if (widget.asset.depositAddress != null)
                        ActionButton(
                            icon: Icons.qr_code,
                            label: 'Receive',
                            onTap: () {
                              Navigator.push(
                                  context,
                                  FadeRoute(
                                    page: ReceiverDetails(
                                      cAsset: widget.asset,
                                    ),
                                  ));
                            }),
                    ],
                  ),
                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('History', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
                      GestureDetector(
                        onTap: () => navigate(context: context, page: TransactionsScreen()), //widget.onNavigate(1),
                        child: const Text('Sell all', style: TextStyle(color: Color(0xFF2563EB), fontSize: 14)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  ...safeSublist<GeneralTransaction>(cryptoProvider?.transactions ?? [], 5)
                      .map((GeneralTransaction e) => TransactionItem(
                          amount: '${e.amount} ${e.currency?.toUpperCase() ?? ""}',
                          description: e.description ?? "",
                          date: e.formattedDate,
                          onTap: () {
                            //   Navigator.pushReplacement(
                            //       context,
                            //       FadeRoute(
                            //           page: PaymentReceipt(
                            //         svg_img: 'spray_anim',
                            //         type: e.transactionType.name,
                            //         date: e.createdAt ?? "",
                            //         amount: e.amount ?? "",
                            //         meterNumber: '',
                            //         transactionRef: e.txid ?? "",
                            //         transStatus: e.status ?? "",
                            //         transactionId: e.txid ?? "",
                            //       )));
                            // }
                            navigate(context: context, page: ReceiptScreen(item: e));
                          }))
                      .toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Transactions Screen
class TransactionsScreen extends StatelessWidget {
  final Function(int)? onNavigate;

  TransactionsScreen({this.onNavigate});

  @override
  Widget build(BuildContext context) {
    CryptoProvider cryptoProvider = context.watch<CryptoProvider>();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppBar(context: context, title: "Transactions"),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('November', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                  const SizedBox(height: 16),
                  ...cryptoProvider.transactions
                      .map((e) => TransactionItem(
                            amount: '${e.amount} ${e.currency?.toUpperCase() ?? ""}',
                            description: e.description ?? "",
                            date: e.formattedDate,
                            onTap: () => navigate(
                                context: context,
                                page: ReceiptScreen(
                                  item: e,
                                )),
                          ))
                      .toList(),
                  // ...transactions
                  //     .map((transaction) => TransactionItem(
                  //           amount: transaction['amount']!,
                  //           description: transaction['description']!,
                  //           date: transaction['date']!,
                  //           onTap: () => navigate(context: context, page: ReceiptScreen()),
                  //         ))
                  //     .toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

navigate({required BuildContext context, Widget? page, bool isPushReplacement = false}) {
  page == null
      ? Navigator.pop(context)
      : isPushReplacement
          ? Navigator.pushReplacement(context, FadeRoute(page: page))
          : Navigator.push(context, FadeRoute(page: page));
}

List<T> safeSublist<T>(List<T> list, int end) {
  if (list.isEmpty) return [];
  return list.sublist(0, min(end, list.length));
}
