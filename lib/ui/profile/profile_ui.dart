import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/ui/profile/account_security/acount_security.dart';
import 'package:spraay/ui/profile/help_and_support.dart';
import 'package:spraay/ui/profile/user_profile/edit_profile.dart';

class ProfileUi extends StatefulWidget {
  const ProfileUi({super.key});

  @override
  State<ProfileUi> createState() => _ProfileUiState();
}

class _ProfileUiState extends State<ProfileUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarSize(),
        body:  ListView(
          shrinkWrap: true,
          children: [
            _buildProfile(),
            height50,
            _buildListTile(svg_img: 'profile_avat', title: 'Edit Profile', onTap: ()=> Navigator.push(context,SlideLeftRoute(page: EditProfile()))),
            _buildListTile(svg_img: 'lock_outline', title: 'Account Security', onTap: ()=>Navigator.push(context,SlideLeftRoute(page: AccountSecurity())) ),
            _buildListTile(svg_img: 'bell', title: 'Notification', onTap: (){}),
            _buildListTile(svg_img: 'Info_Square', title: 'Support and Help Center', onTap: ()=> Navigator.push(context,SlideLeftRoute(page: HelpAndSupportScreen())) ),
            _buildListTile(svg_img: 'dload', title: 'Download Account Statement', onTap: () {  }),
            _buildListTile(svg_img: 'privacy', title: 'Privacy Policy', onTap: () {  }),
            _buildListTile(svg_img: 'privacy', title: 'Privacy Policy', onTap: () {  }),
            _buildListTile(svg_img: 'logout', title: 'Logout', onTap: () {  }),
            height50
          ],
        ));
  }

  Widget _buildProfile(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Profile", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 24.sp, fontWeight: FontWeight.w700) ),
        height40,
        Container(
          width: 120.w,
          height: 120.h,
          decoration: BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle
          ),
        ),
        height16,
        Text("Uche Usman", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700) ),
        height4,
        Text("@uche911", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w400) ),
      ],
    );
  }

  _buildListTile({required String svg_img, required String title,required Function()? onTap}){
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: SvgPicture.asset("images/$svg_img.svg"),
        title:Text(title, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: title=="Logout"? CustomColors.sErrorColor: CustomColors.sWhiteColor) ),
        trailing: SvgPicture.asset("images/arrow_left.svg", color: Colors.white,),
      ),
    );
  }
}
