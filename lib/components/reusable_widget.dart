import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/themes.dart';

class CustomButton extends StatelessWidget {

  CustomButton({
    required this.onTap,
    this.borderRadius,
    this.buttonColor,
    this.textColor,
    this.borderColor,
    required this.buttonText,
    this.height,
    this.width,
    this.textfontSize,
    Key? key,

  }) : super(key: key);



  VoidCallback onTap;
  Color? buttonColor;
  double? borderRadius;
  Color? textColor;
  String buttonText;
  Color? borderColor;
  double? width;
  double ? height;
  double? textfontSize;

  @override
  Widget build(BuildContext context) {

    return Container(
      width: width??double.infinity,
      height: height??58.h,
      decoration: BoxDecoration(
          color: buttonColor ?? Colors.white,
          border: Border.all(color: borderColor ?? Colors.transparent),
          borderRadius: BorderRadius.circular(borderRadius ?? 100.r)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(
                color: textColor??CustomColors.sWhiteColor,
                fontWeight: FontWeight.w700,
                fontSize: textfontSize??16.sp,
                fontFamily: 'Bold',),

            ),

          ),

        ),

      ),

    );

  }

}



AppBar buildAppBar({required BuildContext context, String ?title,
  List<Widget>? action, Color? arrowColor,Brightness? statusBarBrightness,Brightness? statusBarIconBrightness, Color ? backgroundColor }){
  return AppBar(
    backgroundColor: backgroundColor??Colors.transparent,
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: statusBarBrightness??Brightness.dark, statusBarIconBrightness:statusBarIconBrightness?? Brightness.light,statusBarColor: Colors.transparent),

    centerTitle: true,
    leading: GestureDetector(
        onTap: (){Navigator.pop(context);},
        child:  Icon(Icons.arrow_back_outlined, color: arrowColor??Color(0xffFBFBFB),)),
    title: Text(title?? "",
        style: CustomTextStyle.kTxtBold.copyWith(fontSize: 24.sp, fontWeight: FontWeight.w700) ),
    actions:action??[],
  );
}

class CustomizedTextField extends StatelessWidget {
  final TextEditingController ? textEditingController;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final  String ? labeltxt;
  final String ? hintTxt;
  final bool ? obsec;
  final Widget ? surffixWidget;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormat;
  final bool? readOnly;
  final Function()? onTap;
  final int ?maxLines;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final int? maxLength;


  CustomizedTextField({this.textEditingController, this.keyboardType, this.textInputAction, this.labeltxt, this.hintTxt, this.obsec, this.surffixWidget,
    this.inputFormat, this.readOnly,this.onTap, this.maxLines, this.prefixIcon, this.focusNode, this.onChanged, this.maxLength});
//maxLines
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      maxLength:maxLength,
      focusNode:focusNode,
      obscureText: obsec?? false,
      readOnly:readOnly??false ,
      textCapitalization: TextCapitalization.sentences,
      controller: textEditingController,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormat ?? [],
      maxLines: maxLines??1,
      onTap:onTap,
      onChanged: onChanged,
      validator: (value) {
        if (value!.isEmpty) {
          return "Fill empty field";
        } else {
          return null;
        }
      },
      style: CustomTextStyle.kTxtSemiBold.copyWith(color: CustomColors.sGreyScaleColor100,
          fontSize: 14.sp, fontWeight: FontWeight.w500),
      decoration:  InputDecoration(
        labelText: labeltxt,
        hintText: hintTxt,
        isDense: true,
        // contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 0),


        suffixIconConstraints: BoxConstraints(minWidth: 19, minHeight: 19,),
        prefixIconConstraints: prefixIcon==null? BoxConstraints(minWidth: 10, minHeight: 0,):  BoxConstraints(minWidth: 19, minHeight: 19,),

        prefixIcon:prefixIcon?? SizedBox.shrink(),
        suffixIcon: surffixWidget ?? SizedBox.shrink(),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0.1),borderRadius: BorderRadius.circular(8.r),),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: CustomColors.sPrimaryColor500, width: 0.5),borderRadius: BorderRadius.circular(8.r),),
        hintStyle: CustomTextStyle.kTxtRegular.copyWith(color: CustomColors.sGreyScaleColor500, fontSize: 14.sp, fontWeight: FontWeight.w400),

        fillColor:focusNode!.hasFocus? CustomColors.sTransparentPurplecolor :
        CustomColors.sDarkColor2,
        filled: true,
        errorBorder:  OutlineInputBorder(borderSide:  BorderSide(color: Colors.red, width: 0.1.w), borderRadius: BorderRadius.circular(8.r),),
        // border: OutlineInputBorder(borderSide: BorderSide(color: Colors.pinkAccent,width: 0.5.w), borderRadius: BorderRadius.circular(8.r),) ,
        // disabledBorder:OutlineInputBorder(borderSide:  BorderSide(color: Colors.green, width: 1.w),),
        focusedErrorBorder: OutlineInputBorder(borderSide:  BorderSide(color:Colors.transparent, width: 0.1.w), borderRadius: BorderRadius.circular(8.r),),
      ),
    );
  }
}

Widget buildTwoTextWidget({required String title,required String content}){
  return  Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(title,
        style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 16.sp, color: CustomColors.sGreyScaleColor50 ),textAlign: TextAlign.center,),
      Text(content,
        style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 16.sp, color: CustomColors.sPrimaryColor500 ),textAlign: TextAlign.center,),

    ],
  );
}

popupDialog({ required BuildContext context, required String title, required String content, required String buttonTxt,
  required void Function() onTap, required String png_img}){
  double height=MediaQuery.of(context).size.height;
  double width=MediaQuery.of(context).size.width;
  return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (BuildContext context){
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              return Dialog(
                backgroundColor: CustomColors.sDarkColor2,
                insetPadding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.r),),
                child: Container(
                  width: 340.w,
                  decoration: BoxDecoration(
                    color: CustomColors.sDarkColor2,
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 20.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        height40,
                      Image.asset("images/$png_img.png",width: 140.w, height: 140.h),
                      // Container(width: 140.w, height: 140.h, color: Colors.yellow,),
                        height30,
                        Text(title, style: CustomTextStyle.kTxtBold.copyWith(fontSize: 24.sp, fontWeight: FontWeight.w700, color: CustomColors.sPrimaryColor400),),
                        height16,
                        SizedBox(
                          width: 276.w,
                            child: Text(content, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: CustomColors.sWhiteColor),
                            textAlign: TextAlign.center,)),
                        height30,
                        CustomButton(
                            onTap: onTap,
                            buttonText: buttonTxt, borderRadius: 30.r,
                            buttonColor:  CustomColors.sPrimaryColor500),
                      ],
                    ),
                  ),
                ),
              );
            });
      });
}


PreferredSize appBarSize({double ? height, Color? overlaycolor}){
  return PreferredSize(preferredSize: Size.fromHeight(height??16.h), child: AppBar(
    systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light,statusBarColor: Colors.transparent),
    backgroundColor:overlaycolor?? Colors.transparent, elevation: 0,),);

}


void cherryToastInfo(BuildContext context,String titlemsg, String dsc){
  return CherryToast.info(
    title: Text(titlemsg, style: CustomTextStyle.kTxtBold.copyWith(fontSize: 14.sp, color: CustomColors.sWhiteColor, fontWeight: FontWeight.w700),),
    description:Text(dsc, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, color: CustomColors.sWhiteColor, fontWeight: FontWeight.w400),),
    borderRadius: 12,
    backgroundColor: CustomColors.sDarkColor3,
    animationDuration: Duration(milliseconds: 1000),
    autoDismiss: true,
    displayTitle: true,
    toastPosition: Position.top,
    animationType: AnimationType.fromTop,
  ).show(context);
}

void errorCherryToast(BuildContext context,String errordsc){
  return CherryToast.error(
    title: Text(''),
    enableIconAnimation: false,
    displayTitle: false,
    description: Text(errordsc),
    animationType: AnimationType.fromRight,
    animationDuration: Duration(milliseconds: 1000),
    autoDismiss: true,
  ).show(context);
}

Widget buildDottedBorder({required Widget child}){
  return DottedBorder(
    borderType: BorderType.RRect,
    radius: Radius.circular(12.r),
    padding: EdgeInsets.all(2.r),
    color: CustomColors.sGreyScaleColor400,
    strokeWidth: 1,
    child: child,
  );
}

class NumberTextInputFormatter extends TextInputFormatter {
  static const defaultDecimalPlaces = 2;

  final int decimalPlaces;

  NumberTextInputFormatter({this.decimalPlaces = defaultDecimalPlaces});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    double value = double.tryParse(newValue.text) ?? 0.0;
    String newText = NumberFormat.decimalPattern().format(value);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

