import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/view_model/event_provider.dart';

import '../../models/map_model.dart';

class DummyMapSearch extends StatefulWidget {

  TextEditingController venueController;
  String query;
  FocusNode? textField5Focus;
   DummyMapSearch({required this.venueController, required this.query, required this.textField5Focus});

  @override
  State<DummyMapSearch> createState() => _DummyMapSearchState();
}

class _DummyMapSearchState extends State<DummyMapSearch> {

  PlaceApiProvider apiClient=PlaceApiProvider();
  // String query="";


  bool _isLoading=false;
  List<Suggestion> dataList=[];
  fetchSuggestionsApi(String query) async{
    setState(() {_isLoading=true;});
    var apiResponse=await  apiClient.fetchSuggestions(query, "en");
    if(apiResponse.isNotEmpty){
      setState(() {dataList=apiResponse??[];});
    }else{
      setState(() {dataList=[];});
    }
    setState(() {_isLoading=false;});

  }

  final _debouncer = Debouncer(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        CustomizedTextField(
          textEditingController:widget.venueController, keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,hintTxt: "Venue",focusNode: widget.textField5Focus,
          onChanged:(value){

            _debouncer.run(() {
              // print("objectvalue==${value}");
              if(value.isNotEmpty){
                widget.query=value;
                fetchSuggestionsApi(widget.query);
              }else{
                // fetchSuggestionsApi("");
                setState(() {
                  widget.query="";
                  dataList=[];
                });
              }
              //perform search here
            });

            },
        ),


        Padding(
          padding:  EdgeInsets.only(top: 12.h, left: 8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:dataList.map((e) => InkWell(
                onTap:(){
                  getAddressCoordinates(e.description);
                },
                child: Padding(
                  padding:  EdgeInsets.only(bottom: 12.h),
                  child: Row(
                    children: [
                      SvgPicture.asset("images/location.svg", width: 20.w, height: 20.h,),
                      SizedBox(width: 8.w,),
                      Expanded(child: Text(e.description, style: CustomTextStyle.kTxtSemiBold.copyWith(color: CustomColors.sGreyScaleColor100, fontSize: 14.sp, fontWeight: FontWeight.w500),)),
                    ],
                  ),
                )),
            ).toList(),
          ),
        ),

        // Expanded(
        //   child: ListView.builder(
        //     physics: NeverScrollableScrollPhysics(),
        //     itemBuilder: (context, index) => ListTile(title: Text(dataList[index].description, style: CustomTextStyle.kTxtSemiBold.copyWith(color: CustomColors.sGreyScaleColor100, fontSize: 14.sp, fontWeight: FontWeight.w500),),
        //       onTap: () async{
        //
        //         getAddressCoordinates(dataList[index].description);
        //       },
        //     ),
        //     itemCount: dataList.length,
        //   ),
        // ),




      ],
    );
  }

  String result = '';
  void getAddressCoordinates(String address) async {
    widget.venueController.text=address;
    setState(() {dataList=[];});

    List<Location> locations = await locationFromAddress(address, localeIdentifier: "en");
    if (locations.isNotEmpty) {
      Location location = locations.first;

      Provider.of<EventProvider>(context, listen: false).setLatAndLong(location.latitude, location.longitude);
      // setState(() {
      //   widget.longitude=location.longitude;
      //   widget.latitude=location.latitude;
      //   result = 'Latitude: ${location.latitude}, Longitude: ${location.longitude}';
      // });

      // log("latitude=${result}");

    } else {
      setState(() {
        result = 'Location not found';
      });
    }
  }

}
