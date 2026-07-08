import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/components/wallet_card.dart';
import 'package:spraay/models/virtual_number/vn_country.dart';
import 'package:spraay/models/virtual_number/vn_dashboard.dart';
import 'package:spraay/models/virtual_number/vn_service.dart';
import 'package:spraay/navigations/scale_transition.dart';
import 'package:spraay/services/virtual_number_service.dart';
import 'package:spraay/ui/others/bill_payments/virtual-numbers/providers/virtual_number_providers.dart';
import 'package:spraay/ui/others/bill_payments/virtual-numbers/virtual_number_history_page.dart';
import 'package:spraay/ui/others/bill_payments/virtual-numbers/virtual_number_order_page.dart';
import 'package:spraay/ui/others/bill_payments/virtual-numbers/virtual_number_pin_page.dart';
import 'package:spraay/ui/others/bill_payments/virtual-numbers/widgets/vn_order_card.dart';

// ─── Home: dashboard + recent orders ──────────────────────────────────────────

class VirtualNumber extends ConsumerWidget {
  final String title;
  const VirtualNumber({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(vnDashboardProvider);

    return Scaffold(
      backgroundColor: CustomColors.sBackgroundColor,
      appBar: buildAppBar(context: context, title: 'Virtual Numbers'),
      body: RefreshIndicator(
        onRefresh: () => ref.read(vnDashboardProvider.notifier).refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: horizontalPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height20,
              const WalletCard(),
              height20,
              dashboardAsync.when(
                loading: () => const _StatsShimmer(),
                error: (err, st) => _InlineError(
                  message: err is VirtualNumberException ? err.message : 'Unable to load your stats',
                  onRetry: () => ref.read(vnDashboardProvider.notifier).refresh(),
                ),
                data: (dashboard) => _StatsRow(dashboard: dashboard),
              ),
              height20,
              CustomButton(
                onTap: () async {
                  await Navigator.push(context, ScaleTransition1(page: const BuyVirtualNumberPage()));
                  ref.invalidate(vnDashboardProvider);
                },
                buttonText: 'Buy Number',
                buttonColor: CustomColors.sPrimaryColor500,
              ),
              height26,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Orders', style: CustomTextStyle.kTxtMedium.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                  GestureDetector(
                    onTap: () => Navigator.push(context, ScaleTransition1(page: const VerificationHistoryPage())),
                    child: Text('See all', style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 13.sp, color: CustomColors.sPrimaryColor400)),
                  ),
                ],
              ),
              height12,
              dashboardAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (dashboard) => dashboard.recentOrders.isEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Center(child: Text('No verifications yet', style: CustomTextStyle.kTxtRegular.copyWith(color: CustomColors.sGreyScaleColor500))),
                      )
                    : Column(
                        children: dashboard.recentOrders
                            .map((order) => VnOrderCard(
                                  order: order,
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VnOrderDetailPage(orderId: order.id))),
                                ))
                            .toList(),
                      ),
              ),
              height30,
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final VnDashboard dashboard;
  const _StatsRow({required this.dashboard});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _statItem('Total\nVerifications', dashboard.totalVerifications),
        _statDivider(),
        _statItem('Completed\nVerifications', dashboard.completedVerifications),
        _statDivider(),
        _statItem('Cancelled\nVerifications', dashboard.cancelledVerifications),
      ],
    );
  }

  Widget _statItem(String label, int value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 11.sp, color: CustomColors.sGreyScaleColor500, height: 1.4)),
          SizedBox(height: 4.h),
          Text('$value', style: CustomTextStyle.kTxtBold.copyWith(fontSize: 22.sp)),
        ],
      ),
    );
  }

  Widget _statDivider() {
    return Container(width: 1, height: 40.h, color: CustomColors.sDarkColor3, margin: EdgeInsets.symmetric(horizontal: 12.w));
  }
}

class _StatsShimmer extends StatelessWidget {
  const _StatsShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: CustomColors.sDarkColor2,
      highlightColor: CustomColors.sDarkColor3,
      child: Row(
        children: List.generate(
          3,
          (i) => Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i == 2 ? 0 : 16.w),
              child: Container(height: 44.h, decoration: BoxDecoration(color: CustomColors.sDarkColor2, borderRadius: BorderRadius.circular(8.r))),
            ),
          ),
        ),
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _InlineError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(message, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 13.sp, color: CustomColors.sGreyScaleColor400))),
        TextButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    );
  }
}

// ─── Buy Virtual Number ───────────────────────────────────────────────────────

class BuyVirtualNumberPage extends ConsumerStatefulWidget {
  const BuyVirtualNumberPage({super.key});

  @override
  ConsumerState<BuyVirtualNumberPage> createState() => _BuyVirtualNumberPageState();
}

class _BuyVirtualNumberPageState extends ConsumerState<BuyVirtualNumberPage> {
  VnService? _selectedService;
  VnCountry? _selectedCountry;

  Future<void> _showServicePicker() async {
    final result = await showModalBottomSheet<VnService>(
      context: context,
      backgroundColor: CustomColors.sDarkColor2,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (_) => const _ServicePickerSheet(),
    );
    if (result != null) setState(() => _selectedService = result);
  }

  Future<void> _showCountryPicker() async {
    final result = await showModalBottomSheet<VnCountry>(
      context: context,
      backgroundColor: CustomColors.sDarkColor2,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (_) => const _CountryPickerSheet(),
    );
    if (result != null) setState(() => _selectedCountry = result);
  }

  @override
  Widget build(BuildContext context) {
    final service = _selectedService;
    final country = _selectedCountry;
    final ready = service != null && country != null;

    return Scaffold(
      backgroundColor: CustomColors.sBackgroundColor,
      appBar: buildAppBar(context: context, title: 'Buy Virtual Number'),
      body: Padding(
        padding: horizontalPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height26,
            _selectorRow(
              label: 'Service',
              onTap: _showServicePicker,
              child: service == null
                  ? _placeholder('Select')
                  : Row(
                      children: [
                        VnServiceAvatar(service: service, size: 24),
                        SizedBox(width: 8.w),
                        Flexible(child: Text(service.name, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp), overflow: TextOverflow.ellipsis)),
                      ],
                    ),
            ),
            height16,
            _selectorRow(
              label: 'Country',
              onTap: _showCountryPicker,
              child: country == null
                  ? _placeholder('Select')
                  : Row(
                      children: [
                        Icon(Icons.public, size: 18.sp, color: CustomColors.sGreyScaleColor400),
                        SizedBox(width: 8.w),
                        Flexible(child: Text(country.name, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp), overflow: TextOverflow.ellipsis)),
                      ],
                    ),
            ),
            height26,
            Text('Amount', style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 13.sp, color: CustomColors.sGreyScaleColor500)),
            SizedBox(height: 8.h),
            if (!ready)
              Text('--', style: CustomTextStyle.kTxtBold.copyWith(fontSize: 26.sp, color: CustomColors.sGreyScaleColor500))
            else
              Consumer(
                builder: (context, ref, _) {
                  final priceAsync = ref.watch(vnPriceProvider((service: service.code, country: country.code)));
                  return priceAsync.when(
                    loading: () => SizedBox(
                      width: 120.w,
                      child: Shimmer.fromColors(
                        baseColor: CustomColors.sDarkColor2,
                        highlightColor: CustomColors.sDarkColor3,
                        child: Container(height: 30.h, decoration: BoxDecoration(color: CustomColors.sDarkColor2, borderRadius: BorderRadius.circular(6.r))),
                      ),
                    ),
                    error: (err, st) => _InlineError(
                      message: err is VirtualNumberException ? err.message : 'Unable to fetch price',
                      onRetry: () => ref.invalidate(vnPriceProvider((service: service.code, country: country.code))),
                    ),
                    data: (price) => price.available <= 0
                        ? Text('Out of stock for this country', style: CustomTextStyle.kTxtMedium.copyWith(fontSize: 15.sp, color: CustomColors.sErrorColor))
                        : Text('₦${currrency.format(price.amountNgn)}', style: CustomTextStyle.kTxtBold.copyWith(fontSize: 26.sp)),
                  );
                },
              ),
            const Spacer(),
            Consumer(
              builder: (context, ref, _) {
                final priceAsync = ready ? ref.watch(vnPriceProvider((service: service.code, country: country.code))) : null;
                final canBuy = ready && (priceAsync?.valueOrNull?.available ?? 0) > 0;
                return CustomButton(
                  onTap: canBuy
                      ? () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => VnPinConfirmPage(service: service, country: country, price: priceAsync!.value!)),
                          )
                      : null,
                  buttonText: 'Buy',
                  buttonColor: canBuy ? CustomColors.sPrimaryColor500 : CustomColors.sDisableButtonColor,
                );
              },
            ),
            height30,
          ],
        ),
      ),
    );
  }

  Widget _placeholder(String text) => Text(text, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, color: CustomColors.sGreyScaleColor500));

  Widget _selectorRow({required String label, required Widget child, required VoidCallback onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 13.sp, color: CustomColors.sGreyScaleColor500)),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(color: CustomColors.sDarkColor2, borderRadius: BorderRadius.circular(10.r)),
            child: Row(
              children: [
                Expanded(child: child),
                Icon(Icons.chevron_right, color: CustomColors.sGreyScaleColor500, size: 20.sp),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Service picker ────────────────────────────────────────────────────────────

class _ServicePickerSheet extends ConsumerWidget {
  const _ServicePickerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(vnFilteredServicesProvider);

    return Padding(
      padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 30.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _dragHandle(),
          height16,
          Text('Select service', style: CustomTextStyle.kTxtMedium.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          height12,
          _searchField(onChanged: (v) => ref.read(vnServiceSearchQueryProvider.notifier).state = v),
          height16,
          SizedBox(
            height: 360.h,
            child: servicesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, st) => Center(
                child: Text(
                  err is VirtualNumberException ? err.message : 'Unable to load services',
                  style: CustomTextStyle.kTxtRegular.copyWith(color: CustomColors.sGreyScaleColor400),
                ),
              ),
              data: (services) {
                if (services.isEmpty) {
                  return Center(child: Text('No services found', style: CustomTextStyle.kTxtRegular.copyWith(color: CustomColors.sGreyScaleColor500)));
                }
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 12.w, mainAxisSpacing: 12.h, childAspectRatio: 1.1),
                  itemCount: services.length,
                  itemBuilder: (_, i) {
                    final s = services[i];
                    return GestureDetector(
                      onTap: () => Navigator.pop(context, s),
                      child: Container(
                        decoration: BoxDecoration(color: CustomColors.sDarkColor3, borderRadius: BorderRadius.circular(12.r)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            VnServiceAvatar(service: s),
                            SizedBox(height: 6.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: Text(s.name, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 11.sp), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Country picker ────────────────────────────────────────────────────────────

class _CountryPickerSheet extends ConsumerWidget {
  const _CountryPickerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countriesAsync = ref.watch(vnFilteredCountriesProvider);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      builder: (_, scrollController) => Padding(
        padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _dragHandle(),
            height16,
            Text('Select Country', style: CustomTextStyle.kTxtMedium.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600)),
            height12,
            _searchField(onChanged: (v) => ref.read(vnCountrySearchQueryProvider.notifier).state = v),
            height12,
            Expanded(
              child: countriesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, st) => Center(
                  child: Text(
                    err is VirtualNumberException ? err.message : 'Unable to load countries',
                    style: CustomTextStyle.kTxtRegular.copyWith(color: CustomColors.sGreyScaleColor400),
                  ),
                ),
                data: (countries) {
                  if (countries.isEmpty) {
                    return Center(child: Text('No countries found', style: CustomTextStyle.kTxtRegular.copyWith(color: CustomColors.sGreyScaleColor500)));
                  }
                  return ListView.builder(
                    controller: scrollController,
                    itemCount: countries.length,
                    itemBuilder: (_, i) {
                      final c = countries[i];
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 2.h),
                        onTap: () => Navigator.pop(context, c),
                        leading: Icon(Icons.public, color: CustomColors.sGreyScaleColor400, size: 24.sp),
                        title: Text(c.name, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp)),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _dragHandle() {
  return Center(
    child: Container(
      width: 40.w,
      height: 4.h,
      decoration: BoxDecoration(color: CustomColors.sDarkColor3, borderRadius: BorderRadius.circular(4.r)),
    ),
  );
}

Widget _searchField({required ValueChanged<String> onChanged}) {
  return TextField(
    onChanged: onChanged,
    style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp),
    decoration: InputDecoration(
      hintText: 'Search',
      hintStyle: CustomTextStyle.kTxtRegular.copyWith(color: CustomColors.sGreyScaleColor500, fontSize: 14.sp),
      filled: true,
      fillColor: CustomColors.sDarkColor3,
      prefixIcon: Icon(Icons.search, color: CustomColors.sGreyScaleColor500, size: 20.sp),
      border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10.r)),
      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
    ),
  );
}
