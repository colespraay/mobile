import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/services/api_services.dart';
import 'package:spraay/ui/others/spray_gifting/spray_gift_otp.dart';
import 'package:spraay/utils/my_sharedpref.dart';

import '../../../navigations/fade_route.dart';

class ReciDetail extends StatefulWidget {
  String? giftAmount;
   ReciDetail({required this.giftAmount});

  @override
  State<ReciDetail> createState() => _ReciDetailState();
}

class _ReciDetailState extends State<ReciDetail> {
  final GlobalKey<FormState> _myKey = GlobalKey<FormState>();
  TextEditingController sprayTagController=TextEditingController();
  FocusNode? _textTagFocus;
  @override
  void initState() {
    setState(() {
      _textTagFocus=FocusNode();
    });
  }

  String tagVal="";
  @override
  void dispose() {
    _textTagFocus?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: buildAppBar(context: context, title:"Recipient Details " ),
        body: Form(
          key: _myKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: buildListWidget(),
        ));

  }

  // Timer? _debounce;

  final _debouncer = Debouncer(milliseconds: 700);

  Widget buildListWidget(){
    return ListView(
      padding: horizontalPadding,
      shrinkWrap: true,
      children: [
        height20,

        Text("Enter Spraay tag of receiver", style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 18.sp, color: CustomColors.sGreyScaleColor50)),
        height40,

        CustomizedTextField(textEditingController:sprayTagController, keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,hintTxt: "tag name",focusNode: _textTagFocus,
          autofocus: true,
          prefixIcon: Padding(
            padding:  EdgeInsets.only(right: 8.w, left: 10.w),
            child: SvgPicture.asset("images/at_svg.svg",),
          ),
          onChanged:(value){



            _debouncer.run(() {
              if(value.isNotEmpty){
                fetchUserByTagApi(context, value.replaceAll("@", ""));
              }else{
                //
              }
              //perform search here
            });


          },
        ),
        height8,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _isLoading?SpinKitFadingCircle(size: 30,color: Colors.grey,):Container(),
            Text("$firstName $lastName", style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 12.sp, color: CustomColors.sWhiteColor)),
          ],
        ),


        height90,
        CustomButton(
            onTap: () {
              if( firstName.isNotEmpty){
                Navigator.pushReplacement(context, FadeRoute(page: SprayGiftOtp(amount: widget.giftAmount, receiverTag:sprayTagController.text,routeStatus: "spray_tag",)));
              }
            },
            buttonText: 'Confirm', borderRadius: 30.r,width: 380.w,
            buttonColor: ( firstName.isNotEmpty ) ? CustomColors.sPrimaryColor500:
            CustomColors.sDisableButtonColor),
        height34,
      ],
    );
  }

  bool _isLoading=false;
  String firstName="";
  String lastName="";
  fetchUserByTagApi(BuildContext context, String userTag) async{
    setState(() {_isLoading=true;});
    var result=await ApiServices().userByTag("@$userTag", MySharedPreference.getToken());
    if(result['error'] == true){
      setState(() {
        firstName="";
        lastName=result['message'];
      });
      // errorCherryToast(context, result['message']);
    }else{
      setState(() {
        firstName=result["firstName"];
        lastName=result["lastName"];
      });

      // userInformationList= apiResponse.data?.data??[];
    }
    setState(() {_isLoading=false;});

  }


}
