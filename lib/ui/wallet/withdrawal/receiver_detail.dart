import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/list_of_banks_model.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/services/api_services.dart';
import 'package:spraay/ui/wallet/withdrawal/withdrawal_pin.dart';
import 'package:spraay/utils/my_sharedpref.dart';

class ReceiverDetailScreen extends StatefulWidget {
  DatumBankModel? bankDetail;
  String amount;
   ReceiverDetailScreen(this.bankDetail, this.amount) ;

  @override
  State<ReceiverDetailScreen> createState() => _ReceiverDetailScreenState();
}

class _ReceiverDetailScreenState extends State<ReceiverDetailScreen> {

  TextEditingController accNumberController=TextEditingController();
  bool _isObscure = true;

  FocusNode? _textField1Focus;
  @override
  void initState() {
    setState(() {
      _textField1Focus = FocusNode();
    });
  }

  String accountNumber="";
  String secondBtn="";




  bool _isLoading=false;
  String accountName="";

  fetchTransactionPinApi(BuildContext context ,String accountNo,) async{
    setState(() {_isLoading=true;});
    var result=await ApiServices().userSaveBankApi(MySharedPreference.getToken(), widget.bankDetail?.bankCode??"", accountNo);
    if(result['error'] == true){
      setState(() {
        accountName=result["message"];
      });

    }else{

      setState(() {
        accountName=result["accountName"];
        accountNumber=result["accountNumber"];
      });
    }

    setState(() {_isLoading=false;});

  }

  @override
  void dispose() {
    _textField1Focus?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context: context, title: "Receiver Details"),
        body:  Padding(
          padding: horizontalPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height26,
              buildContainer(),
              height18,
              CustomizedTextField(textEditingController:accNumberController, keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,hintTxt: "1234567890",focusNode: _textField1Focus,
                // maxLength: 10,
                inputFormat: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged:(value){
                if(value.length==10){
                  fetchTransactionPinApi(context, value);
                }

                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _isLoading? Padding(
                    padding:  EdgeInsets.only(right: 12.w),
                    child: SpinKitFadingCircle(size: 25.r,color: Colors.grey,),
                  ):SizedBox.shrink(),

                  Text(accountName, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Color(0xffFAFAFA))),
                ],
              ),


              Spacer(),
              buildInfo(),
              height8,

              CustomButton(
                  onTap: () {
                    if( accountNumber.isNotEmpty){
                      Navigator.push(context, SlideLeftRoute(page: WithdrawalOtp(fromWhere: 'new_bank_screen',
                        bankCode: widget.bankDetail?.bankCode??"", bankName: widget.bankDetail?.bankName??"", amount:widget.amount, accountNumber: accountNumber,
                        accountName: accountName,)));
                      // MySharedPreference.setVisitingFlag();
                      // Navigator.pushAndRemoveUntil(context, FadeRoute(page: DasboardScreen()),(Route<dynamic> route) => false);

                    }
                  },
                  buttonText: 'Next', borderRadius: 30.r,width: 380.w,
                  buttonColor: accountNumber.isNotEmpty ? CustomColors.sPrimaryColor500:
                  CustomColors.sDisableButtonColor),
              height12,
              CustomButton(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  buttonText: 'Edit Details', borderRadius: 30.r,width: 380.w,
                  buttonColor: CustomColors.sDarkColor3),
              height12,




            ],
          ),
        ));
  }

  Widget buildContainer(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
                color: CustomColors.sTransparentPurplecolor,
                shape: BoxShape.circle
            ),
            child: Center(child: Text(getInitials(widget.bankDetail?.bankName??""), style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400)))),
        SizedBox(width: 16.w,),
        Expanded(child: Text(widget.bankDetail?.bankName??"", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400))),

        GestureDetector(
          onTap:(){
            Navigator.pop(context);
          },
            child: SvgPicture.asset("images/edit.svg", width: 30.w, height: 30.h,)),
      ],
    );
  }

  Widget buildInfo(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:  EdgeInsets.only(top: 4.h),
          child: SvgPicture.asset("images/warning_triangle.svg", width: 25.w, height: 25.h,),
        ),
        SizedBox(width: 16.w,),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Providing incorrect information can cause delays with your withdrawal or withdrawal to a wrong person.",
                style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w400)),
            height8,
            Text("Always check the details correctly", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700)),
            height8,
          ],
        )),

      ],
    );
  }
}
