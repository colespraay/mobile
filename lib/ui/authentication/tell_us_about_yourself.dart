import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/authentication/pin_creation.dart';
import 'package:spraay/utils/my_sharedpref.dart';
import 'package:spraay/view_model/auth_provider.dart';

class TellUsAboutYourself extends StatefulWidget {
  const TellUsAboutYourself({Key? key}) : super(key: key);

  @override
  State<TellUsAboutYourself> createState() => _TellUsAboutYourselfState();
}

class _TellUsAboutYourselfState extends State<TellUsAboutYourself> {

  TextEditingController fullNameController=TextEditingController();
  TextEditingController lastNameController=TextEditingController();

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
  FocusNode? _txtLastNFocus;
  @override
  void initState() {
    setState(() {
      _textField1Focus = FocusNode();
      _textField2Focus = FocusNode();
      _textField3Focus = FocusNode();
      _textField4Focus = FocusNode();
      _textTagFocus=FocusNode();
      _txtLastNFocus=FocusNode();
    });
  }

  AuthProvider? credentialsProvider;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    credentialsProvider=context.watch<AuthProvider>();
  }
  String firstVal="";
  String secondVal="";
  String thirdVal="";
  String forthVal="";
  String tagVal="";
  String lastNVal="";
  @override
  void dispose() {
    _textField1Focus?.dispose();
    _textField2Focus?.dispose();
    _textField3Focus?.dispose();
    _textField4Focus?.dispose();
    _textTagFocus?.dispose();
    _txtLastNFocus?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return  LoadingOverlayWidget(
      loading: credentialsProvider!.loading,
      child: Scaffold(
          appBar: buildAppBar(context: context, title:"Tell Us About Yourself"),
          body: Form(
            key: _myKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: credentialsProvider?.step==1? buildStep1Widget(): buildStep2Widget(),
          )),
    );

  }

  Widget buildStep1Widget(){
    return ListView(
      padding: horizontalPadding,
      shrinkWrap: true,
      children: [
        height20,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Personal Information", style: CustomTextStyle.kTxtSemiBold.copyWith(fontWeight: FontWeight.w500, fontSize: 24.sp, color: CustomColors.sGreyScaleColor50)),

            Text("Step  1 of 2", style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 14.sp, color: CustomColors.sGreyScaleColor50)),
          ],
        ),
        Divider(color: CustomColors.sGreyScaleColor300,),
        Text("Kindly complete your information", style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 18.sp, color: CustomColors.sGreyScaleColor50)),
        height40,

        CustomizedTextField(textEditingController:fullNameController, keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,hintTxt: "First name",focusNode: _textField1Focus,
          prefixIcon: Padding(
            padding:  EdgeInsets.only(right: 8.w, left: 10.w),
            child: SvgPicture.asset("images/profile.svg", color: CustomColors.sDisableButtonColor,),
          ),
          onChanged:(value){
            setState(() {firstVal=value;});
          },
        ),
        height16,

        CustomizedTextField(textEditingController:lastNameController, keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,hintTxt: "Last name",focusNode: _txtLastNFocus,
          prefixIcon: Padding(
            padding:  EdgeInsets.only(right: 8.w, left: 10.w),
            child: SvgPicture.asset("images/profile.svg", color: CustomColors.sDisableButtonColor,),
          ),
          onChanged:(value){
            setState(() {lastNVal=value;});
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

        height16,
        CustomizedTextField(textEditingController:dobController, keyboardType: TextInputType.datetime,
          textInputAction: TextInputAction.done,hintTxt: "DOB",focusNode: _textField4Focus,
          prefixIcon: Padding(
            padding:  EdgeInsets.only(right: 8.w, left: 10.w),
            child: SvgPicture.asset("images/calendar.svg"),
          ),
          onChanged:(value){
            setState(() {forthVal=value;});
          },
          readOnly: true,
          onTap:(){
            _selectDate(context);
          },
        ),

        height26,



        height26,
        CustomButton(
            onTap: () {
              if( firstVal.isNotEmpty && secondVal.isNotEmpty && thirdVal.isNotEmpty && forthVal.isNotEmpty && lastNVal.isNotEmpty){
                // setState(() {step=2;});
                Provider.of<AuthProvider>(context, listen: false).tellUsAboutYourselfEndpoint(context, emailController.text, MySharedPreference.getUId(),
                    fullNameController.text, lastNameController.text, genderController.text, dobController.text);

              }
            },
            buttonText: 'Continue', borderRadius: 30.r,width: 380.w,
            buttonColor: ( firstVal.isNotEmpty && secondVal.isNotEmpty && thirdVal.isNotEmpty && forthVal.isNotEmpty && lastNVal.isNotEmpty) ? CustomColors.sPrimaryColor500:
            CustomColors.sDisableButtonColor),
        height34,



      ],
    );
  }

  Widget buildStep2Widget(){
    return ListView(
      padding: horizontalPadding,
      shrinkWrap: true,
      children: [
        height20,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Choose Spraay tag", style: CustomTextStyle.kTxtSemiBold.copyWith(fontWeight: FontWeight.w500, fontSize: 24.sp, color: CustomColors.sGreyScaleColor50)),
            Text("Step  2 of 2", style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 14.sp, color: CustomColors.sGreyScaleColor50)),
          ],
        ),
        Divider(color: CustomColors.sGreyScaleColor300,),
        Text("Choose a Spraay tag. This allows you\nreceive money", style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 18.sp, color: CustomColors.sGreyScaleColor50)),
        height40,

        CustomizedTextField(textEditingController:sprayTagController, keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,hintTxt: "tag name",focusNode: _textTagFocus,
          prefixIcon: Padding(
            padding:  EdgeInsets.only(right: 8.w, left: 10.w),
            child: SvgPicture.asset("images/at_svg.svg", color: CustomColors.sDisableButtonColor,),
          ),
          onChanged:(value){
            setState(() {tagVal=value;});
          },
        ),
        // height18,
        // Text("Spraay tag available ✅", style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 12.sp, color: CustomColors.sWhiteColor)),


        height90,
        CustomButton(
            onTap: () {
              if( tagVal.isNotEmpty){
                Provider.of<AuthProvider>(context, listen: false).tellUsAboutYourselfTagEndpoint(context, sprayTagController.text, MySharedPreference.getUId());
              }
            },
            buttonText: 'Continue', borderRadius: 30.r,width: 380.w,
            buttonColor: ( tagVal.isNotEmpty ) ? CustomColors.sPrimaryColor500:
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

  List<String> genderlist=["MALE", "FEMALE"];
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
