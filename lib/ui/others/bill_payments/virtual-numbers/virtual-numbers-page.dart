import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/components/wallet_card.dart';
import 'package:spraay/navigations/scale_transition.dart';

// ─── Models ──────────────────────────────────────────────────────────────────

enum VnStatus { waitingSms, completed, cancelled }

class VnService {
  final String name;
  final Color color;
  final IconData icon;
  const VnService({required this.name, required this.color, required this.icon});
}

class VnCountry {
  final String name;
  final String flag;
  final String dialCode;
  const VnCountry({required this.name, required this.flag, required this.dialCode});
}

class VnOrder {
  final String id;
  final VnService service;
  final VnCountry country;
  final String phone;
  final double price;
  VnStatus status;
  String? otpCode;
  int secondsLeft;

  VnOrder({
    required this.id,
    required this.service,
    required this.country,
    required this.phone,
    required this.price,
    required this.status,
    this.otpCode,
    this.secondsLeft = 0,
  });
}

// ─── Dummy Data ───────────────────────────────────────────────────────────────

final List<VnService> vnServices = [
  const VnService(name: 'Whatsapp', color: Color(0xFF25D366), icon: Icons.chat_bubble),
  const VnService(name: 'Telegram', color: Color(0xFF229ED9), icon: Icons.send),
  const VnService(name: 'Facebook', color: Color(0xFF1877F2), icon: Icons.facebook),
  const VnService(name: 'Tinder', color: Color(0xFFFF6B35), icon: Icons.local_fire_department),
  const VnService(name: 'TikTok', color: Color(0xFF010101), icon: Icons.music_note),
  const VnService(name: 'Amazon', color: Color(0xFFFF9900), icon: Icons.shopping_bag_outlined),
];

final List<VnCountry> vnCountries = [
  const VnCountry(name: 'Afghanistan', flag: '🇦🇫', dialCode: '+93'),
  const VnCountry(name: 'Albania', flag: '🇦🇱', dialCode: '+355'),
  const VnCountry(name: 'Algeria', flag: '🇩🇿', dialCode: '+213'),
  const VnCountry(name: 'American Samoa', flag: '🇦🇸', dialCode: '+1'),
  const VnCountry(name: 'Andorra', flag: '🇦🇩', dialCode: '+376'),
  const VnCountry(name: 'Angola', flag: '🇦🇴', dialCode: '+244'),
  const VnCountry(name: 'Antigua and Barbuda', flag: '🇦🇬', dialCode: '+1'),
  const VnCountry(name: 'Argentina', flag: '🇦🇷', dialCode: '+54'),
  const VnCountry(name: 'Canada', flag: '🇨🇦', dialCode: '+1'),
  const VnCountry(name: 'United Kingdom', flag: '🇬🇧', dialCode: '+44'),
  const VnCountry(name: 'United States', flag: '🇺🇸', dialCode: '+1'),
  const VnCountry(name: 'Nigeria', flag: '🇳🇬', dialCode: '+234'),
  const VnCountry(name: 'Ghana', flag: '🇬🇭', dialCode: '+233'),
  const VnCountry(name: 'Kenya', flag: '🇰🇪', dialCode: '+254'),
  const VnCountry(name: 'South Africa', flag: '🇿🇦', dialCode: '+27'),
];

// Shared mutable dummy orders list
final List<VnOrder> vnOrders = [
  VnOrder(
    id: '1',
    service: vnServices[0],
    country: vnCountries[8],
    phone: '+1 920723456',
    price: 1.50,
    status: VnStatus.waitingSms,
    secondsLeft: 285,
  ),
  VnOrder(
    id: '2',
    service: vnServices[0],
    country: vnCountries[8],
    phone: '+1 920723456',
    price: 1.50,
    status: VnStatus.completed,
    otpCode: '23456',
  ),
  VnOrder(
    id: '3',
    service: vnServices[0],
    country: vnCountries[8],
    phone: '+1 920723456',
    price: 1.50,
    status: VnStatus.completed,
    otpCode: '78901',
  ),
  VnOrder(
    id: '4',
    service: vnServices[0],
    country: vnCountries[8],
    phone: '+1 920723456',
    price: 1.50,
    status: VnStatus.completed,
    otpCode: '45231',
  ),
];

// ─── Main Virtual Numbers Page ────────────────────────────────────────────────

class VirtualNumber extends StatefulWidget {
  final String title;
  const VirtualNumber({super.key, required this.title});

  @override
  State<VirtualNumber> createState() => _VirtualNumberState();
}

class _VirtualNumberState extends State<VirtualNumber> {
  final Map<String, Timer> _timers = {};

  @override
  void initState() {
    super.initState();
    _startTimers();
  }

  void _startTimers() {
    for (final order in vnOrders) {
      if (order.status == VnStatus.waitingSms && order.secondsLeft > 0) {
        _timers[order.id] = Timer.periodic(const Duration(seconds: 1), (_) {
          if (!mounted) return;
          setState(() {
            if (order.secondsLeft > 0) {
              order.secondsLeft--;
            } else {
              order.status = VnStatus.cancelled;
              _timers[order.id]?.cancel();
            }
          });
        });
      }
    }
  }

  @override
  void dispose() {
    for (final t in _timers.values) {
      t.cancel();
    }
    super.dispose();
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(1, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  int get _totalVerifications => vnOrders.length;
  int get _completedVerifications => vnOrders.where((o) => o.status == VnStatus.completed).length;
  int get _cancelledVerifications => vnOrders.where((o) => o.status == VnStatus.cancelled).length;

  @override
  Widget build(BuildContext context) {
    final recentOrders = vnOrders.take(3).toList();

    return Scaffold(
      backgroundColor: CustomColors.sBackgroundColor,
      appBar: buildAppBar(context: context, title: "Virtual Numbers"),
      body: SingleChildScrollView(
        padding: horizontalPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height20,
            const WalletCard(),
            height20,
            _buildStatsRow(),
            height20,
            CustomButton(
              onTap: () => Navigator.push(context, ScaleTransition1(page: const BuyVirtualNumberPage())).then((_) => setState(() {})),
              buttonText: 'Buy Number',
              buttonColor: CustomColors.sPrimaryColor500,
            ),
            height26,
            _buildRecentOrdersHeader(),
            height12,
            ...recentOrders.map((o) => _buildOrderCard(o)),
            height30,
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatItem('Total\nVerifications', _totalVerifications),
        _buildStatDivider(),
        _buildStatItem('Completed\nVerifications', _completedVerifications),
        _buildStatDivider(),
        _buildStatItem('Cancelled\nVerifications', _cancelledVerifications),
      ],
    );
  }

  Widget _buildStatItem(String label, int value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: CustomTextStyle.kTxtRegular.copyWith(
              fontSize: 11.sp,
              color: CustomColors.sGreyScaleColor500,
              height: 1.4,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '$value',
            style: CustomTextStyle.kTxtBold.copyWith(fontSize: 22.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 40.h,
      color: CustomColors.sDarkColor3,
      margin: EdgeInsets.symmetric(horizontal: 12.w),
    );
  }

  Widget _buildRecentOrdersHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Recent Orders',
          style: CustomTextStyle.kTxtMedium.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        GestureDetector(
          onTap: () => Navigator.push(context, ScaleTransition1(page: const VerificationHistoryPage())).then((_) => setState(() {})),
          child: Text(
            'See all',
            style: CustomTextStyle.kTxtRegular.copyWith(
              fontSize: 13.sp,
              color: CustomColors.sPrimaryColor400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCard(VnOrder order) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: CustomColors.sDarkColor2,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: CustomColors.sDarkColor3, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusBadge(order.status),
          SizedBox(height: 10.h),
          Row(
            children: [
              _buildServiceIcon(order.service),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.service.name,
                      style: CustomTextStyle.kTxtMedium.copyWith(fontSize: 14.sp),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text(
                          order.country.flag,
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          order.phone,
                          style: CustomTextStyle.kTxtRegular.copyWith(
                            fontSize: 13.sp,
                            color: CustomColors.sGreyScaleColor400,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: order.phone));
                            toastMessage('Phone number copied');
                          },
                          child: Icon(Icons.copy_outlined, size: 14.sp, color: CustomColors.sGreyScaleColor500),
                        ),
                      ],
                    ),
                    if (order.status == VnStatus.completed && order.otpCode != null) ...[
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Text(
                            order.otpCode!,
                            style: CustomTextStyle.kTxtRegular.copyWith(
                              fontSize: 13.sp,
                              color: CustomColors.sGreyScaleColor400,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: order.otpCode!));
                              toastMessage('OTP copied');
                            },
                            child: Icon(Icons.copy_outlined, size: 14.sp, color: CustomColors.sGreyScaleColor500),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Text(
                '\$${order.price.toStringAsFixed(2)}',
                style: CustomTextStyle.kTxtMedium.copyWith(fontSize: 14.sp),
              ),
            ],
          ),
          if (order.status == VnStatus.waitingSms) ...[
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Left: ${_formatTime(order.secondsLeft)}',
                  style: CustomTextStyle.kTxtRegular.copyWith(
                    fontSize: 13.sp,
                    color: CustomColors.sGreyScaleColor400,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      order.status = VnStatus.cancelled;
                      _timers[order.id]?.cancel();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 7.h),
                    decoration: BoxDecoration(
                      color: CustomColors.sErrorColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      'Cancel',
                      style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 13.sp),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(VnStatus status) {
    final label = status == VnStatus.waitingSms
        ? 'Waiting SMS'
        : status == VnStatus.completed
            ? 'Completed'
            : 'Cancelled';
    final color = status == VnStatus.waitingSms
        ? CustomColors.sGreenColor500
        : status == VnStatus.completed
            ? CustomColors.sGreyScaleColor500
            : CustomColors.sErrorColor;

    return Row(
      children: [
        Container(
          width: 6.w,
          height: 6.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 12.sp, color: color),
        ),
      ],
    );
  }

  Widget _buildServiceIcon(VnService service) {
    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        color: service.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Icon(service.icon, color: service.color, size: 20.sp),
    );
  }
}

// ─── Buy Virtual Number Page ──────────────────────────────────────────────────

class BuyVirtualNumberPage extends StatefulWidget {
  const BuyVirtualNumberPage({super.key});

  @override
  State<BuyVirtualNumberPage> createState() => _BuyVirtualNumberPageState();
}

class _BuyVirtualNumberPageState extends State<BuyVirtualNumberPage> {
  VnService? _selectedService;
  VnCountry? _selectedCountry;
  final double _price = 1.50;

  void _showServicePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: CustomColors.sDarkColor2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => _ServicePickerSheet(
        onSelected: (s) {
          setState(() => _selectedService = s);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: CustomColors.sDarkColor2,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => _CountryPickerSheet(
        onSelected: (c) {
          setState(() => _selectedCountry = c);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _onBuy() {
    if (_selectedService == null || _selectedCountry == null) {
      toastMessage('Please select a service and country');
      return;
    }
    final order = VnOrder(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      service: _selectedService!,
      country: _selectedCountry!,
      phone: '${_selectedCountry!.dialCode} 920723456',
      price: _price,
      status: VnStatus.waitingSms,
      secondsLeft: 300,
    );
    vnOrders.insert(0, order);
    Navigator.pop(context);
    toastMessage('Number purchased successfully!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.sBackgroundColor,
      appBar: buildAppBar(context: context, title: 'Buy Virtual Number'),
      body: Padding(
        padding: horizontalPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height26,
            _buildSelectorRow(
              label: 'Service',
              child: _selectedService == null
                  ? Text(
                      'Select',
                      style: CustomTextStyle.kTxtRegular.copyWith(
                        fontSize: 14.sp,
                        color: CustomColors.sGreyScaleColor500,
                      ),
                    )
                  : Row(
                      children: [
                        Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: BoxDecoration(
                            color: _selectedService!.color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Icon(_selectedService!.icon, color: _selectedService!.color, size: 14.sp),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          _selectedService!.name,
                          style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp),
                        ),
                      ],
                    ),
              onTap: _showServicePicker,
            ),
            height16,
            _buildSelectorRow(
              label: 'Country',
              child: _selectedCountry == null
                  ? Text(
                      'Select',
                      style: CustomTextStyle.kTxtRegular.copyWith(
                        fontSize: 14.sp,
                        color: CustomColors.sGreyScaleColor500,
                      ),
                    )
                  : Row(
                      children: [
                        Text(_selectedCountry!.flag, style: TextStyle(fontSize: 18.sp)),
                        SizedBox(width: 8.w),
                        Text(
                          _selectedCountry!.name,
                          style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp),
                        ),
                      ],
                    ),
              onTap: _showCountryPicker,
            ),
            height26,
            Text(
              'Amount',
              style: CustomTextStyle.kTxtRegular.copyWith(
                fontSize: 13.sp,
                color: CustomColors.sGreyScaleColor500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              '\$${_price.toStringAsFixed(2)}',
              style: CustomTextStyle.kTxtBold.copyWith(fontSize: 26.sp),
            ),
            const Spacer(),
            CustomButton(
              onTap: _onBuy,
              buttonText: 'Buy',
              buttonColor: CustomColors.sPrimaryColor500,
            ),
            height30,
          ],
        ),
      ),
    );
  }

  Widget _buildSelectorRow({required String label, required Widget child, required VoidCallback onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: CustomTextStyle.kTxtRegular.copyWith(
            fontSize: 13.sp,
            color: CustomColors.sGreyScaleColor500,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: CustomColors.sDarkColor2,
              borderRadius: BorderRadius.circular(10.r),
            ),
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

// ─── Service Picker Sheet ─────────────────────────────────────────────────────

class _ServicePickerSheet extends StatefulWidget {
  final void Function(VnService) onSelected;
  const _ServicePickerSheet({required this.onSelected});

  @override
  State<_ServicePickerSheet> createState() => _ServicePickerSheetState();
}

class _ServicePickerSheetState extends State<_ServicePickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = vnServices.where((s) => s.name.toLowerCase().contains(_query.toLowerCase())).toList();

    return Padding(
      padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 30.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: CustomColors.sDarkColor3,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
          height16,
          Text(
            'Select service',
            style: CustomTextStyle.kTxtMedium.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          height12,
          TextField(
            onChanged: (v) => setState(() => _query = v),
            style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp),
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: CustomTextStyle.kTxtRegular.copyWith(color: CustomColors.sGreyScaleColor500, fontSize: 14.sp),
              filled: true,
              fillColor: CustomColors.sDarkColor3,
              prefixIcon: Icon(Icons.search, color: CustomColors.sGreyScaleColor500, size: 20.sp),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10.r),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 12.h),
            ),
          ),
          height16,
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 1.1,
            ),
            itemCount: filtered.length,
            itemBuilder: (_, i) {
              final s = filtered[i];
              return GestureDetector(
                onTap: () => widget.onSelected(s),
                child: Container(
                  decoration: BoxDecoration(
                    color: CustomColors.sDarkColor3,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          color: s.color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(s.icon, color: s.color, size: 20.sp),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        s.name,
                        style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 11.sp),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─── Country Picker Sheet ─────────────────────────────────────────────────────

class _CountryPickerSheet extends StatefulWidget {
  final void Function(VnCountry) onSelected;
  const _CountryPickerSheet({required this.onSelected});

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = vnCountries.where((c) => c.name.toLowerCase().contains(_query.toLowerCase())).toList();

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
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: CustomColors.sDarkColor3,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            height16,
            Text(
              'Select Country',
              style: CustomTextStyle.kTxtMedium.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            height12,
            TextField(
              onChanged: (v) => setState(() => _query = v),
              style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: CustomTextStyle.kTxtRegular.copyWith(color: CustomColors.sGreyScaleColor500, fontSize: 14.sp),
                filled: true,
                fillColor: CustomColors.sDarkColor3,
                prefixIcon: Icon(Icons.search, color: CustomColors.sGreyScaleColor500, size: 20.sp),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
            height12,
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: filtered.length,
                itemBuilder: (_, i) {
                  final c = filtered[i];
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 2.h),
                    onTap: () => widget.onSelected(c),
                    leading: Text(c.flag, style: TextStyle(fontSize: 26.sp)),
                    title: Text(
                      c.name,
                      style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp),
                    ),
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

// ─── Verification History Page ────────────────────────────────────────────────

class VerificationHistoryPage extends StatefulWidget {
  const VerificationHistoryPage({super.key});

  @override
  State<VerificationHistoryPage> createState() => _VerificationHistoryPageState();
}

class _VerificationHistoryPageState extends State<VerificationHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.sBackgroundColor,
      appBar: buildAppBar(context: context, title: 'Verification history'),
      body: vnOrders.isEmpty
          ? Center(
              child: Text(
                'No verifications yet',
                style: CustomTextStyle.kTxtRegular.copyWith(color: CustomColors.sGreyScaleColor500),
              ),
            )
          : ListView.builder(
              padding: horizontalPadding.copyWith(top: 16.h, bottom: 30.h),
              itemCount: vnOrders.length,
              itemBuilder: (_, i) => _buildHistoryCard(vnOrders[i]),
            ),
    );
  }

  Widget _buildHistoryCard(VnOrder order) {
    final statusLabel = order.status == VnStatus.waitingSms
        ? 'Waiting SMS'
        : order.status == VnStatus.completed
            ? 'Completed'
            : 'Cancelled';
    final statusColor = order.status == VnStatus.waitingSms
        ? CustomColors.sGreenColor500
        : order.status == VnStatus.completed
            ? CustomColors.sGreyScaleColor500
            : CustomColors.sErrorColor;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: CustomColors.sDarkColor2,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: CustomColors.sDarkColor3, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
              ),
              SizedBox(width: 6.w),
              Text(
                statusLabel,
                style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 12.sp, color: statusColor),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: order.service.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(order.service.icon, color: order.service.color, size: 20.sp),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.service.name,
                      style: CustomTextStyle.kTxtMedium.copyWith(fontSize: 14.sp),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text(order.country.flag, style: TextStyle(fontSize: 16.sp)),
                        SizedBox(width: 4.w),
                        Text(
                          order.phone,
                          style: CustomTextStyle.kTxtRegular.copyWith(
                            fontSize: 13.sp,
                            color: CustomColors.sGreyScaleColor400,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: order.phone));
                            toastMessage('Copied');
                          },
                          child: Icon(Icons.copy_outlined, size: 14.sp, color: CustomColors.sGreyScaleColor500),
                        ),
                      ],
                    ),
                    if (order.otpCode != null) ...[
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Text(
                            order.otpCode!,
                            style: CustomTextStyle.kTxtRegular.copyWith(
                              fontSize: 13.sp,
                              color: CustomColors.sGreyScaleColor400,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: order.otpCode!));
                              toastMessage('OTP copied');
                            },
                            child: Icon(Icons.copy_outlined, size: 14.sp, color: CustomColors.sGreyScaleColor500),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Text(
                '\$${order.price.toStringAsFixed(2)}',
                style: CustomTextStyle.kTxtMedium.copyWith(fontSize: 14.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
