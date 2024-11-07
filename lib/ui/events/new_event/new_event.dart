import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/category_list_model.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/services/api_services.dart';
import 'package:spraay/services/location_service.dart';
import 'package:spraay/ui/events/dummy_search.dart';
import 'package:spraay/ui/events/new_event/confirmation_page.dart';
import 'package:spraay/utils/my_sharedpref.dart';
import 'package:spraay/view_model/event_provider.dart';
import 'package:path/path.dart' as baseImg;


class NewEvent extends StatefulWidget {
  const NewEvent({Key? key}) : super(key: key);

  @override
  State<NewEvent> createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {

  TextEditingController fullNameController=TextEditingController();
  TextEditingController venueController=TextEditingController();
  TextEditingController categoryController=TextEditingController();
  TextEditingController txtCategoryController=TextEditingController();
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

  FocusNode? _textField7Focus;

  EventProvider? eventProvider;
  @override
  void didChangeDependencies() {
    eventProvider=context.watch<EventProvider>();
    super.didChangeDependencies();
  }


  @override
  void initState() {
    Provider.of<EventProvider>(context, listen: false).fetchCategoryListApi(context);

    setState(() {
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
  double latitude=0.00;
  double longitude=0.00;
  @override
  Widget build(BuildContext context) {
    return  LoadingOverlayWidget(
      loading: eventProvider?.loading??false,
      child: Scaffold(
          appBar: buildAppBar(context: context, title:"New Event" ),
          body: Form(
            key: _myKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child:  buildStep1Widget(),
          )),
    );

  }

  TimeOfDay? newSelectedTime;
  String _timeOutput = '';

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

          // if(Platform.isIOS){
          //   newSelectedTime = await showTimePicker(helpText: "Select Time",
          //       context: context,
          //       builder: (context, childWidget) {
          //         return MediaQuery(
          //           data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          //           child: childWidget!,
          //         );
          //       },
          //     initialTime: TimeOfDay.now(),
          //   );
          //   log("timm=${_openPickupTime?.format(context)}");
          //   setState(() {
          //     _openPickupTime = newSelectedTime ?? TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 10)));
          //     timeController.text=convertTo12HourFormat(_openPickupTime?.format(context)??"");
          //     secondVal=convertTo12HourFormat(_openPickupTime?.format(context)??"");
          //   });
          // }

            newSelectedTime = await showRoundedTimePicker(
                context: context,
                theme:  ThemeData.dark(useMaterial3: true),
                initialTime: TimeOfDay.now(),
                locale: const Locale('en', 'US')
            );

            //check if the default time is set to 24 hours format
            bool is24HoursFormat = MediaQuery.of(context).alwaysUse24HourFormat;

            setState(() {
              if(is24HoursFormat==false){
                //12 hour
                _openPickupTime = newSelectedTime ?? TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 10)));
                secondVal=_openPickupTime?.format(context)??"";
                timeController.text=_openPickupTime?.format(context)??"";

              }else{
                //24 hours
                // Check if the picked time is in 24-hour format
                if (newSelectedTime!.period == DayPeriod.am) {
                  // If it's in AM, convert to 12-hour format
                  newSelectedTime = TimeOfDay(hour: newSelectedTime!.hour % 12, minute: newSelectedTime!.minute);
                  _timeOutput = '${newSelectedTime!.format(context)} AM';
                } else {
                  // If it's in PM, add 12 to the hour to convert to 12-hour format
                  newSelectedTime = TimeOfDay(hour: newSelectedTime!.hour % 12, minute: newSelectedTime!.minute);
                  _timeOutput = '${newSelectedTime!.format(context)} PM';
                }

                timeController.text=_timeOutput;
                secondVal=_timeOutput;
              }
            });


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
                  // setState(() {
                  //   widget.query="";
                  //   dataList=[];
                  // });
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
              // print("show latitu=${eventProvider?.new_latitude} longit=${eventProvider?.new_longitude} dsc=${venueController.text}");

              // Navigator.of(context).push(MaterialPageRoute(builder: (_)=> DummyMapSearch()));
              // LocationService().placeAuthComplete("Lekki, Lagos");

              if( firstVal.isNotEmpty && secondVal.isNotEmpty && thirdVal.isNotEmpty && forthVal.isNotEmpty && venueController.text.isNotEmpty
                  && sixVal.isNotEmpty && eventProvider!.file_url.isNotEmpty){

                eventProvider?.fetchCreateEventApi(
                    context, fullNameController.text, descriptionController.text, venueController.text,
                    dobController.text, timeController.text, categoryController.text, eventProvider!.file_url,eventProvider?.new_longitude.toString()??"0.00",
                    eventProvider?.new_latitude.toString()??"0.00");

                // Navigator.push(context, SlideLeftRoute(page: EventConfirmationPage()));

              }
            },
            buttonText: 'Continue', borderRadius: 30.r,width: 380.w,
            buttonColor: (firstVal.isNotEmpty && secondVal.isNotEmpty && thirdVal.isNotEmpty && forthVal.isNotEmpty&& venueController.text.isNotEmpty && sixVal.isNotEmpty
                && eventProvider!.file_url.isNotEmpty) ? CustomColors.sPrimaryColor500:
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
        lastDate: DateTime(3000,12));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        forthVal="value";
      });
      dobController.text=  DateFormat('yyyy-MM-dd').format(selectedDate);
      // print("selectedDate==${selectedDate}");
    }
  }

  bool _isOtherTrue=false;
  Widget buildCategory(){
    return DropdownButtonFormField<CategoryDatum>(
      iconEnabledColor: CustomColors.sDisableButtonColor,
      isDense: false,
      dropdownColor: const Color(0xff212121),
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
          print("True");
          setState(() {_isOtherTrue=true;});

        }else{
          print("False");
         setState(() {_isOtherTrue=false;});
          categoryController.text=newValue?.id??"";
          thirdVal=newValue?.id??"";
        }

      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
        hintText: "Category",
        isDense: true,
        filled: true,
        // prefixIconConstraints:  BoxConstraints(minWidth: 19, minHeight: 19,),
        // prefixIcon:Padding(padding:  EdgeInsets.only(right: 8.w, left: 10.w), child: SizedBox.shrink(),),
        enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.transparent, width: 0.1),borderRadius: BorderRadius.circular(8.r),),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: CustomColors.sPrimaryColor500, width: 0.5),borderRadius: BorderRadius.circular(8.r),),
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
          child: Center(child: SvgPicture.asset("images/img_upl.svg",  width: 180.w,
            height: 174.h,)));
    }
    return Center(
      child: buildDottedBorder(child: Container(
        width: 180.w,
        height: 174.h,
        decoration: const BoxDecoration(color: CustomColors.sDarkColor3),
        child: Stack(
          children: [

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

  TextEditingController _searchController=TextEditingController();
  Widget buildSearch(){
    return Container(
      height: 48.h,
      margin: EdgeInsets.symmetric(horizontal: 18.w),
      padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 0.h),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10.r))),
      child: TextField(
        // onChanged: (value) => _runFilter(value),
        autofocus: false,
        controller: _searchController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        readOnly: false,
        style: CustomTextStyle.kTxtMedium.copyWith(fontFamily: "Metropolis", fontSize: 18.sp,),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(top: 7, left: 0, right: 15, bottom: 7),
          suffixIconConstraints: const BoxConstraints(minWidth: 19, minHeight: 19,),
          suffixIcon:  InkWell(
            onTap:() async {
              //The location service api is here
              var place=await LocationService().getPlace(_searchController.text);
              _goToPlaceInMap(place); //This moves camera to the location searched
            },
            child: Container(
                width: 28.w,
                height: 28.h,
                // margin: EdgeInsets.only(top: 8.h),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10.r)), color: const Color(0xff076231)),
                child: Center(child: Icon(Icons.search, color: CustomColors.sWhiteColor,
                  size: 18.r,))),
          ),
          hintText: "Search...",
          hintStyle: CustomTextStyle.kTxtMedium.copyWith(fontSize: 14.sp, color: const Color(0xffA8A8A8), fontWeight: FontWeight.w400,),
        ),
      ),
    );
  }


  Future<void> _goToPlaceInMap(Map<String, dynamic> place) async {
    final double lat=place["geometry"]["location"]["lat"];
    final double lng=place["geometry"]["location"]["lng"];

    // final GoogleMapController controller = await _controller.future;
    // controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, lng), zoom: 16.4746)));
    // _setMarker(LatLng(lat, lng));//the marker move to the searched position
  }
}
