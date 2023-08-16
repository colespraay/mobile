import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/splash_screen.dart';
import 'package:spraay/utils/my_sharedpref.dart';
import 'package:spraay/view_model/auth_provider.dart';
import 'package:spraay/view_model/home_provider.dart';

Future main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await MySharedPreference.init();
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
            ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
          ],
          child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder:(context, child)=>  MaterialApp(
        title: 'Spray',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          scaffoldBackgroundColor: CustomColors.sBackgroundColor
        ),
        builder: (context, widget) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget!,
          );
        },
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id:(context) =>SplashScreen(),
        },
      ),
    );
  }
}

