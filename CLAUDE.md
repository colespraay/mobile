# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

Spraay (package name `spraay`) is a Flutter fintech app (wallet/payments, crypto, events, gift cards, bill payments). Firebase (Core, Messaging, Crashlytics) is wired in `main.dart`. Targets Android, iOS, web, macOS, Linux, Windows, though the active development is mobile-first.

## Common commands

```bash
flutter pub get                     # install dependencies
flutter run                         # run on a connected device/simulator
flutter analyze                     # static analysis (uses analysis_options.yaml / flutter_lints)
flutter test                        # run all tests
flutter test test/widget_test.dart  # run a single test file
flutter build apk --release         # build release APK (Android)
flutter build ios --release         # build release IPA (iOS)
```

There is effectively only one test file (`test/widget_test.dart`, the default counter-app smoke test) — the app has no meaningful automated test coverage. Don't assume behavior is verified by tests; verify manually via `flutter run` when making non-trivial changes.

`en_check_elf_alignment.sh` checks ELF alignment on a release APK (`./en_check_elf_alignment.sh build/app/outputs/apk/release/app-release.apk`), relevant to Play Store 16KB page size requirements.

## Architecture

**State management**: `provider` (ChangeNotifier). All top-level providers are registered once in `main.dart` via `MultiProvider` and injected into the widget tree:
- `AuthProvider`, `CryptoProvider` (in `ui/crypto/crypto.vm.dart` despite the name), `HomeProvider`, `EventProvider`, `TransactionProvider`, `BillPaymentProvider`.

Providers live in `lib/view_model/` (suffix `_provider.dart`), except `CryptoProvider`, which lives alongside its screen at `lib/ui/crypto/crypto.vm.dart` (paired with `lib/ui/crypto/crypto.ui.dart`). Screens call provider methods directly (e.g. `Provider.of<AuthProvider>(context).fetchRegistertEndpoint(...)`); providers own both the network call and the resulting navigation/toast side effects — screens are thin.

**Networking**: A single `ApiServices` class (`lib/services/api_services.dart`) holds every REST endpoint as a method returning `Future<Map<String, dynamic>>` (manually parsed from `models/*` classes into a plain map with an `error`/`message` convention, rather than returning typed model objects to callers). `CryptoServices` (`lib/services/crypto-services.dart`) is a separate client for crypto/Quidax-related endpoints. Both are instantiated once as globals in `lib/components/constant.dart` (`apiResponse`, `cryptoServices`) and used from providers, not constructed per-call. `baseUrl` is also defined there — check it before assuming which backend environment is active.

**Models**: Plain Dart classes under `lib/models/` (one file per response shape, `fromJson`/`toJson`, mostly hand-written not code-generated). `lib/models/giftcard/` groups gift-card-specific models.

**Persistence**: Two separate mechanisms, not interchangeable:
- `MySharedPreference` (`lib/utils/my_sharedpref.dart`) — `shared_preferences` wrapper, static methods, for non-sensitive user/session data (token, name, wallet balance, toggles). Must be initialized once via `MySharedPreference.init()` before use (done in `main()`).
- `SecureStorage` (`lib/utils/secure_storage.dart`) — `flutter_secure_storage` wrapper for sensitive values (password, BVN).

**Navigation**: No named-route table beyond the initial splash route; screens navigate via custom transition classes in `lib/navigations/` (`SlideLeftRoute`, `SlideDownRoute`, `SlideUpRoute`, `fade_route`, `scale_transition`) passed to `Navigator.push`.

**Styling/layout**: `flutter_screenutil` is used everywhere for responsive sizing (`.w`, `.h`, `.sp`) — design size is `428x926` (set in `main.dart`). `lib/components/constant.dart` also predefines many reusable `SizedBox` spacers (`height4`, `height8`, ... ) and shared UI strings/constants — prefer reusing these over ad-hoc `SizedBox`/literal values. `lib/components/themes.dart` holds `CustomColors` and theming constants; `lib/components/reusable_widget.dart` holds shared widgets/toast helpers (e.g. `errorCherryToast`, `toastMessage`).

**Session handling**: `local_session_timeout` is configured in `main.dart` (`SessionConfig`, 20 min inactivity/app-lost-focus) and force-navigates to `LoginScreen` on timeout, coordinated through `AuthProvider.sessionStateStream`.

**Feature folders**: `lib/ui/` is organized by feature (`authentication`, `crypto`, `dashboard`, `events`, `home`, `onboarding`, `others`, `profile`, `wallet`), each containing its screens (and, for crypto, its view model).

## Notes on existing code quality

This codebase predates consistent conventions — expect inconsistent file naming (`kebab-case.dart` mixed with `snake_case.dart`), commented-out dependency versions/URLs left in `pubspec.yaml`, and hardcoded API base URLs. When editing a file, match its existing local convention rather than reformatting unrelated code.
