import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/category_list_model.dart';
import 'package:spraay/services/api_services.dart';
import 'package:spraay/ui/events/dummy_search.dart';
import 'package:spraay/utils/my_sharedpref.dart';
import 'package:spraay/view_model/auth_provider.dart';
import 'package:spraay/view_model/event_provider.dart';
import 'package:path/path.dart' as baseImg;


class EditEvent extends StatefulWidget {

  String fromPage,eventname,event_date,eventTime,eventVenue,eventCategory, eventdescription, event_CoverImage,eventId;
   EditEvent({required this.fromPage, required this.eventname, required this.event_date, required this.eventTime, required this.eventVenue,
     required this.eventCategory, required this.eventdescription, required this.event_CoverImage, required this.eventId});

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {

  TextEditingController fullNameController=TextEditingController();
  TextEditingController dateController=TextEditingController();
  TextEditingController timeController=TextEditingController();

  TextEditingController venueController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();
  TextEditingController categoryController=TextEditingController();
  TextEditingController txtCategoryController=TextEditingController();



  final GlobalKey<FormState> _myKey = GlobalKey<FormState>();
  bool _isObscure = true;



  FocusNode? _textField1Focus;
  FocusNode? _textField2Focus;
  FocusNode? _textField3Focus;
  FocusNode? _textField4Focus;
  FocusNode? _textField5Focus;
  FocusNode? _textField6Focus;
  TimeOfDay ?_openPickupTime;
  FocusNode? _textField7Focus;


  String coverImage="";
  String eventId="";
  @override
  void initState() {
    Provider.of<EventProvider>(context, listen: false).fetchCategoryListApi(context);

    setState(() {
      fullNameController.text=widget.eventname;
      dateController.text=widget.event_date;
      timeController.text=widget.eventTime;
      venueController.text=widget.eventVenue;
      categoryController.text=widget.eventCategory;
      descriptionController.text=widget.eventdescription;
      coverImage=widget.event_CoverImage;
      eventId=widget.eventId;

      _textField1Focus = FocusNode();
      _textField2Focus = FocusNode();
      _textField3Focus = FocusNode();
      _textField4Focus = FocusNode();
      _textField5Focus=FocusNode();
      _textField6Focus=FocusNode();
      _textField7Focus=FocusNode();
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
    _textField7Focus?.dispose();
    super.dispose();
  }

  EventProvider? eventProvider;
  @override
  void didChangeDependencies() {
    eventProvider=context.watch<EventProvider>();
    super.didChangeDependencies();
  }



  bool _loadEvent=false;
  final _debouncer = Debouncer(milliseconds: 1500);
  fetchEventCategoryEnteredApi(String eventName) async{
    setState(() {_loadEvent=true;});
    var result=await ApiServices().eventCategoryEntered(eventName, MySharedPreference.getToken());
    if(result['error'] == true){
      print("Error: ${result["message"]}");
    }else{
      setState(() {
        categoryController.text=result["categoryId"];
        thirdVal=result["categoryId"];
      });
      // result["categoryName"];
    }
    setState(() {_loadEvent=false;});
  }


  int step=1;
  @override
  Widget build(BuildContext context) {
    return  LoadingOverlayWidget(
      loading: eventProvider?.loading??false,
      child: Scaffold(
          appBar: buildAppBar(context: context, title:"Edit Event" ),
          body: Form(
            key: _myKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child:  buildStep1Widget(),
          )),
    );

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
        CustomizedTextField(textEditingController:dateController, keyboardType: TextInputType.datetime,
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
              secondVal=_openPickupTime?.format(context)??"";
            });

            timeController.text=_openPickupTime?.format(context)??"";

          },
        ),
        height16,
        DummyMapSearch(venueController: venueController, query: fiveVal, textField5Focus: _textField5Focus),


        height16,
        buildCategory(),
        _isOtherTrue?  Padding(
          padding:  EdgeInsets.only(top: 16.h),
          child: CustomizedTextField(textEditingController:txtCategoryController, keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,hintTxt: "Enter category",focusNode: _textField7Focus,
            onChanged:(value){
              _debouncer.run(() {
                if(value.isNotEmpty){
                  fetchEventCategoryEnteredApi(value);
                }else{

                }
                //perform search here
              });

            },
          ),
        ) : const SizedBox.shrink(),

        height16,
        CustomizedTextField(
          textEditingController:descriptionController, keyboardType: TextInputType.text,
          maxLength: 150,
          maxLines: 4,
          textInputAction: TextInputAction.done,hintTxt: "Event description (Not more than 150 words)",
          focusNode: _textField6Focus,
          onChanged:(value){
            setState(() {sixVal=value;});
          },
        ),
        height8,
        buildImage(),
        height26,


        CustomButton(
            onTap: () {

              if( widget.fromPage=="view_event"){
                //when routed through view_event page edit event

                //url image pass to api
                eventProvider?.editEventApi(context, fullNameController.text, descriptionController.text, venueController.text,
                    dateController.text, timeController.text, categoryController.text, eventProvider?.file_url??"", eventId, "view_event",
                    eventProvider?.new_longitude.toString()??"0.00",
                    eventProvider?.new_latitude.toString()??"0.00");

              }else{

                eventProvider?.editEventApi(context, fullNameController.text, descriptionController.text, venueController.text,
                    dateController.text, timeController.text, categoryController.text, eventProvider?.file_url??"", eventId, "",
                    eventProvider?.new_longitude.toString()??"0.00",
                    eventProvider?.new_latitude.toString()??"0.00");

              }


            },
            buttonText: 'Confirm', borderRadius: 30.r,width: 380.w,
            buttonColor: CustomColors.sPrimaryColor500),
        height22,

      ],
    );
  }




  bool _isOtherTrue=false;
  Widget buildCategory(){
    return DropdownButtonFormField<CategoryDatum>(
      iconEnabledColor: CustomColors.sDisableButtonColor,
      isDense: false,
      dropdownColor: Color(0xff212121),
      focusNode: _textField3Focus,
      items: eventProvider?.dataList.map((CategoryDatum value) {
        return DropdownMenuItem<CategoryDatum>(
          value: value,
          child: Text(value.name??"", style: CustomTextStyle.kTxtSemiBold.copyWith(color: CustomColors.sGreyScaleColor100,
              fontSize: 14.sp, fontWeight: FontWeight.w500), ),
        );
      }).toList(),
      onChanged: (CategoryDatum? newValue) {

        if(newValue?.name=="OTHER"){
          setState(() {_isOtherTrue=true;});

        }else{
          setState(() {_isOtherTrue=false;});
          categoryController.text=newValue?.id??"";
          thirdVal=newValue?.id??"";
        }

      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
        hintText: categoryController.text.isEmpty? "Category": categoryController.text,
        isDense: true,
        filled: true,
        // prefixIconConstraints:  BoxConstraints(minWidth: 19, minHeight: 19,),
        // prefixIcon:Padding(padding:  EdgeInsets.only(right: 8.w, left: 10.w), child: SizedBox.shrink(),),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0.1),borderRadius: BorderRadius.circular(8.r),),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: CustomColors.sPrimaryColor500, width: 0.5),borderRadius: BorderRadius.circular(8.r),),
        hintStyle: CustomTextStyle.kTxtSemiBold.copyWith(color: CustomColors.sGreyScaleColor100,
            fontSize: 14.sp, fontWeight: FontWeight.w500),
        fillColor:_textField3Focus!.hasFocus? CustomColors.sTransparentPurplecolor : CustomColors.sDarkColor2,
        errorBorder:  OutlineInputBorder(borderSide:  BorderSide(color: Colors.red, width: 0.1.w), borderRadius: BorderRadius.circular(8.r),),
        focusedErrorBorder: OutlineInputBorder(borderSide:  BorderSide(color:Colors.transparent, width: 0.1.w), borderRadius: BorderRadius.circular(8.r),),
      ),
    );
  }


  Widget buildImage(){
    return Center(
      child: buildDottedBorder(child: Container(
        width: 180.w,
        height: 174.h,
        decoration: BoxDecoration(color: CustomColors.sDarkColor3),
        child: Stack(
          children: [



            imageFile ==null?  ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: CachedNetworkImage(
                width:178.w,
                height: 172.h,
                fit: BoxFit.contain,
                imageUrl:coverImage,
                placeholder: (context, url) => Center(child: SpinKitFadingCircle(size: 30,color: Colors.grey,)),
                errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
              ),
            ):
          ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
        child: Image.file(imageFile!, width: 178.w, height: 172.h, fit: BoxFit.cover,)),

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

      eventProvider?.fetchUploadFile(context, imageFile!, baseImg.basename(imageFile?.path??""));
    }
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


  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1800, 8),
        lastDate: DateTime(3000,12));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        forthVal="value";
      });
      dateController.text=  DateFormat('yyyy-MM-dd').format(selectedDate);
      // print("selectedDate==${selectedDate}");
    }
  }


}
