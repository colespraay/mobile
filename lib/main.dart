import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/splash_screen.dart';
import 'package:spraay/ui/authentication/login_screen.dart';
import 'package:spraay/utils/my_sharedpref.dart';
import 'package:spraay/view_model/auth_provider.dart';
import 'package:spraay/view_model/bill_payment_provider.dart';
import 'package:spraay/view_model/event_provider.dart';
import 'package:spraay/view_model/home_provider.dart';
import 'package:spraay/view_model/transaction_provider.dart';

Future main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await MySharedPreference.init();
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
            ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
            ChangeNotifierProvider<EventProvider>(create: (_) => EventProvider()),
            ChangeNotifierProvider<TransactionProvider>(create: (_) => TransactionProvider()),
            ChangeNotifierProvider<BillPaymentProvider>(create: (_) => BillPaymentProvider()),
          ],
          child:  MyApp()));
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {

    final sessionConfig = SessionConfig(
      invalidateSessionForAppLostFocus:  Duration(minutes: 20),
      invalidateSessionForUserInactivity:  Duration(minutes: 20),);
    sessionConfig.stream.listen((SessionTimeoutState timeoutEvent) {
      // stop listening, as user will already be in auth page
      Provider.of<AuthProvider>(context, listen: false).sessionStateStream.add(SessionState.stopListening);
      if (timeoutEvent == SessionTimeoutState.userInactivityTimeout) {
        _navigator.pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen(),),(Route<dynamic> route) => false);
      } else if (timeoutEvent == SessionTimeoutState.appFocusTimeout) {
        // handle user  app lost focus timeout
        _navigator.pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen(),),(Route<dynamic> route) => false);
      }
    });

    return SessionTimeoutManager(
      sessionConfig: sessionConfig,
      sessionStateStream: Provider.of<AuthProvider>(context, listen: false).sessionStateStream.stream,
      child: ScreenUtilInit(
        designSize: Size(428, 926),
        minTextAdapt: true,
        splitScreenMode: true,
        useInheritedMediaQuery: true,
        builder:(context, child)=>  MaterialApp(
          title: 'Spraay',
          navigatorKey: _navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            scaffoldBackgroundColor: CustomColors.sBackgroundColor
          ),
          builder: (context, widget) {
            return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), child: widget!);
          },
          initialRoute: SplashScreen.id,
          routes: {
            SplashScreen.id:(context) =>SplashScreen(),
          },
        ),
      ),
    );
  }
}

