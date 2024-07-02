import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/cashspray_model.dart';
import 'package:spraay/navigations/SlideUpRoute.dart';
import 'package:spraay/services/api_services.dart';
import 'package:spraay/ui/others/spray/join_event_otp.dart';
import 'package:spraay/ui/others/spray/spray_screen.dart';
import 'package:spraay/models/join_event_model.dart';
import 'package:spraay/utils/my_sharedpref.dart';


class JoinEventInfo extends StatefulWidget {
  Data? eventModelData;
   JoinEventInfo(this.eventModelData) ;

  @override
  State<JoinEventInfo> createState() => _JoinEventInfoState();
}

class _JoinEventInfoState extends State<JoinEventInfo> {
  final GlobalKey<FormState> _myKey = GlobalKey<FormState>();
  TextEditingController invitationController=TextEditingController();
  FocusNode? _textField1Focus;

  @override
  void initState() {
    setState(() {
      _textField1Focus = FocusNode();
    });
  }

  String firstVal="";
  @override
  void dispose() {
    _textField1Focus?.dispose();
    super.dispose();
  }

  Widget buildContainerr(){
    return Container(
      decoration: BoxDecoration(color: Color(0xff1A1A21), borderRadius: BorderRadius.all(Radius.circular(18.r))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Padding(
            padding:  EdgeInsets.all(8.r),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8.r)),
              child: CachedNetworkImage(
                width: 100.w, height: 140.h,
                fit: BoxFit.cover,
                imageUrl: widget.eventModelData?.eventCoverImage??"",
                placeholder: (context, url) => Center(child: SpinKitFadingCircle(size: 30,color: Colors.grey,)),
                errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
              ),
            ),
          ),
          SizedBox(width: 6.w,),

          Expanded(
            child: Padding(
              padding:  EdgeInsets.only(right: 16.w, top: 16.h, bottom: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.eventModelData?.eventName??"", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor50),
                    maxLines: 1, overflow: TextOverflow.ellipsis,),
                  height4,
                  Text(widget.eventModelData?.user?.firstName??"", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor500) ),
                  height4,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildDateAndLocContainer(img: 'datee', title: DateFormat('dd MMM y').format(widget.eventModelData!.eventDate!)),
                      SizedBox(width: 8.w,),
                      Expanded(child: buildDateAndLocContainer(img: 'location', title: widget.eventModelData?.venue??"")),
                    ],
                  ),
                  height8,


                ],
              ),
            ),
          )


        ],

      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return  LoadingOverlayWidget(
      loading: _isLoading,
      child: Scaffold(
          appBar: buildAppBar(context: context, title:"Join Event" ),
          body: Form(
            key: _myKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child:  buildInviWidget(),
          )),
    );
  }

  Widget buildInviWidget(){
    return ListView(
      padding: horizontalPadding,
      shrinkWrap: true,
      children: [
        height20,
        // buildContainer(),
        // height8,
        buildContainerr(),

        height20,
        Center(child: Text("How much will you like to spray?", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400,),)),
        height20,
        buildHorizontalTicket(),
        height20,
        Center(child: Text("Or enter manually", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400,),)),
        height20,
        CustomizedTextField(textEditingController:invitationController, keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,hintTxt: "Enter amount",focusNode: _textField1Focus,
          prefixText: "N ",
          inputFormat: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            NumberTextInputFormatter()
          ],
          onChanged:(value){
            setState(() {totalAmount=value.replaceAll(",", "");});
          },
        ),
        height26,
        Center(child: Text("Choose Spray amount", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400,),)),
        height20,
        buildHorizontalSprayAmt(),
        height26,
        CustomButton(
            onTap: () {
              if( totalAmount.isNotEmpty && index_sprayamt>=0){

                noteQuantity=int.parse(totalAmount)/amount;
                
                if(noteQuantity< 1.0){
                  cherryToastInfo(context,"Invalid amount", "Enter a valid amount" );
                }else{

                  fetchCheckbalanceBeforeWithdrawingApiPinApi(context, totalAmount, amount);


                }
                
              }
            },
            buttonText: 'Confirm', borderRadius: 30.r,width: 380.w,
            buttonColor: (totalAmount.isNotEmpty && index_sprayamt>=0) ? CustomColors.sPrimaryColor500:
            CustomColors.sDisableButtonColor),
        height34,

      ],
    );
  }

  Widget buildContainer(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(color: Color(0xff1A1A21), borderRadius: BorderRadius.all(Radius.circular(18.r))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("images/profilewiz.png", width: 120.w, height: 140.h, fit: BoxFit.cover,),
          SizedBox(width: 2.w,),
          Expanded(
            child: Padding(
              padding:  EdgeInsets.only(right: 16.w, top: 16.h, bottom: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("#Amik23 - Amara weds", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor50) ),
                  height4,
                  Text("Ikechukwu", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor500) ),
                  height4,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildDateAndLocContainer(img: 'datee', title: 'Today'),
                      SizedBox(width: 8.w,),
                      buildDateAndLocContainer(img: 'location', title: 'Lagos'),
                    ],
                  ),
                  height8,
                ],
              ),
            ),
          )


        ],

      ),
    );
  }

  Widget buildDateAndLocContainer({required String img, required String title}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
          color: CustomColors.sDarkColor3,
          borderRadius: BorderRadius.all(Radius.circular(4.r))
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset("images/$img.svg", width: 20.w, height: 20.h,),
          SizedBox(width: 4.w,),
          SizedBox(
            width: 80.w,
              child: Text(title, style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0xffEEECFF)), maxLines: 1, overflow: TextOverflow.ellipsis, )),

        ],
      ),
    );
  }

  int index_pos=-1;
  List<String> cashList=[
    "50,000", "100,000","250,000", "500,000", "1,000,000","1,500,000"
  ];
  Widget buildHorizontalTicket(){
    return   Wrap(
      alignment: WrapAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: cashList.asMap().entries.map((e) => GestureDetector(
        onTap:(){
          int position = e.key;//position
          setState(() {
            index_pos=position;
            totalAmount=e.value.replaceAll(",", "");
            invitationController.text= e.value;
          });
        },
        child: Container(
          width: 100.w,
          height: 46.h,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          margin: EdgeInsets.only(right: 16.w, bottom: 16.h),
          decoration: BoxDecoration(
              color:index_pos==e.key? CustomColors.sPrimaryColor500: Color(0x40335EF7),
              border: Border.all(color:index_pos==e.key? Colors.transparent: Color(0xffFAFAFA)),
              borderRadius: BorderRadius.all(Radius.circular(8.r))
          ),
          child: FittedBox(child: Text("₦${e.value.toString()}", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w700, color: CustomColors.sWhiteColor, fontFamily: "SemiPlusJakartaSans") )),
        ),
      ) ).toList(),
    );
  }

  int index_sprayamt=-1;
  String cash="";
  List<CashSprayModel> sprayAmtList=[
    CashSprayModel(amount: "200", amountImg: "two_hundrend",cash: "big_two_hundrend"),
    CashSprayModel(amount: "500", amountImg: "five_hundred", cash: "big_five_hundred"),
    CashSprayModel(amount: "1000", amountImg: "one_thousand", cash: "big_one_thousand")
  ];

  String totalAmount="";
  double noteQuantity=0.0;
  int amount=0;

  Widget buildHorizontalSprayAmt(){
    return   Wrap(
      alignment: WrapAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: sprayAmtList.asMap().entries.map((e) => GestureDetector(
        onTap:(){
          int position = e.key;//position
          setState(() {
            index_sprayamt=position;
            cash=e.value.cash;
            amount=int.parse(e.value.amount);
          });
        },
        child: Container(
          width: 100.w,
          height: 49.h,
          // padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          margin: EdgeInsets.only(right: 16.w, bottom: 16.h),
          decoration: BoxDecoration(
              color:index_sprayamt==e.key? CustomColors.sPrimaryColor500: Color(0x40335EF7),
              border: Border.all(color:index_sprayamt==e.key? Colors.transparent: Color(0xffFAFAFA)),
              borderRadius: BorderRadius.all(Radius.circular(8.r))
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                  child: Text("₦${e.value.amount}", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700, color: CustomColors.sWhiteColor, fontFamily: "SemiPlusJakartaSans") )),

              Positioned(
                  bottom: 0,
                  right: 0,
                  child: Image.asset("images/${e.value.amountImg}.png", width: 30.w,))
            ],
          ),
        ),
      ) ).toList(),
    );
  }


  bool _isLoading=false;
  fetchCheckbalanceBeforeWithdrawingApiPinApi(BuildContext context ,String amount, int unitAmount) async{
    setState(() {_isLoading=true;});
    var result=await ApiServices().checkbalanceBeforeWithdrawingApi(MySharedPreference.getToken(), amount);
    if(result['error'] == true){

      popupDialog(context: context, title: "Transaction Failed", content:result['message'],
          buttonTxt: 'Try again',
          onTap: () {
            Navigator.pop(context);

          }, png_img: 'Incorrect_sign');


    }else{
      Navigator.push(context, SlideUpRoute(page: JoinEventOtp(cash: cash, totalAmount: int.parse(totalAmount), noteQuantity: noteQuantity.toInt(),
        unitAmount: unitAmount, eventModelData: widget.eventModelData)));

    }

    setState(() {_isLoading=false;});
  }

}
