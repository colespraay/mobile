import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/view_model/auth_provider.dart';

class EditEvent extends StatefulWidget {
  String fromPage;
   EditEvent({required this.fromPage});

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {

  TextEditingController fullNameController=TextEditingController();
  TextEditingController dateController=TextEditingController();
  TextEditingController timeController=TextEditingController();

  TextEditingController genderController=TextEditingController();
  TextEditingController categoryController=TextEditingController();

  final GlobalKey<FormState> _myKey = GlobalKey<FormState>();
  bool _isObscure = true;

  FocusNode? _textField4Focus;
  FocusNode? _textTagFocus;
  @override
  void initState() {


  }

  @override
  void dispose() {
    _textField4Focus?.dispose();
    _textTagFocus?.dispose();
    super.dispose();
  }

  int step=1;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: buildAppBar(context: context, title:"Edit Event" ),
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

        buildChildrenContentWidget(content: "Amara weds Ikechukwu"),

        height16,
        buildChildrenContentWidget(content: "15/06/2023"),
        height16,
        buildChildrenContentWidget(content: "11:00 AM"),
        height16,
        _buildEvents(),
        height16,
        _buildCategories(),
        height16,
        buildContWidget(content: "Join us as we celebrate the union between Amara Azubuike and Ikechukwu Dirichie on the 1st of June 2023."),
        height8,
        Center(
          child: buildDottedBorder(child: Container(
            width: 180.w,
            height: 174.h,
            decoration: BoxDecoration(color: CustomColors.sPrimaryColor500),
            child: Stack(
              children: [
                ClipRRect(borderRadius: BorderRadius.circular(12.r),
                    child: Container(color: Colors.blue,)),//replace this with image
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(12.r),
                //   child: CachedNetworkImage(
                //     fit: BoxFit.cover,
                //     width:160.w,
                //     height: 150.h,
                //     imageUrl: MySharedPreference.getProfilePic(),
                //     placeholder: (context, url) => Center(child: SpinKitFadingCircle(size: 30,color: Colors.grey,)),
                //     errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                //   ),
                // ),


                Positioned(
                  left: 8.w,
                  right: 8.w,
                  bottom: 28.h,
                  child: GestureDetector(
                    onTap:(){
                      _getFromGallery();
                    },
                    child: Container(
                      width: 170.w,
                      height: 40.h,
                      decoration: BoxDecoration(color: CustomColors.sGreenColor500, borderRadius: BorderRadius.all(Radius.circular(4.r))),
                      child: Center(
                        child: Text("Change cover image", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 14.sp,
                          fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor900),),
                      ),
                    ),
                  ),
                )

              ],
            ),
          )),
        ),
        height34,


        CustomButton(
            onTap: () {
              popupDialog(context: context, title: "Saved Successfully", content: "Your edit has been saved successfully.",
                  buttonTxt: 'Home',
                  onTap: () {

                if( widget.fromPage=="view_event"){
                  //when routed through view_event page
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Provider.of<AuthProvider>(context, listen: false).onItemTap(0);
                }else{
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Provider.of<AuthProvider>(context, listen: false).onItemTap(0);
                }


                  }, png_img: 'verified');
            },
            buttonText: 'Confirm', borderRadius: 30.r,width: 380.w,
            buttonColor: CustomColors.sPrimaryColor500),
        height22,

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

  //hdhhdd
  List<String> categorylist=["John abuja", "John Evans"];

  Widget _buildCategories(){
    return DropdownButtonFormField<String>(
      iconEnabledColor: CustomColors.sDisableButtonColor,
      isDense: false,
      dropdownColor: Color(0xff212121),
      items: categorylist.map((String value) {
        return DropdownMenuItem<String>(value: value,
          child: Text(value, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400,), ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        categoryController.text=newValue??"";
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
        hintText: "Category",
        isDense: true,
        filled: true,
        prefixIconConstraints:  BoxConstraints(minWidth: 19, minHeight: 19,),
        prefixIcon:Padding(
          padding:  EdgeInsets.only(right: 8.w, left: 10.w),
          child: SizedBox.shrink(),
        ),
        fillColor: CustomColors.sDarkColor2,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0.1),borderRadius: BorderRadius.circular(8.r),),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0.5),borderRadius: BorderRadius.circular(8.r),),
        hintStyle: CustomTextStyle.kTxtRegular.copyWith(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w400),

        errorBorder:  OutlineInputBorder(borderSide:  BorderSide(color: Colors.red, width: 0.1.w), borderRadius: BorderRadius.circular(8.r),),
        focusedErrorBorder: OutlineInputBorder(borderSide:  BorderSide(color:Colors.transparent, width: 0.1.w), borderRadius: BorderRadius.circular(8.r),),
      ),
    );
  }

  List<String> eventlist=["John Evans Event Center abuja", "John Evans Event center lagos"];

  Widget _buildEvents(){
    return DropdownButtonFormField<String>(
      iconEnabledColor: CustomColors.sDisableButtonColor,
      isDense: false,
      dropdownColor: Color(0xff212121),
      items: eventlist.map((String value) {
        return DropdownMenuItem<String>(value: value,
          child: Text(value, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400,), ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        genderController.text=newValue??"";
        // thirdVal=newValue??"";
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
        hintText: "Event",
        isDense: true,
        filled: true,
        prefixIconConstraints:  BoxConstraints(minWidth: 19, minHeight: 19,),
        prefixIcon:Padding(
          padding:  EdgeInsets.only(right: 8.w, left: 10.w),
          child: SizedBox.shrink(),
        ),
        fillColor: CustomColors.sDarkColor2,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0.1),borderRadius: BorderRadius.circular(8.r),),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0.5),borderRadius: BorderRadius.circular(8.r),),
        hintStyle: CustomTextStyle.kTxtRegular.copyWith(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w400),

        errorBorder:  OutlineInputBorder(borderSide:  BorderSide(color: Colors.red, width: 0.1.w), borderRadius: BorderRadius.circular(8.r),),
        focusedErrorBorder: OutlineInputBorder(borderSide:  BorderSide(color:Colors.transparent, width: 0.1.w), borderRadius: BorderRadius.circular(8.r),),
      ),
    );
  }

  Widget buildChildrenContentWidget({required String content}){
    return Container(
      height: 56.h,
        padding: EdgeInsets.only(left: 18.w),
        width: double.infinity,
        decoration: BoxDecoration(
          color: CustomColors.sDarkColor2,
          borderRadius: BorderRadius.all(Radius.circular(6.r))
        ),
        child: Align(
          alignment: Alignment.centerLeft,
            child: Text(content, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400,),)));
  }

  Widget buildContWidget({required String content}){
    return Container(
        padding: EdgeInsets.only(left: 18.w, right: 18.w, top: 16.h, bottom: 16.h),
        width: double.infinity,
        decoration: BoxDecoration(
            color: CustomColors.sDarkColor2,
            borderRadius: BorderRadius.all(Radius.circular(6.r))
        ),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(content, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp,
              fontWeight: FontWeight.w400,),)));
  }


}
