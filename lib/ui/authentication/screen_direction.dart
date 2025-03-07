import 'package:flutter/material.dart';
import 'package:spraay/ui/authentication/login_screen.dart';
import 'package:spraay/ui/onboarding/onboarding.dart';
import 'package:spraay/utils/my_sharedpref.dart';

class ScreenDirection extends StatefulWidget {
  const ScreenDirection({Key? key}) : super(key: key);

  @override
  State<ScreenDirection> createState() => _ScreenDirectionState();
}

class _ScreenDirectionState extends State<ScreenDirection> {
  Future<bool> visitingflag=  MySharedPreference.getVisitingFlag();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: visitingflag,
      builder: (context, snapshot){
        if( snapshot.data==null || snapshot.data==false){
          return OnboardingScreen() ;
        }
        else{
          return LoginScreen();
        }
      },
    );

  }
}
