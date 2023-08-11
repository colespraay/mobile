import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/ui/events/new_event/confirmation_page.dart';

class NewEvent extends StatefulWidget {
  const NewEvent({Key? key}) : super(key: key);

  @override
  State<NewEvent> createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {

  TextEditingController fullNameController=TextEditingController();
  TextEditingController venueController=TextEditingController();
  TextEditingController categoryController=TextEditingController();
  TextEditingController dobController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();
  TextEditingController timeController=TextEditingController();
  TimeOfDay ?_openPickupTime;



  final GlobalKey<FormState> _myKey = GlobalKey<FormState>();

  FocusNode? _textField1Focus;
  FocusNode? _textField2Focus;
  FocusNode? _textField3Focus;
  FocusNode? _textField4Focus;
  FocusNode? _textField5Focus;
  FocusNode? _textField6Focus;


  @override
  void initState() {
    setState(() {
      _textField1Focus = FocusNode();
      _textField2Focus = FocusNode();
      _textField3Focus = FocusNode();
      _textField4Focus = FocusNode();
      _textField5Focus=FocusNode();
      _textField6Focus=FocusNode();

    });
  }

  String firstVal="";
  String secondVal="";
  String thirdVal="";
  String forthVal="";
  String fiveVal="";
  String sixVal="";

  @override
  void dispose() {
    _textField1Focus?.dispose();
    _textField2Focus?.dispose();
    _textField3Focus?.dispose();
    _textField4Focus?.dispose();
    _textField5Focus?.dispose();
    _textField6Focus?.dispose();
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
        CustomizedTextField(textEditingController:timeController, keyboardType:TextInputType.datetime, textInputAction: TextInputAction.next,focusNode: _textField2Focus,
          hintTxt: "Time", readOnly: true,
          onChanged:(value){
            setState(() {secondVal=value;});
          },
          onTap: ()async {
            TimeOfDay? newSelectedTime = await showTimePicker(helpText: "Select Time", context: context, initialTime: TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 10))));
            setState(() {
              _openPickupTime = newSelectedTime == null ? TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 10))) : newSelectedTime;
              timeController.text=_openPickupTime?.format(context)??"";
              secondVal=_openPickupTime?.format(context)??"";
            });},
        ),


        height16,
        CustomizedTextField(
          textEditingController:venueController, keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,hintTxt: "Venue",focusNode: _textField5Focus,
          onChanged:(value){
            setState(() {fiveVal=value;});
          },
        ),

        height16,
        buildCategory(),

        height16,
        CustomizedTextField(
          textEditingController:descriptionController, keyboardType: TextInputType.text,
          maxLength: 150,
          maxLines: 5,
          textInputAction: TextInputAction.done,hintTxt: "Event description (Not more than 150 words)",
          focusNode: _textField6Focus,
          onChanged:(value){
            setState(() {sixVal=value;});
          },
        ),
        height16,
        buildImage(),
        height26,
        CustomButton(
            onTap: () {
              if( firstVal.isNotEmpty && secondVal.isNotEmpty && thirdVal.isNotEmpty && forthVal.isNotEmpty && fiveVal.isNotEmpty && sixVal.isNotEmpty && imageFile!=null){
                Navigator.push(context, SlideLeftRoute(page: EventConfirmationPage()));
              }
            },
            buttonText: 'Continue', borderRadius: 30.r,width: 380.w,
            buttonColor: (firstVal.isNotEmpty && secondVal.isNotEmpty && thirdVal.isNotEmpty && forthVal.isNotEmpty&& fiveVal.isNotEmpty && sixVal.isNotEmpty
                && imageFile !=null) ? CustomColors.sPrimaryColor500:
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

  List<String> categorylist=["Cat1", "Cat2"];
  Widget buildCategory(){
    return DropdownButtonFormField<String>(
      iconEnabledColor: CustomColors.sDisableButtonColor,
      isDense: false,
      dropdownColor: Color(0xff212121),
      focusNode: _textField3Focus,
      items: categorylist.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: CustomTextStyle.kTxtSemiBold.copyWith(color: CustomColors.sGreyScaleColor100,
              fontSize: 14.sp, fontWeight: FontWeight.w500), ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        categoryController.text=newValue??"";
        thirdVal=newValue??"";
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
        hintText: "Category",
        isDense: true,
        filled: true,
        prefixIconConstraints:  BoxConstraints(minWidth: 19, minHeight: 19,),
        prefixIcon:Padding(padding:  EdgeInsets.only(right: 8.w, left: 10.w), child: SizedBox.shrink(),),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0.1),borderRadius: BorderRadius.circular(8.r),),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: CustomColors.sPrimaryColor500, width: 0.5),borderRadius: BorderRadius.circular(8.r),),
        hintStyle: CustomTextStyle.kTxtRegular.copyWith(color: CustomColors.sGreyScaleColor500, fontSize: 14.sp, fontWeight: FontWeight.w400),
        fillColor:_textField3Focus!.hasFocus? CustomColors.sTransparentPurplecolor : CustomColors.sDarkColor2,
        errorBorder:  OutlineInputBorder(borderSide:  BorderSide(color: Colors.red, width: 0.1.w), borderRadius: BorderRadius.circular(8.r),),
        focusedErrorBorder: OutlineInputBorder(borderSide:  BorderSide(color:Colors.transparent, width: 0.1.w), borderRadius: BorderRadius.circular(8.r),),
      ),
    );
  }


  Widget buildImage(){
    if(imageFile ==null){
      return GestureDetector(
        onTap:(){
          _getFromGallery();
        },
          child: Center(child: SvgPicture.asset("images/img_avtar.svg",  width: 180.w,
            height: 174.h,)));
    }
    return Center(
      child: buildDottedBorder(child: Container(
        width: 180.w,
        height: 174.h,
        decoration: BoxDecoration(color: CustomColors.sDarkColor3),
        child: Stack(
          children: [

              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.file(imageFile!, width: 178.w, height: 172.h,)),


            Positioned(
              left: 8.w,
              right: 8.w,
              bottom: 20.h,
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
}
