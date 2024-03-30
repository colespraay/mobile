
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/models/airtime_topup_model.dart';
import 'package:spraay/models/cable_tv_model.dart';
import 'package:spraay/models/pre_post_model.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/services/api_services.dart';
import 'package:spraay/ui/dashboard/dashboard_screen.dart';
import 'package:spraay/ui/others/payment_receipt.dart';
import 'package:spraay/utils/my_sharedpref.dart';
import 'package:spraay/view_model/auth_provider.dart';
import 'package:spraay/view_model/event_provider.dart';

class BillPaymentProvider extends ChangeNotifier {

  ApiServices service = ApiServices();
  String mytoken = MySharedPreference.getToken();

  // bool get loading => isLoading;
  bool loading = false;

  setloading(bool load) async {
    loading = load;
    notifyListeners();
  }

  setloadingNoNotif(bool loadn) async{
    loading = loadn;
  }


  List<AirtimeTopUpDatum> airtimeTopUpList=[];
  fetchAirtimeTopUpList() async{
    setloadingNoNotif(true);
    var apiResponse=await service.airtimeDataTopUpApi(MySharedPreference.getToken());
    if(apiResponse.error==true){
      airtimeTopUpList=[];
    }else{
      airtimeTopUpList=apiResponse.data?.data??[];
    }
    setloadingNoNotif(false);
    notifyListeners();
  }


  List<CableTvDatum> cableTvListList=[];
  fetchCableTvListList() async{
    setloadingNoNotif(true);
    var apiResponse=await service.cableTvModelApi(MySharedPreference.getToken());
    if(apiResponse.error==true){
      cableTvListList=[];
    }else{
      cableTvListList=apiResponse.data?.data??[];
    }
    setloadingNoNotif(false);
    notifyListeners();
  }


  List<CableTvDatum> eletricityList=[];
  fetchEletricityProvidersApiList() async{
    setloadingNoNotif(true);
    var apiResponse=await service.eletricityProvidersApi(MySharedPreference.getToken());
    if(apiResponse.error==true){
      eletricityList=[];
    }else{
      eletricityList=apiResponse.data?.data??[];
    }
    setloadingNoNotif(false);
    notifyListeners();
  }


  List<PrePostDatum> prePostList=[];
  fetchPrePostAPIList(String merchantPublicId) async{
    setloadingNoNotif(true);
    var apiResponse=await service.prePostApi(MySharedPreference.getToken(),merchantPublicId);
    if(apiResponse.error==true){
      prePostList=[];
    }else{
      prePostList=apiResponse.data?.data??[];
    }
    setloadingNoNotif(false);
    notifyListeners();
  }

  fetchAirtimePurchaseApi(BuildContext context ,String mytoken, String providerId, String phoneNumber,String amount,String transactionPin,String svg_img ) async{
    setloading(true);
    var result=await service.airtimePurchaseApi(mytoken, providerId, phoneNumber, amount.replaceAll(",", ""), transactionPin);
    if(result['error'] == true){
      if(context.mounted){
        errorCherryToast(context, result['message']);
      }
    }else{
      if (context.mounted){

        Provider.of<AuthProvider>(context, listen: false).fetchUserDetailApi();
        Provider.of<EventProvider>(context, listen: false).fetchTransactionListApi();

        popupWithTwoBtnDialog(context: context, title: "Top-up Successful",
            content: result["message"]/*"$phoneNumber has been credited with ₦${amount}"*/,
            buttonTxt: "Okay", onTap: (){
              Navigator.pushAndRemoveUntil(context, FadeRoute(page: const DasboardScreen()),(Route<dynamic> route) => false);
              Provider.of<AuthProvider>(context, listen: false).onItemTap(0);

            }, png_img: "verified", btn2Txt: 'View Receipt', onTapBtn2: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);

              Navigator.pushReplacement(context, FadeRoute(page: PaymentReceipt(svg_img: svg_img, type: result["message"], date: result["dateCreated"], amount: '₦$amount', meterNumber: result["phoneNumber"], transactionRef: result["transactionId"] , transStatus: 'Successful', transactionId: '',)));
            });


      }
    }
    setloading(false);
  }


  fetchelEctricityUnitPurchaseApi(BuildContext context ,String mytoken, String service_provider, String phoneNumber,String amount,String transactionPin,String svg_img,
      String plan,String billerName ) async{
    setloading(true);
    var result=await service.electricityUnitPurchaseApi(mytoken, service_provider, phoneNumber, amount.replaceAll(",", ""), transactionPin, plan, billerName);
    if(result['error'] == true){
      if(context.mounted){
        errorCherryToast(context, result['message']);
      }
    }else{
      if (context.mounted){

        Provider.of<AuthProvider>(context, listen: false).fetchUserDetailApi();
        Provider.of<EventProvider>(context, listen: false).fetchTransactionListApi();

        popupWithTwoBtnDialog(context: context, title: "Top-up Successful",
            content: result["message"]/*"$phoneNumber has been credited with ₦${amount}"*/,
            buttonTxt: "Okay", onTap: (){
              Navigator.pushAndRemoveUntil(context, FadeRoute(page: const DasboardScreen()),(Route<dynamic> route) => false);
              Provider.of<AuthProvider>(context, listen: false).onItemTap(0);

            }, png_img: "verified", btn2Txt: 'View Receipt', onTapBtn2: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);

              Navigator.pushReplacement(context, FadeRoute(page: PaymentReceipt(svg_img: svg_img, type: result["message"], date: result["dateCreated"], amount: '₦$amount', meterNumber: result["phoneNumber"], transactionRef: result["transactionId"] , transStatus: 'Successful', transactionId: '',)));
            });


      }

    }
    setloading(false);
  }


  fetchDataPurchaseApi(BuildContext context ,String mytoken, String service_provider, String phoneNumber,String amount,
      String transactionPin,String svg_img, String dataPlanId,String dataSubCode ) async{
    setloading(true);
    var result=await service.dataPurchaseApi(mytoken, service_provider, phoneNumber,dataPlanId, transactionPin,dataSubCode);
    if(result['error'] == true){
      if(context.mounted){
        errorCherryToast(context, result['message']);
      }
    }else{
      if (context.mounted){

        Provider.of<AuthProvider>(context, listen: false).fetchUserDetailApi();
        Provider.of<EventProvider>(context, listen: false).fetchTransactionListApi();

        popupWithTwoBtnDialog(context: context, title: "Top-up Successful",
            content: result["message"]/*"$phoneNumber has been credited with ₦${amount}"*/,
            buttonTxt: "Okay", onTap: (){
              Navigator.pushAndRemoveUntil(context, FadeRoute(page: const DasboardScreen()),(Route<dynamic> route) => false);
              Provider.of<AuthProvider>(context, listen: false).onItemTap(0);

            }, png_img: "verified", btn2Txt: 'View Receipt', onTapBtn2: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);

              Navigator.pushReplacement(context, FadeRoute(page: PaymentReceipt(svg_img: svg_img, type: result["message"], date: result["dateCreated"], amount: '₦$amount', meterNumber: result["phoneNumber"], transactionRef: result["transactionId"] , transStatus: 'Successful', transactionId: '',)));
            });


      }

    }
    setloading(false);
  }



  //cablePurchaseApi
  fetchCablePurchaseApi(BuildContext context ,String mytoken, String service_provider, String phoneNumber,String amount,
      String transactionPin,String svg_img, String dataPlanId,String cableCode ) async{
    setloading(true);
    var result=await service.cablePurchaseApi(mytoken,service_provider, phoneNumber, dataPlanId, transactionPin, amount,cableCode);
    if(result['error'] == true){
      if(context.mounted){
        errorCherryToast(context, result['message']);
      }
    }else{
      if (context.mounted){

        Provider.of<AuthProvider>(context, listen: false).fetchUserDetailApi();
        Provider.of<EventProvider>(context, listen: false).fetchTransactionListApi();

        popupWithTwoBtnDialog(context: context, title: "Top-up Successful",
            content: result["message"]/*"$phoneNumber has been credited with ₦${amount}"*/,
            buttonTxt: "Okay", onTap: (){
              Navigator.pushAndRemoveUntil(context, FadeRoute(page: const DasboardScreen()),(Route<dynamic> route) => false);
              Provider.of<AuthProvider>(context, listen: false).onItemTap(0);

            }, png_img: "verified", btn2Txt: 'View Receipt', onTapBtn2: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);

              Navigator.pushReplacement(context, FadeRoute(page: PaymentReceipt(svg_img: svg_img, type: result["message"], date: result["dateCreated"], amount: '₦$amount', meterNumber: result["phoneNumber"], transactionRef: result["transactionId"] , transStatus: 'Successful', transactionId: '',
              cableSubscriptionId: dataPlanId,)));
            });


      }

    }
    setloading(false);
  }



}