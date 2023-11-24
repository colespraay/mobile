import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/scale_transition.dart';
import 'package:spraay/ui/home/bvn_verification.dart';

Future<void> verifyYourIdentityBModal({context}){
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
                        height34,
                        Text("Verify your Identity", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 22.sp, fontWeight: FontWeight.w700,)),
                        height18,
                        Text("Before you can use Spray App, you need to verify your identity to confirm your name, date of birth and to keep Spray App safe", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400,)),
                        height40,

                        InkWell(
                          onTap:(){
                            Navigator.pushReplacement(context, ScaleTransition1(page: BvnVerification()));
                          },
                          child: Container(
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                                color: CustomColors.sTransparentPurplecolor,
                                borderRadius: BorderRadius.all(Radius.circular(30.r)),
                                border: Border.all(color: CustomColors.sGreyScaleColor300)
                            ),
                            child:   Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset("images/profile_avatar.svg", width: 60.w, height: 60.h,),
                                SizedBox(width: 12.w,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Verify via BVN", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500, color: CustomColors.sPrimaryColor100)),
                                      height4,
                                      Text("Verify your account using your Bank Verification Number (BVN)", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400)),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        height22,


                        // height30,
                      ],
                    )
                ),
              )

      ));
}


