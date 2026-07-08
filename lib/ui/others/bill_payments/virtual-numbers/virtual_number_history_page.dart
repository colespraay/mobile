import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/services/virtual_number_service.dart';
import 'package:spraay/ui/others/bill_payments/virtual-numbers/providers/virtual_number_providers.dart';
import 'package:spraay/ui/others/bill_payments/virtual-numbers/virtual_number_order_page.dart';
import 'package:spraay/ui/others/bill_payments/virtual-numbers/widgets/vn_order_card.dart';

class VerificationHistoryPage extends ConsumerStatefulWidget {
  const VerificationHistoryPage({super.key});

  @override
  ConsumerState<VerificationHistoryPage> createState() => _VerificationHistoryPageState();
}

class _VerificationHistoryPageState extends ConsumerState<VerificationHistoryPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        ref.read(vnOrdersProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(vnOrdersProvider);

    return Scaffold(
      backgroundColor: CustomColors.sBackgroundColor,
      appBar: buildAppBar(context: context, title: 'Verification history'),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(
          child: Padding(
            padding: horizontalPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  err is VirtualNumberException ? err.message : 'Something went wrong',
                  textAlign: TextAlign.center,
                  style: CustomTextStyle.kTxtRegular.copyWith(color: CustomColors.sGreyScaleColor400),
                ),
                height16,
                CustomButton(onTap: () => ref.read(vnOrdersProvider.notifier).refresh(), buttonText: 'Retry', buttonColor: CustomColors.sPrimaryColor500),
              ],
            ),
          ),
        ),
        data: (page) {
          if (page.orders.isEmpty) {
            return Center(
              child: Text('No verifications yet', style: CustomTextStyle.kTxtRegular.copyWith(color: CustomColors.sGreyScaleColor500)),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(vnOrdersProvider.notifier).refresh(),
            child: ListView.builder(
              controller: _scrollController,
              padding: horizontalPadding.copyWith(top: 16.h, bottom: 30.h),
              itemCount: page.orders.length + (page.hasMore ? 1 : 0),
              itemBuilder: (_, i) {
                if (i >= page.orders.length) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                final order = page.orders[i];
                return VnOrderCard(
                  order: order,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VnOrderDetailPage(orderId: order.id))),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
