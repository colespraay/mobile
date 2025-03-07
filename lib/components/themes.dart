import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomColors {
  static const Color sBackgroundColor = Color(0xFF09090B);
  static const Color sPrimaryColor500= Color(0xFF5B45FF);
  static const Color sPrimaryColor400= Color(0xFF7664FF);
  static const Color sPrimaryColor100= Color(0xFFEEECFF);
  static const Color sWhiteColor=Color(0xffFFFFFF);
  static const Color sDisableButtonColor= Color(0xFF747474);
  static const Color sGreyScaleColor50= Color(0xFFFAFAFA);
  static const Color sTransparentPurplecolor= Color(0x405B45FF);
  static const Color sGreyScaleColor100=Color(0xffF5F5F5);
  static const Color sGreyScaleColor700= Color(0xFF616161);
  static const Color sGreyScaleColor800= Color(0xFF424242);
  static const Color sGreyScaleColor900= Color(0xFF212121);
  static const Color sDarkColor2= Color(0xFF1A1A21);
  static const Color sDarkColor3= Color(0xFF35383F);
  static const Color sGreyScaleColor500= Color(0xFF9E9E9E);
  static const Color sGreyScaleColor400= Color(0xffBDBDBD);
  static const Color sGreyScaleColor300= Color(0xffE0E0E0);
  static const Color sSecondaryColor500= Color(0xff246BFD);
  static const Color sGreenColor500= Color(0xffD3F701);
  static const Color sErrorColor= Color(0xffF75555);
  static const Color sSuccessColor= Color(0xff4ADE80);
}

class CustomTextStyle{

  static TextStyle kTxtRegular = TextStyle(
    color: CustomColors.sWhiteColor,
    fontSize: 12.sp,
    fontFamily: 'Regular',
  );

  static TextStyle kTxtMedium = TextStyle(
    color:CustomColors.sWhiteColor ,
    fontSize: 16.sp,
    fontFamily: 'Medium',
  );

  static TextStyle kTxtSemiBold = TextStyle(
    color: CustomColors.sGreyScaleColor50,
    fontSize: 18.sp,
    fontFamily: 'SemiBold',
  );
  static TextStyle kTxtBold= TextStyle(
    color: CustomColors.sWhiteColor,
    fontSize: 38.sp,
    fontFamily: 'Bold',
  );


}
