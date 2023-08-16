import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {


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
  @override
  void initState() {
    fullNameController.text="Daniel Esiv";
    emailController.text="nsnsjsjs@gmail.com";
    genderController.text="Male";

    setState(() {
      _textField1Focus = FocusNode();
      _textField2Focus = FocusNode();
      _textField3Focus = FocusNode();
      _textField4Focus = FocusNode();
    });
  }

  String firstVal="";
  String secondVal="";
  String thirdVal="";
  String forthVal="";
  @override
  void dispose() {
    _textField1Focus?.dispose();
    _textField2Focus?.dispose();
    _textField3Focus?.dispose();
    _textField4Focus?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context: context, title: "Edit Profile"),
        body:  ListView(
          padding: horizontalPadding,
          children: [
            height18,
            _buildProfile(),
            height16,
            buildStep1Widget(),

            height22


          ],
        ));
  }

  Widget _buildProfile(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 130.w,
          height: 130.h,
          child: Stack(
            children: [

              CircleAvatar(
                radius: 100.r,
                backgroundColor: Colors.grey,
                child: SizedBox(
                  width: 120.w,
                  height: 120.h,
                  child:imageFile==null? SvgPicture.asset("images/profile.svg"):  Center(child: Image.file(imageFile!)) ,
                ),
              ),

              Positioned(
                  bottom: 10.h,
                  right: 5.w,
                  child: GestureDetector(
                    onTap:(){
                      _getFromGallery();
                    },
                      child: SvgPicture.asset("images/edit_svg.svg"))),

            ],
          ),
        ),
        height16,
        Text("Uche Usman", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700) ),
        height4,
        Text("@uche911", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w400) ),
      ],
    );
  }

  final ImagePicker _picker = ImagePicker();
  File? imageFile;
  _getFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
      //api
      // fetchuploadPicEndpoint(context: context, mytoken: MySharedPreference.getToken(), imageFile: imageFile, imageFileName: baseImg.basename(imageFile?.path??""));
    }
  }

  Widget buildStep1Widget(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      // padding: horizontalPadding,
      // shrinkWrap: true,
      children: [
        height40,

        CustomizedTextField(textEditingController:fullNameController, keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,hintTxt: "Full name",focusNode: _textField1Focus,
          prefixIcon: Padding(
            padding:  EdgeInsets.only(right: 8.w, left: 10.w),
            child: SvgPicture.asset("images/profile.svg", ),
          ),
          onChanged:(value){
            setState(() {firstVal=value;});
          },
        ),

        height16,
        CustomizedTextField(textEditingController:emailController, keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,hintTxt: "Email",focusNode: _textField2Focus,
          prefixIcon: Padding(
            padding:  EdgeInsets.only(right: 8.w, left: 10.w),
            child: SvgPicture.asset("images/email.svg", color: CustomColors.sWhiteColor,),
          ),
          onChanged:(value){
            setState(() {secondVal=value;});
          },
        ),

        height16,
        buildGender(),

        height60,
        CustomButton(
            onTap: () {
              if( firstVal.isNotEmpty && secondVal.isNotEmpty && thirdVal.isNotEmpty){

                popupDialog(context: context, title: "Profile updated",
                    content: "You have successfully update your profile",
                    buttonTxt: "Great!", onTap: (){
                      Navigator.pop(context);
                      Navigator.pop(context);


                    }, png_img: "verified");
                // Navigator.push(context, SlideLeftRoute(page: CreateAccountOtpPage()));
              }
            },
            buttonText: 'Update', borderRadius: 30.r,width: 380.w,
            buttonColor: ( firstVal.isNotEmpty && secondVal.isNotEmpty && thirdVal.isNotEmpty) ? CustomColors.sPrimaryColor500:
            CustomColors.sDisableButtonColor),
        height34,



      ],
    );
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
