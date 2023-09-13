import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/user_profile.dart';
import 'package:spraay/utils/my_sharedpref.dart';
import 'package:spraay/view_model/auth_provider.dart';
import 'package:path/path.dart' as baseImg;


class EditProfile extends StatefulWidget {
  DataResponse? dataResponse;
   EditProfile(this.dataResponse);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {


  TextEditingController fullNameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController genderController=TextEditingController();
  TextEditingController dobController=TextEditingController();
  TextEditingController sprayTagController=TextEditingController();
  TextEditingController lastNameController=TextEditingController();

  final GlobalKey<FormState> _myKey = GlobalKey<FormState>();
  bool _isObscure = true;

  FocusNode? _textField1Focus;
  FocusNode? _textField2Focus;
  FocusNode? _textField3Focus;
  FocusNode? _textField4Focus;
  FocusNode? _textFieldLastFocus;
  AuthProvider? credentialsProvider;
  @override
  void didChangeDependencies() {
    credentialsProvider=context.watch<AuthProvider>();
    super.didChangeDependencies();
  }
  @override
  void initState() {

    setState(() {

      fullNameController.text=widget.dataResponse?.firstName??"";
      emailController.text=widget.dataResponse?.email??"";
      genderController.text=widget.dataResponse?.gender??"";
      lastNameController.text=widget.dataResponse?.lastName??"";

      _textField1Focus = FocusNode();
      _textField2Focus = FocusNode();
      _textField3Focus = FocusNode();
      _textField4Focus = FocusNode();
      _textFieldLastFocus=FocusNode();
    });
  }

  String firstVal="";
  String secondVal="";
  String thirdVal="";
  String forthVal="";
  String lastVal="";
  @override
  void dispose() {
    _textField1Focus?.dispose();
    _textField2Focus?.dispose();
    _textField3Focus?.dispose();
    _textField4Focus?.dispose();
    _textFieldLastFocus?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayWidget(
      loading: credentialsProvider?.loading??false,
      child: Scaffold(
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
          )),
    );
  }

  Widget _buildProfile(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 150.w,
          height: 150.h,
          child: Stack(
            children: [

              buildCircularNetworkImage(imageUrl: credentialsProvider?.dataResponse?.profileImageUrl??"", radius: 80.r),

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
        Text(credentialsProvider?.dataResponse?.firstName+" "+ credentialsProvider?.dataResponse?.lastName, style: CustomTextStyle.kTxtBold.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700) ),
        height4,
        Text(credentialsProvider?.dataResponse?.userTag??"", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w400) ),
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

      credentialsProvider?.fetchUploadFile(context, imageFile!, baseImg.basename(imageFile?.path??""));
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
        CustomizedTextField(textEditingController:lastNameController, keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,hintTxt: "Last name",focusNode: _textFieldLastFocus,
          prefixIcon: Padding(
            padding:  EdgeInsets.only(right: 8.w, left: 10.w),
            child: SvgPicture.asset("images/profile.svg", ),
          ),
          onChanged:(value){
            setState(() {lastVal=value;});
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
              // if( firstVal.isNotEmpty && secondVal.isNotEmpty && thirdVal.isNotEmpty){

                credentialsProvider?.updateProfileEndpoint(context, emailController.text, MySharedPreference.getUId(),
                    fullNameController.text, lastNameController.text, genderController.text);
                // Navigator.push(context, SlideLeftRoute(page: CreateAccountOtpPage()));
             // }
            },
            buttonText: 'Update', borderRadius: 30.r,width: 380.w,
            buttonColor: CustomColors.sPrimaryColor500),
        height34,



      ],
    );
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
        hintText: credentialsProvider?.dataResponse?.gender??"",
        isDense: true,
        filled: true,
        prefixIconConstraints:  BoxConstraints(minWidth: 19, minHeight: 19,),
        prefixIcon:Padding(
          padding:  EdgeInsets.only(right: 8.w, left: 10.w),
          child: SizedBox.shrink(),
        ),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0.1),borderRadius: BorderRadius.circular(8.r),),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: CustomColors.sPrimaryColor500, width: 0.5),borderRadius: BorderRadius.circular(8.r),),
        hintStyle:  CustomTextStyle.kTxtSemiBold.copyWith(color: CustomColors.sGreyScaleColor100, fontSize: 14.sp, fontWeight: FontWeight.w500),

        fillColor:_textField3Focus!.hasFocus? CustomColors.sTransparentPurplecolor : CustomColors.sDarkColor2,
        errorBorder:  OutlineInputBorder(borderSide:  BorderSide(color: Colors.red, width: 0.1.w), borderRadius: BorderRadius.circular(8.r),),
        focusedErrorBorder: OutlineInputBorder(borderSide:  BorderSide(color:Colors.transparent, width: 0.1.w), borderRadius: BorderRadius.circular(8.r),),
      ),
    );
  }


}
