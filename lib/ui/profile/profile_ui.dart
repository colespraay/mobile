import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/authentication/login_screen.dart';
import 'package:spraay/ui/profile/account_security/acount_security.dart';
import 'package:spraay/ui/profile/download_account_screen.dart';
import 'package:spraay/ui/profile/help_and_support.dart';
import 'package:spraay/ui/profile/privacy_policy.dart';
import 'package:spraay/ui/profile/profile_notification.dart';
import 'package:spraay/ui/profile/user_profile/edit_profile.dart';
import 'package:spraay/ui/profile/user_profile/terms_and_condition.dart';
import 'package:spraay/ui/profile/user_profile/view_profile_picture.dart';
import 'package:spraay/utils/my_sharedpref.dart';
import 'package:spraay/view_model/auth_provider.dart';

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
            _buildListTile(svg_img: 'profile_avat', title: 'Edit Profile', onTap: (){
              if(credentialsProvider?.dataResponse==null){
                toastMessage("Click again in few seconds time");
              }else{
                Navigator.push(context,SlideLeftRoute(page: EditProfile(credentialsProvider?.dataResponse)));
              }
            }),
            _buildListTile(svg_img: 'lock_outline', title: 'Account Security', onTap: ()=>Navigator.push(context,SlideLeftRoute(page: const AccountSecurity())) ),
            _buildListTile(svg_img: 'bell', title: 'Notification', onTap: ()=>Navigator.push(context,SlideLeftRoute(page: const ProfileNotification())).then((value) => Provider.of<AuthProvider>(context, listen: false).fetchUserDetailApi())
            ),
            _buildListTile(svg_img: 'Info_Square', title: 'Support and Help Center', onTap: ()=> Navigator.push(context,SlideLeftRoute(page: const HelpAndSupportScreen())) ),
            _buildListTile(svg_img: 'dload', title: 'Download Account Statement', onTap: ()=>Navigator.push(context,SlideLeftRoute(page: const DownloadAccountUi())) ),
            _buildListTile(svg_img: 'privacy', title: 'Privacy Policy', onTap: ()=>Navigator.push(context,SlideLeftRoute(page: const PrivacyPolicy()))),
            _buildListTile(svg_img: 'privacy', title: 'Terms and Conditions', onTap: ()=>Navigator.push(context,SlideLeftRoute(page: const TermsAndCondition()))),
            _buildListTile(svg_img: 'logout', title: 'Logout', onTap: ()=> _logoutModal()),
            _buildListTile(svg_img: 'logout', title: 'Delete Account', onTap: ()=> _deleteModal()),

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
        InkWell(
          onTap:(){
            Navigator.push(context,FadeRoute(page:ViewProfile(imageUrl:  credentialsProvider?.dataResponse?.profileImageUrl??"") ));
          },
            child: Hero(tag: "hero_image",
            child: buildCircularNetworkImage(imageUrl: credentialsProvider?.dataResponse?.profileImageUrl??"", radius: 70.r))),
        height16,
        Text("${credentialsProvider?.dataResponse?.firstName??""} ${credentialsProvider?.dataResponse?.lastName??""}", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700) ),
        height4,
        Text("${credentialsProvider?.dataResponse?.userTag}", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w400) ),
      ],
    );
  }

  _buildListTile({required String svg_img, required String title,required Function()? onTap}){
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: SvgPicture.asset("images/$svg_img.svg"),
        title:Text(title, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: title=="Logout" || title=="Delete Account"? CustomColors.sErrorColor: CustomColors.sWhiteColor) ),
        trailing: SvgPicture.asset("images/arrow_left.svg", color: Colors.white,),
      ),
    );
  }


  final sessionStateStream = StreamController<SessionState>();

  Future<void> _logoutModal(){
    return  showModalBottomSheet(
        context: context,
        backgroundColor: CustomColors.sDarkColor2,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r),),),
        builder: (context)=> StatefulBuilder(
            builder: (context, setState)=>
                Container(
                  width: double.infinity,
                  child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            height16,
                            Center(child: SvgPicture.asset("images/homedicator.svg")),
                            height26,
                            Center(
                              child: Text("Are you sure you want to log out?", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700, color: CustomColors.sWhiteColor, fontFamily: "SemiPlusJakartaSans"),
                                textAlign: TextAlign.center,),
                            ),

                            height26,
                            CustomButton(
                                onTap: (){
                                  sessionStateStream.add(SessionState.stopListening);

                                  Navigator.pushAndRemoveUntil(context, FadeRoute(page: const LoginScreen()),(Route<dynamic> route) => false);
                                  Provider.of<AuthProvider>(context, listen: false).onItemTap(0);
                                },
                                buttonText: "Yes, logout", borderRadius: 30.r,
                                buttonColor:  CustomColors.sErrorColor),
                            height22,
                            CustomButton(
                                onTap:(){
                                  Navigator.pop(context);
                                },
                                buttonText: "Cancel", borderRadius: 30.r,
                                buttonColor:  CustomColors.sDarkColor3),
                            height22,


                            // height30,
                          ],
                      )
                  ),
                )

        ));
  }

  Future<void> _deleteModal(){
    return  showModalBottomSheet(
        context: context,
        backgroundColor: CustomColors.sDarkColor2,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r),),),
        builder: (context)=> StatefulBuilder(
            builder: (context, setState)=>
                Container(
                  width: double.infinity,
                  child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          height16,
                          Center(child: SvgPicture.asset("images/homedicator.svg")),
                          height26,
                          Center(
                            child: Text("Are you sure you want to delete this account?", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700, color: CustomColors.sWhiteColor, fontFamily: "SemiPlusJakartaSans"),
                              textAlign: TextAlign.center,),
                          ),

                          height26,
                          CustomButton(
                              onTap: (){
                                // Navigator.pop(context);
                                sessionStateStream.add(SessionState.stopListening);

                                Provider.of<AuthProvider>(context, listen: false).deleteAccountEndpoint(context, MySharedPreference.getUId());
                              },
                              buttonText: "Yes, delete account", borderRadius: 30.r,
                              buttonColor:  CustomColors.sErrorColor),
                          height22,
                          CustomButton(
                              onTap:(){
                                Navigator.pop(context);
                              },
                              buttonText: "Cancel", borderRadius: 30.r,
                              buttonColor:  CustomColors.sDarkColor3),
                          height22,


                          // height30,
                        ],
                      )
                  ),
                )

        ));
  }



  AuthProvider? credentialsProvider;
  @override
  void didChangeDependencies() {
    credentialsProvider=context.watch<AuthProvider>();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    Provider.of<AuthProvider>(context, listen: false).fetchUserDetailApi();
  }
}
