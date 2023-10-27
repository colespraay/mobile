import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/models/current_user.dart';
import 'package:spraay/models/graph_history_model.dart';
import 'package:spraay/models/notification_model.dart';
import 'package:spraay/models/recent_recipient_models.dart';
import 'package:spraay/models/registered_user_model.dart';
import 'package:spraay/models/transaction_models.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/services/api_services.dart';
import 'package:spraay/ui/dashboard/dashboard_screen.dart';
import 'package:spraay/ui/events/new_event/confirmation_page.dart';
import 'package:spraay/ui/others/payment_receipt.dart';
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


  double new_latitude=0.00;
  double new_longitude=0.00;
  setLatAndLong(double lat, double long) async{
    new_latitude = lat;
    new_longitude=long;
    notifyListeners();
  }


  double ?latitude ,longitude;
  String? eventId,eventCode,qrCodeForEvent,eventname,eventdescription,event_date,eventTime, eventVenue,eventCategory,event_CoverImage;
  fetchCreateEventApi(BuildContext context, String eventName, String eventDescription,
      String venue, String eventDate, String time, String category, String eventCoverImage,String longit, String lati ) async{
    setloading(true);
    var result=await service.createEvent(eventName, eventDescription, venue,
        eventDate, time, category, eventCoverImage, mytoken, longit, lati);
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
      latitude= double.parse(result["latitude"]);
      longitude= double.parse(result["longitude"]);

      notifyListeners();

      Navigator.push(context, SlideLeftRoute(page: EventConfirmationPage()));
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


  List<DatumRecent> recentUserInformationList=[];
  fetchRecentRecipientApi() async{
    setloadingNoNotif(true);
    var apiResponse=await service.recentRecipientApi(mytoken);
    if(apiResponse.error==true){
      recentUserInformationList=[];
      // errorCherryToast(context, apiResponse.errorMessage??"");
    }else{
      recentUserInformationList= apiResponse.data?.data??[];
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
      if (context.mounted){
        popupDialog(context: context, title: "Invites successfully sent!", content: "You have successfully sent ${selectedName[0]} and ${userIds.length -1} others an invite to your event!",
            buttonTxt: 'Home',
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            }, png_img: 'verified');
      }



      // userInformationList= apiResponse.data?.data??[];
    }
    setloading(false);
  }


  fetchSendGiftApi(BuildContext context, String amount, String receiverTag,String transactionPin) async{
    setloading(true);
    var result=await service.sendGift(amount.replaceAll(",", ""), mytoken, "@$receiverTag", transactionPin);
    if(result['error'] == true){
      // errorCherryToast(context, result['message']);
      if (context.mounted){
        popupDialog(context: context, title: "Transaction Failed", content:result['message'],
            buttonTxt: 'Try again',
            onTap: () {
              Navigator.pop(context);

            }, png_img: 'Incorrect_sign');
      }


    }else{


      if (context.mounted){
        Provider.of<AuthProvider>(context, listen: false).fetchUserDetailApi(context);
        Provider.of<EventProvider>(context, listen: false).fetchTransactionListApi();

        popupWithTwoBtnDialog(context: context, title: "Transaction successful",
            content: "You have successfully gifted $receiverTag N${amount}",
            buttonTxt: "Great! Take me Home", onTap: (){
              Navigator.pushAndRemoveUntil(context, FadeRoute(page: DasboardScreen()),(Route<dynamic> route) => false);
              Provider.of<AuthProvider>(context, listen: false).onItemTap(0);

            }, png_img: "verified", btn2Txt: 'View Receipt', onTapBtn2: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);

              Navigator.pushReplacement(context, FadeRoute(page: PaymentReceipt(svg_img: "spray_circle", type:"Spray Gift", date: dateTimeFormat(result['dateCreated'].toString()), amount: '₦$amount', meterNumber: '', transactionRef: '', transStatus: 'Successful', transactionId: '',)));
            });
      }
    }
    setloading(false);
  }


  editEventApi(BuildContext context ,String eventName, String eventDescription, String venue, String eventDate, String time, String category,
      String eventCoverImage, String eventId, String fromPage, String longitude, String latitude) async{
    setloading(true);
    var result=await service.editEvent(mytoken, eventName, eventDescription, venue, eventDate, time, category, eventCoverImage, eventId, longitude, latitude);
    if(result['error'] == true){
      if (context.mounted){
        errorCherryToast(context, result['message']);
      }

    }else{
      if(fromPage=="view_event"){
        if (context.mounted){
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
        }

      }else{
        if (context.mounted){
          popupDialog(context: context, title: "Saved Successfully", content: "Your edit has been saved successfully.",
              buttonTxt: 'Home',
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Provider.of<AuthProvider>(context, listen: false).onItemTap(0);

              }, png_img: 'verified');
        }


      }

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

  //graphHistoryApi
  List<DatumGraphHistory> ?datum_graph_histories;
  fetchGraphHistoryApi() async{
    setloadingNoNotif(true);
    var apiResponse=await service.graphHistoryApi(MySharedPreference.getToken());
    if(apiResponse.error==true){
      datum_graph_histories=[];
      print("No Category for event=${apiResponse.errorMessage??""}");
      // errorCherryToast(context, apiResponse.errorMessage??"");
    }else{
      datum_graph_histories=apiResponse.data?.data??[];
    }
    setloadingNoNotif(false);
    notifyListeners();
  }


  List<DatumTransactionModel>? transactionList;

  fetchTransactionListApi() async{
    setloadingNoNotif(true);
    var apiResponse=await service.transactionListApi(MySharedPreference.getToken(), MySharedPreference.getUId());
    if(apiResponse.error==true){
      transactionList=[];
      // print("fetchTransactionListApi Error=${apiResponse.errorMessage??""}");
      // errorCherryToast(context, apiResponse.errorMessage??"");
    }else{
      transactionList=apiResponse.data?.data??[];
    }
    setloadingNoNotif(false);
    notifyListeners();
  }


  List<NotificationDatum>? notificationlist;
  fetchNotificationApi() async{
    setloadingNoNotif(true);
    var apiResponse=await service.notificationApi(MySharedPreference.getToken(), MySharedPreference.getUId());
    if(apiResponse.error==true){
      notificationlist=[];
      // print("fetchTransactionListApi Error=${apiResponse.errorMessage??""}");
      // errorCherryToast(context, apiResponse.errorMessage??"");
    }else{
      notificationlist=apiResponse.data?.data??[];
    }
    setloadingNoNotif(false);
    notifyListeners();
  }

  acceptOrRejectEventApi(BuildContext context, String eventId, String status) async{
    setloading(true);
    var result=await service.acceptOrRejectEvent(eventId, mytoken, status);
    if(result['error'] == true){
      errorCherryToast(context, result['message']);
    }else{
      successCherryToast(context, result['message']);
    }
    setloading(false);
  }

}