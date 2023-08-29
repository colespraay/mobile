import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/models/current_user.dart';
import 'package:spraay/models/registered_user_model.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/services/api_services.dart';
import 'package:spraay/ui/events/new_event/confirmation_page.dart';
import 'package:spraay/utils/my_sharedpref.dart';
import 'package:spraay/view_model/auth_provider.dart';

class EventProvider extends ChangeNotifier{
  bool get loading => isLoading;
  setloading(bool loading) async{
    isLoading = loading;
    notifyListeners();
  }

  setloadingNoNotif(bool loading) async{
    isLoading = loading;
  }


  ApiServices service=ApiServices();
  String mytoken=MySharedPreference.getToken();

  List<String> dataList=[];
  fetchCategoryListApi(BuildContext context) async{
    setloadingNoNotif(true);
    var apiResponse=await service.categoryListApi(mytoken);
    if(apiResponse.error==true){
      print("No Category for event=${apiResponse.errorMessage??""}");
      // errorCherryToast(context, apiResponse.errorMessage??"");
    }else{
      dataList=apiResponse.data?.data??[];
    }
    setloadingNoNotif(false);
    notifyListeners();
  }

  String file_url="";
  fetchUploadFile(context,File image, String filename) async{
    setloadingNoNotif(true);
    var result = await apiResponse.uploadFile(image, filename);
    if (result['error'] == true) {
      errorCherryToast(context, result['message']);
    }
    else {
      file_url=result['file_url'];
    }
    setloadingNoNotif(false);
    notifyListeners();
  }


  String? eventId,eventCode,qrCodeForEvent,eventname,eventdescription,event_date,eventTime, eventVenue,eventCategory,event_CoverImage;
  fetchCreateEventApi(BuildContext context, String eventName, String eventDescription,
      String venue, String eventDate, String time, String category, String eventCoverImage ) async{
    setloading(true);
    var result=await service.createEvent(eventName, eventDescription, venue,
        eventDate, time, category, eventCoverImage, mytoken);
    if(result['error'] == true){
      errorCherryToast(context, result['message']);
    }else{

      eventId= result["id"];

      eventCode= result["eventCode"];
      qrCodeForEvent= result["qrCodeForEvent"];
      eventname= result["eventName"];
      eventdescription= result["eventDescription"];
      event_date= result["eventDate"];
      eventTime= result["time"];
      eventVenue= result["venue"];
      eventCategory= result["category"];
      event_CoverImage= result["eventCoverImage"];

      notifyListeners();
      // =jsonResponse["data"]["id"];
      // result["eventCode"] =jsonResponse["data"]["eventCode"];
      // result["qrCodeForEvent"] =jsonResponse["data"]["qrCodeForEvent"];
      // result["eventName"] =jsonResponse["data"]["eventName"];

      // result["eventDescription"] =jsonResponse["data"]["eventDescription"];
      // result["eventDate"] =jsonResponse["data"]["eventDate"];
      // result["time"] =jsonResponse["data"]["time"];
      // result["venue"] =jsonResponse["data"]["venue"];

      // result["category"] =jsonResponse["data"]["category"];
      // result["eventCoverImage"] =jsonResponse["data"]["eventCoverImage"];

      Navigator.push(context, SlideLeftRoute(page: EventConfirmationPage()));

      // dataList=apiResponse.data?.data??[];
    }
    setloading(false);
    // notifyListeners();
  }

  List<RegisteredDatum> userInformationList=[];
  fetchUserDetailApi(BuildContext context) async{
    setloadingNoNotif(true);
    var apiResponse=await service.registeredUserListApi(mytoken);
    if(apiResponse.error==true){
      userInformationList=[];
      // errorCherryToast(context, apiResponse.errorMessage??"");
    }else{
      userInformationList= apiResponse.data?.data??[];
    }
    setloadingNoNotif(false);
    notifyListeners();
  }


  fetchSendInviteApi(BuildContext context, String eventId, List<String> userIds, List<String> selectedName) async{
    setloading(true);
    var result=await service.sendInvite(eventId, mytoken, userIds);
    if(result['error'] == true){
      errorCherryToast(context, result['message']);
    }else{
      popupDialog(context: context, title: "Invites successfully sent!", content: "You have successfully sent ${selectedName[0]} and ${userIds.length -1} others an invite to your event!",
          buttonTxt: 'Home',
          onTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          }, png_img: 'verified');
      // userInformationList= apiResponse.data?.data??[];
    }
    setloading(false);
  }


  editEventApi(BuildContext context ,String eventName, String eventDescription, String venue, String eventDate, String time, String category,
      String eventCoverImage, String eventId, String fromPage) async{
    setloading(true);
    var result=await service.editEvent(mytoken, eventName, eventDescription, venue, eventDate, time, category, eventCoverImage, eventId);
    if(result['error'] == true){
      errorCherryToast(context, result['message']);
    }else{
      if(fromPage=="view_event"){
        popupDialog(context: context, title: "Saved Successfully", content: "Your edit has been saved successfully.",
            buttonTxt: 'Home',
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              Provider.of<AuthProvider>(context, listen: false).onItemTap(0);
            }, png_img: 'verified');
      }else{
        popupDialog(context: context, title: "Saved Successfully", content: "Your edit has been saved successfully.",
            buttonTxt: 'Home',
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Provider.of<AuthProvider>(context, listen: false).onItemTap(0);

            }, png_img: 'verified');

      }




      // userInformationList= apiResponse.data?.data??[];
    }
    setloading(false);
  }




  List<DatumCurrentUser> ?userHorizontalScrool;
  fetchCurrentUserApi() async{
    setloadingNoNotif(true);
    var apiResponse=await service.currentUser(MySharedPreference.getToken());
    if(apiResponse.error==true){
      userHorizontalScrool=[];
      print("No Category for event=${apiResponse.errorMessage??""}");
      // errorCherryToast(context, apiResponse.errorMessage??"");
    }else{
      userHorizontalScrool=apiResponse.data?.data??[];
    }
    setloadingNoNotif(false);
    notifyListeners();
  }

}