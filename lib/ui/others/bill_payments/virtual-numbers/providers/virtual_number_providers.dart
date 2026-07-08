import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spraay/models/virtual_number/vn_country.dart';
import 'package:spraay/models/virtual_number/vn_dashboard.dart';
import 'package:spraay/models/virtual_number/vn_order.dart';
import 'package:spraay/models/virtual_number/vn_orders_page.dart';
import 'package:spraay/models/virtual_number/vn_price.dart';
import 'package:spraay/models/virtual_number/vn_service.dart';
import 'package:spraay/services/virtual_number_service.dart';

final virtualNumberServiceProvider = Provider<VirtualNumberService>((ref) => VirtualNumberService());

/// Full, unfiltered service catalog - fetched once and cached for the app
/// session so the picker sheet opens instantly on repeat visits.
final vnServicesProvider = FutureProvider<List<VnService>>((ref) {
  return ref.watch(virtualNumberServiceProvider).getServices();
});

/// Full, unfiltered country catalog - same caching rationale as [vnServicesProvider].
final vnCountriesProvider = FutureProvider<List<VnCountry>>((ref) {
  return ref.watch(virtualNumberServiceProvider).getCountries();
});

final vnServiceSearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');
final vnCountrySearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

const _searchDebounce = Duration(milliseconds: 350);

/// Debounced, server-side filtered service list. Falls back to the cached
/// full catalog when the query is empty so clearing search is instant.
final vnFilteredServicesProvider = FutureProvider.autoDispose<List<VnService>>((ref) async {
  final query = ref.watch(vnServiceSearchQueryProvider).trim();
  if (query.isEmpty) return ref.watch(vnServicesProvider.future);
  await Future.delayed(_searchDebounce);
  return ref.watch(virtualNumberServiceProvider).searchServices(query);
});

/// Debounced, server-side filtered country list. See [vnFilteredServicesProvider].
final vnFilteredCountriesProvider = FutureProvider.autoDispose<List<VnCountry>>((ref) async {
  final query = ref.watch(vnCountrySearchQueryProvider).trim();
  if (query.isEmpty) return ref.watch(vnCountriesProvider.future);
  await Future.delayed(_searchDebounce);
  return ref.watch(virtualNumberServiceProvider).searchCountries(query);
});

typedef VnPriceParams = ({String service, String country});

final vnPriceProvider = FutureProvider.autoDispose.family<VnPrice, VnPriceParams>((ref, params) {
  return ref.watch(virtualNumberServiceProvider).getPrice(service: params.service, country: params.country);
});

class VnDashboardNotifier extends AsyncNotifier<VnDashboard> {
  @override
  Future<VnDashboard> build() => ref.watch(virtualNumberServiceProvider).getDashboard();

  Future<void> refresh() async {
    state = const AsyncLoading<VnDashboard>().copyWithPrevious(state);
    state = await AsyncValue.guard(() => ref.read(virtualNumberServiceProvider).getDashboard());
  }
}

final vnDashboardProvider = AsyncNotifierProvider<VnDashboardNotifier, VnDashboard>(VnDashboardNotifier.new);

class VnOrdersNotifier extends AsyncNotifier<VnOrdersPage> {
  @override
  Future<VnOrdersPage> build() => ref.watch(virtualNumberServiceProvider).getOrders();

  Future<void> refresh() async {
    state = const AsyncLoading<VnOrdersPage>().copyWithPrevious(state);
    state = await AsyncValue.guard(() => ref.read(virtualNumberServiceProvider).getOrders());
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore) return;
    final next = await ref.read(virtualNumberServiceProvider).getOrders(page: current.page + 1, limit: current.limit);
    state = AsyncData(VnOrdersPage(
      orders: [...current.orders, ...next.orders],
      page: next.page,
      limit: next.limit,
      total: next.total,
    ));
  }
}

final vnOrdersProvider = AsyncNotifierProvider<VnOrdersNotifier, VnOrdersPage>(VnOrdersNotifier.new);

/// Tracks a single order and, while it's still waiting on an SMS, polls the
/// provider for status updates so the OTP appears without the user having
/// to manually refresh.
class VnOrderNotifier extends FamilyAsyncNotifier<VnOrder, String> {
  Timer? _pollTimer;

  @override
  Future<VnOrder> build(String arg) async {
    ref.onDispose(() => _pollTimer?.cancel());
    final order = await ref.watch(virtualNumberServiceProvider).getOrder(arg);
    _schedulePoll(order);
    return order;
  }

  void _schedulePoll(VnOrder order) {
    _pollTimer?.cancel();
    if (!order.status.isActive) return;
    _pollTimer = Timer(const Duration(seconds: 4), () async {
      final refreshed = await AsyncValue.guard(() => ref.read(virtualNumberServiceProvider).getOrder(arg));
      state = refreshed;
      refreshed.whenData(_schedulePoll);
    });
  }

  Future<void> cancel() async {
    await ref.read(virtualNumberServiceProvider).cancelOrder(arg);
    _pollTimer?.cancel();
    final current = state.valueOrNull;
    if (current != null) state = AsyncData(current.copyWith(status: VnOrderStatus.cancelled));
    ref.invalidate(vnDashboardProvider);
    ref.invalidate(vnOrdersProvider);
  }

  Future<void> resend() async {
    await ref.read(virtualNumberServiceProvider).resendOrder(arg);
    final refreshed = await AsyncValue.guard(() => ref.read(virtualNumberServiceProvider).getOrder(arg));
    state = refreshed;
    refreshed.whenData(_schedulePoll);
  }
}

final vnOrderProvider = AsyncNotifierProvider.family<VnOrderNotifier, VnOrder, String>(VnOrderNotifier.new);

/// One-shot action notifier for the buy flow. Kept separate from
/// [vnOrdersProvider]/[vnDashboardProvider] so the buy button's loading
/// state doesn't get tangled up with list-refresh loading states.
class VnBuyNotifier extends AsyncNotifier<VnOrder?> {
  @override
  VnOrder? build() => null;

  Future<VnOrder> buy({
    required String service,
    required String country,
    required String transactionPin,
    double maxPrice = 0,
  }) async {
    state = const AsyncLoading<VnOrder?>().copyWithPrevious(state);
    final result = await AsyncValue.guard(() => ref.read(virtualNumberServiceProvider).buyNumber(
          service: service,
          country: country,
          transactionPin: transactionPin,
          maxPrice: maxPrice,
        ));
    state = result;
    final order = result.value;
    if (result.hasError || order == null) {
      throw result.error ?? const VirtualNumberException('Purchase failed');
    }
    ref.invalidate(vnDashboardProvider);
    ref.invalidate(vnOrdersProvider);
    return order;
  }

  void reset() => state = const AsyncData(null);
}

final vnBuyNotifierProvider = AsyncNotifierProvider<VnBuyNotifier, VnOrder?>(VnBuyNotifier.new);
