import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/ui/profile/change_password/change_password_otp.dart';
import 'package:spraay/ui/profile/reset_trans_pin/reset_transaction_pin.dart';
import 'package:spraay/view_model/auth_provider.dart';
import 'package:spraay/view_model/home_provider.dart';

class AccountSecurity extends StatefulWidget {
  const AccountSecurity({super.key});

  @override
  State<AccountSecurity> createState() => _AccountSecurityState();
}

class _AccountSecurityState extends State<AccountSecurity> {
  @override
  void initState() {
    getSwitchValues();
    getSwitchValuesForTouchID();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context: context, title: "Account Security"),
        body:  ListView(
          // padding: horizontalPadding,
          shrinkWrap: true,
          children: [
            height18,
            _buildListTile(svg_img: "profile_avat", title: "Change Password", subTitle: "Update your password", onTap: ()=>Navigator.push(context,SlideLeftRoute(page: ChangePasswordOtp())) ),
            _buildListTile(svg_img: "bell", title: "Reset Transaction PIN", subTitle: "Change your transaction password", onTap: ()=>Navigator.push(context,SlideLeftRoute(page: ResetTransactionPin())) ),
            _buildListSwitchTile(svg_img: "scanner", title: "Biometric", subTitle: "Enable or deactivate Face ID", switcghwidget: SizedBox(
              width: 52.w,
              height: 25.h,
              child: Switch.adaptive(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value:_isBiometricsEnabled,
                activeColor: CustomColors.sWhiteColor,

                inactiveTrackColor: CustomColors.sGreyScaleColor400,
                inactiveThumbColor: Colors.white,
                activeTrackColor:CustomColors.sPrimaryColor500,
                onChanged: (enableBiometrics) {
                  setState(() {
                    _isBiometricsEnabled = enableBiometrics;

                    if (enableBiometrics == false) {
                      saveSwitchStateTouchID(enableBiometrics);
                      Provider.of<AuthProvider>(context, listen: false).changeSwitch(enableBiometrics);
                    } else {
                      saveSwitchStateTouchID(enableBiometrics);
                      Provider.of<AuthProvider>(context, listen: false).changeSwitch(enableBiometrics);
                    }
                  });

                },
              ),
            )),
            _buildListSwitchTile(svg_img: "wallet", title: "Wallet Balance", subTitle: "Hide or show wallet balance", switcghwidget: SizedBox(
              width: 52.w,
              height: 25.h,
              child: Switch.adaptive(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value:_sWvalue??false,
                activeColor: CustomColors.sWhiteColor,
                inactiveTrackColor: CustomColors.sGreyScaleColor400,
                inactiveThumbColor: Colors.white,
                activeTrackColor:CustomColors.sPrimaryColor500,
                onChanged:_onSWChange,
              ),
            ), ),

          ],
        ));

  }

  _buildListTile({required String svg_img, required String title,required String subTitle,  required Function()? onTap}){
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: SvgPicture.asset("images/$svg_img.svg"),
        title:Text(title, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400) ),
        subtitle: Text(subTitle, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Color(0xffBDBDBD)) ),
        trailing: SvgPicture.asset("images/arrow_left.svg", color: Colors.white,),
      ),
    );
  }

  _buildListSwitchTile({required String svg_img, required String title,required String subTitle,  required Widget switcghwidget}){
    return ListTile(
      leading: SvgPicture.asset("images/$svg_img.svg"),
      title:Text(title, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400) ),
      subtitle: Text(subTitle, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Color(0xffBDBDBD)) ),
      trailing: switcghwidget,
    );
  }



  //biometric
  bool _isBiometricsEnabled = false;
  Future<bool?> getSwitchStateTouchID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isSwitchedFT =  prefs.getBool("switchStateTouchID");
    return isSwitchedFT;
  }
  getSwitchValuesForTouchID() async {
    bool? switchstate = await getSwitchStateTouchID();
    if(switchstate==null){
      switchstate=false;
    }
    setState(() {
      if (switchstate == false) {_isBiometricsEnabled=false;}
      else {_isBiometricsEnabled = switchstate!;}
    });
  }
  Future<bool> saveSwitchStateTouchID(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool("switchStateTouchID", value);
  }

  //wallet balance
  bool?_sWvalue;
  void _onSWChange(bool myvalue) {
    setState(() {
      _sWvalue = myvalue;

      if (myvalue == false) {
        saveSwitchState(myvalue);
        Provider.of<HomeProvider>(context, listen: false).changeSwitchForWallet(myvalue);
        // removeValue();
      } else {
        saveSwitchState(myvalue);
        Provider.of<HomeProvider>(context, listen: false).changeSwitchForWallet(myvalue);
      }
    });



  }

  getSwitchValues() async {
    bool? toggleon = await getSwitchState();

    if (toggleon == null) {
      print(" showNull==$toggleon");
    } else {
      setState(() {_sWvalue = toggleon;});
    }
  }

  removeValue() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('switchState');
  }

  Future<bool> saveSwitchState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool("switchState", value);
  }

  Future<bool?> getSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isSwitchedFT = prefs.getBool("switchState");
    return isSwitchedFT;
  }

}
