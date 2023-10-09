import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/services/api_services.dart';
import 'package:spraay/ui/others/spray_gifting/send_to_bank.dart';
import 'package:spraay/ui/wallet/withdrawal/to_bank_account.dart';
import 'package:spraay/utils/my_sharedpref.dart';

class SprayGifting extends StatefulWidget {
  const SprayGifting({Key? key}) : super(key: key);

  @override
  State<SprayGifting> createState() => _SprayGiftingState();
}

class _SprayGiftingState extends State<SprayGifting> {
  TextEditingController phoneController=TextEditingController();
  FocusNode? _textField1Focus;
  @override
  void initState() {
    setState(() {
      _textField1Focus = FocusNode();
    });
  }

  String firstBtn="";
  @override
  void dispose() {
    _textField1Focus?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return LoadingOverlayWidget(
      loading: _isLoading,
      child: Scaffold(
          appBar: buildAppBar(context: context, title: "Gift Friend"),
          body:  Padding(
            padding: horizontalPadding,
            child: ListView(
              shrinkWrap: true,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height22,
                Center(child: Text("Enter Amount", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400))),
                height26,
                TextFormField(
                  controller: phoneController,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  style: CustomTextStyle.kTxtBold.copyWith(color: CustomColors.sGreyScaleColor100, fontSize: 40.sp, fontWeight: FontWeight.bold),
                  onChanged:(value){
                    setState(() {firstBtn=value;});
                  },

                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    NumberTextInputFormatter()
                  ],
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 0.1.h, horizontal: 0),
                    prefixText: "₦",
                    prefixStyle:  CustomTextStyle.kTxtBold.copyWith(color: CustomColors.sGreyScaleColor100, fontSize: 40.sp, fontWeight: FontWeight.bold, fontFamily: "PlusJakartaSans"),
                  ),

                ),
                height26,

                height50,

                CustomButton(
                    onTap: () {
                      if(firstBtn.isNotEmpty){
                        fetchCheckbalanceBeforeWithdrawingApiPinApi(context, phoneController.text.replaceAll(",", ""));
                      }
                    },
                    buttonText: 'Continue', borderRadius: 30.r,width: 380.w,
                    buttonColor: firstBtn.isNotEmpty ? CustomColors.sPrimaryColor500:
                    CustomColors.sDisableButtonColor),

                height40

              ],
            ),
          )),
    );
  }


  bool _isLoading=false;
  fetchCheckbalanceBeforeWithdrawingApiPinApi(BuildContext context ,String amount) async{
    setState(() {_isLoading=true;});
    var result=await ApiServices().checkbalanceBeforeWithdrawingApi(MySharedPreference.getToken(), amount);
    if(result['error'] == true){

      popupDialog(context: context, title: "Transaction Failed", content:result['message'],
          buttonTxt: 'Try again', onTap: () {Navigator.pop(context);}, png_img: 'Incorrect_sign');

    }else{

      Navigator.push(context, SlideLeftRoute(page: SendToBank(giftAmount: phoneController.text,)));

    }

    setState(() {_isLoading=false;});
  }


}
