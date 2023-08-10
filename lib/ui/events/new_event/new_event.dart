import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';

class NewEvent extends StatefulWidget {
  const NewEvent({Key? key}) : super(key: key);

  @override
  State<NewEvent> createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {

  TextEditingController fullNameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController genderController=TextEditingController();
  TextEditingController dobController=TextEditingController();
  TextEditingController sprayTagController=TextEditingController();

  final GlobalKey<FormState> _myKey = GlobalKey<FormState>();
  bool _isObscure = true;

  FocusNode? _textField1Focus;
  FocusNode? _textField2Focus;
  FocusNode? _textField3Focus;
  FocusNode? _textField4Focus;
  FocusNode? _textTagFocus;
  @override
  void initState() {
    setState(() {
      _textField1Focus = FocusNode();
      _textField2Focus = FocusNode();
      _textField3Focus = FocusNode();
      _textField4Focus = FocusNode();
      _textTagFocus=FocusNode();
    });
  }

  String firstVal="";
  String secondVal="";
  String thirdVal="";
  String forthVal="";
  String tagVal="";
  @override
  void dispose() {
    _textField1Focus?.dispose();
    _textField2Focus?.dispose();
    _textField3Focus?.dispose();
    _textField4Focus?.dispose();
    _textTagFocus?.dispose();
    super.dispose();
  }

  int step=1;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: buildAppBar(context: context, title:"New Event" ),
        body: Form(
          key: _myKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child:  buildStep1Widget(),
        ));

  }

  Widget buildStep1Widget(){
    return ListView(
      padding: horizontalPadding,
      shrinkWrap: true,
      children: [
        height20,

        CustomizedTextField(textEditingController:fullNameController, keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,hintTxt: "Event name",focusNode: _textField1Focus,
          onChanged:(value){
            setState(() {firstVal=value;});
          },
        ),
        height16,
        CustomizedTextField(textEditingController:dobController, keyboardType: TextInputType.datetime,
          textInputAction: TextInputAction.next,hintTxt: "Event Date",focusNode: _textField4Focus,
          onChanged:(value){
            setState(() {forthVal=value;});
          },
          readOnly: true,
          onTap:(){
            _selectDate(context);
          },
        ),

        height16,
        CustomizedTextField(textEditingController:emailController, keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,hintTxt: "Email",focusNode: _textField2Focus,
          prefixIcon: Padding(
            padding:  EdgeInsets.only(right: 8.w, left: 10.w),
            child: SvgPicture.asset("images/email.svg"),
          ),
          onChanged:(value){
            setState(() {secondVal=value;});
          },
        ),

        height16,
        buildGender(),



        height26,



        height26,
        CustomButton(
            onTap: () {
              if( firstVal.isNotEmpty && secondVal.isNotEmpty && thirdVal.isNotEmpty && forthVal.isNotEmpty){
                setState(() {step=2;});
                // Navigator.push(context, SlideLeftRoute(page: CreateAccountOtpPage()));
              }
            },
            buttonText: 'Continue', borderRadius: 30.r,width: 380.w,
            buttonColor: ( firstVal.isNotEmpty && secondVal.isNotEmpty && thirdVal.isNotEmpty && forthVal.isNotEmpty) ? CustomColors.sPrimaryColor500:
            CustomColors.sDisableButtonColor),
        height34,



      ],
    );
  }


  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1800, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        forthVal="value";
      });
      dobController.text=  DateFormat('yyyy-MM-dd').format(selectedDate);
      // print("selectedDate==${selectedDate}");
    }
  }

  List<String> genderlist=["Male", "Female"];
  Widget buildGender(){
    return DropdownButtonFormField<String>(
      iconEnabledColor: CustomColors.sDisableButtonColor,
      isDense: false,
      dropdownColor: Color(0xff212121),
      focusNode: _textField3Focus,
      items: genderlist.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: CustomTextStyle.kTxtSemiBold.copyWith(color: CustomColors.sGreyScaleColor100,
              fontSize: 14.sp, fontWeight: FontWeight.w500), ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        genderController.text=newValue??"";
        thirdVal=newValue??"";
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
        hintText: "Gender",
        isDense: true,
        filled: true,
        prefixIconConstraints:  BoxConstraints(minWidth: 19, minHeight: 19,),
        prefixIcon:Padding(
          padding:  EdgeInsets.only(right: 8.w, left: 10.w),
          child: SizedBox.shrink(),
        ),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0.1),borderRadius: BorderRadius.circular(8.r),),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: CustomColors.sPrimaryColor500, width: 0.5),borderRadius: BorderRadius.circular(8.r),),
        hintStyle: CustomTextStyle.kTxtRegular.copyWith(color: CustomColors.sGreyScaleColor500, fontSize: 14.sp, fontWeight: FontWeight.w400),

        fillColor:_textField3Focus!.hasFocus? CustomColors.sTransparentPurplecolor : CustomColors.sDarkColor2,
        errorBorder:  OutlineInputBorder(borderSide:  BorderSide(color: Colors.red, width: 0.1.w), borderRadius: BorderRadius.circular(8.r),),
        focusedErrorBorder: OutlineInputBorder(borderSide:  BorderSide(color:Colors.transparent, width: 0.1.w), borderRadius: BorderRadius.circular(8.r),),
      ),
    );
  }
}
