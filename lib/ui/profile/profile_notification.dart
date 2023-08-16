import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';

class ProfileNotification extends StatefulWidget {
  const ProfileNotification({super.key});

  @override
  State<ProfileNotification> createState() => _ProfileNotificationState();
}

class _ProfileNotificationState extends State<ProfileNotification> {

  bool _isPushNotificationEnabled=false;
  bool _isSmsNotiEnabled=false;
  bool _isEmailNotiEnabled=false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context: context, title: "Notification Settings"),
        body:  ListView(
          // padding: horizontalPadding,
          shrinkWrap: true,
          children: [
            height18,
            _buildListSwitchTile(svg_img: "bell", title: "Push Notification", subTitle: "Enable or disable push notification", switcghwidget: SizedBox(
              width: 52.w,
              height: 25.h,
              child: Switch.adaptive(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value:_isPushNotificationEnabled,
                activeColor: CustomColors.sWhiteColor,

                inactiveTrackColor: CustomColors.sGreyScaleColor400,
                inactiveThumbColor: Colors.white,
                activeTrackColor:CustomColors.sPrimaryColor500,
                onChanged: (value) {
                  setState(() {
                    _isPushNotificationEnabled = value;
                  });
                },
              ),
            )),
            _buildListSwitchTile(svg_img: "smartphone", title: "SMS Notification", subTitle: "Enable or disable SMS notification", switcghwidget: SizedBox(
              width: 52.w,
              height: 25.h,
              child: Switch.adaptive(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value:_isSmsNotiEnabled,
                activeColor: CustomColors.sWhiteColor,
                inactiveTrackColor: CustomColors.sGreyScaleColor400,
                inactiveThumbColor: Colors.white,
                activeTrackColor:CustomColors.sPrimaryColor500,
                onChanged: (value) {
                  setState(() {
                    _isSmsNotiEnabled = value;
                  });
                },
              ),
            ), ),


            _buildListSwitchTile(svg_img: "eml", title: "Email Notification", subTitle: "Enable or disable email notification", switcghwidget: SizedBox(
              width: 52.w,
              height: 25.h,
              child: Switch.adaptive(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value:_isEmailNotiEnabled,
                activeColor: CustomColors.sWhiteColor,
                inactiveTrackColor: CustomColors.sGreyScaleColor400,
                inactiveThumbColor: Colors.white,
                activeTrackColor:CustomColors.sPrimaryColor500,
                onChanged: (value) {
                  setState(() {
                    _isEmailNotiEnabled = value;
                  });
                },
              ),
            ), ),


          ],
        ));

  }


  _buildListSwitchTile({required String svg_img, required String title,required String subTitle,  required Widget switcghwidget}){
    return ListTile(
      leading: SvgPicture.asset("images/$svg_img.svg"),
      title:Text(title, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400) ),
      subtitle: Text(subTitle, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Color(0xffBDBDBD)) ),
      trailing: switcghwidget,
    );
  }
}
