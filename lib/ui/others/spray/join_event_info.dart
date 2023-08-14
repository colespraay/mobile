import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/cashspray_model.dart';
import 'package:spraay/navigations/SlideUpRoute.dart';
import 'package:spraay/ui/others/spray/spray_screen.dart';

class JoinEventInfo extends StatefulWidget {
  const JoinEventInfo({Key? key}) : super(key: key);

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


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: buildAppBar(context: context, title:"Join Event" ),
        body: Form(
          key: _myKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child:  buildInviWidget(),
        ));
  }

  Widget buildInviWidget(){
    return ListView(
      padding: horizontalPadding,
      shrinkWrap: true,
      children: [
        height20,
        buildContainer(),
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
            setState(() {firstVal=value;});
          },
        ),
        height26,
        Center(child: Text("Choose Spray amount", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400,),)),
        height20,
        buildHorizontalSprayAmt(),
        height26,
        CustomButton(
            onTap: () {
              if( firstVal.isNotEmpty && index_sprayamt>=0){

                noteQuantity=totalAmount/amount;

                Navigator.push(context, SlideUpRoute(page: SprayScreen(cash: cash, totalAmount: totalAmount, noteQuantity: noteQuantity.toInt(),
                unitAmount: amount,)));
              }
            },
            buttonText: 'Confirm', borderRadius: 30.r,width: 380.w,
            buttonColor: (firstVal.isNotEmpty && index_sprayamt>=0) ? CustomColors.sPrimaryColor500:
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
                  // GestureDetector(
                  //     onTap:(){
                  //       Navigator.push(context, FadeRoute(page: EventDetails()));
                  //     },
                  //     child: buildStatus(title: "View Details", color:CustomColors.sDarkColor3))



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
          Text(title, style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0xffEEECFF)) ),

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

  int totalAmount=10000;
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

}
