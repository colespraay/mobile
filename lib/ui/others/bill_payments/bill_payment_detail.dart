import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/cashspray_model.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/navigations/SlideUpRoute.dart';
import 'package:spraay/ui/others/bill_payments/pin_for_bill_payment.dart';

class PayBilDetail extends StatefulWidget {
  String title;
   PayBilDetail({required this.title});

  @override
  State<PayBilDetail> createState() => _PayBilDetailState();
}

class _PayBilDetailState extends State<PayBilDetail> {
  final GlobalKey<FormState> _myKey = GlobalKey<FormState>();
  TextEditingController amtController=TextEditingController();
  TextEditingController phoneController=TextEditingController();

  FocusNode? _textField1Focus;
  FocusNode? _textField2Focus;


  @override
  void initState() {
    setState(() {
      _textField1Focus = FocusNode();
      _textField2Focus = FocusNode();
    });
  }

  String firstBtn="";
  String secondBtn="";
  @override
  void dispose() {
    _textField1Focus?.dispose();
    _textField2Focus?.dispose();
    amtController.dispose();
    phoneController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: buildAppBar(context: context, title:widget.title ),
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
        height45,
        buildHorizontalContainer(),
        height20,
        CustomizedTextField(textEditingController:phoneController, keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,hintTxt: widget.title=="Airtime Top-up"? "Enter Phone Number": "Meter Number" ,focusNode: _textField1Focus,
          inputFormat: [
            FilteringTextInputFormatter.digitsOnly
          ],
          onChanged:(value){
            setState(() {firstBtn=value;});
          },

          surffixWidget:  widget.title=="Airtime Top-up"? GestureDetector(
            onTap:()async{
              final PhoneContact contact = await FlutterContactPicker.pickPhoneContact();
              setState(() {
                phoneController.text = contact.phoneNumber?.number?.trim().replaceAll("+234", "0").replaceAll(" ", "").replaceAll("-", "")??"";
                firstBtn=phoneController.text;
              });



            },
            child: Padding(
              padding:  EdgeInsets.only(right: 10.w),
              child: SvgPicture.asset("images/contact_profile.svg"),
            ),
          ) : SizedBox.shrink(),
        ),
        height22,
        CustomizedTextField(textEditingController:amtController, keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,hintTxt: "Enter Amount",focusNode: _textField2Focus,
          prefixText: "₦ ",
          inputFormat: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            NumberTextInputFormatter()
          ],
          onChanged:(value){
            setState(() {secondBtn=value;});
          },
        ),
        height34,
        buildHorizontalTicket(),
        height40,

        Center(
          child: CustomButton(
              onTap: () {
                if( firstBtn.isNotEmpty && secondBtn.isNotEmpty && airtimePosition>-1){
                  Navigator.push(context, SlideLeftRoute(page: PinForBillPayment(title: widget.title, image: imageAirtime,)));
                }
              },
              buttonText: 'Continue', borderRadius: 30.r,width: 380.w,
              buttonColor: (firstBtn.isNotEmpty && secondBtn.isNotEmpty
                  && airtimePosition>-1) ? CustomColors.sPrimaryColor500:
              CustomColors.sDisableButtonColor),
        ),
        height34,

      ],
    );
  }


  List <String> cableList=["mtn","9_mobile","airtel","glo"];
  int airtimePosition=-1;
  String imageAirtime="";
  Widget buildHorizontalContainer(){
    return Center(
      child: Wrap(
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: cableList.asMap().entries.map((e) => GestureDetector(
          onTap:(){
            setState(() {
               airtimePosition = e.key;//position
               imageAirtime=e.value;
            });

          },
          child: Container(
            margin: EdgeInsets.only(right: 14.w, bottom: 40.h),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
                border: Border.all(color:airtimePosition==e.key?  CustomColors.sPrimaryColor500: Colors.transparent, width: 5.r),
                // borderRadius: BorderRadius.all(Radius.circular(8.r))
            ),
            child: SvgPicture.asset("images/${e.value}.svg", width: 70.w, height: 70.h,),

          ),
        ) ).toList(),
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
  List<String> cashList=["500", "1000","3000", "5000", "10,000","15,000","20,000","30,000","50,000"];
  Widget buildHorizontalTicket(){
    return   Wrap(
      alignment: WrapAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: cashList.asMap().entries.map((e) => GestureDetector(
        onTap:(){
          int position = e.key;//position
          setState(() {
            index_pos=position;
            secondBtn=e.value;
          });

          amtController.text=e.value;
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


}
