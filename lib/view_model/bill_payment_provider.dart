
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/reusable_widget.dart';
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

  fetchAirtimePurchaseApi(BuildContext context ,String mytoken, String service_provider, String phoneNumber,String amount,String transactionPin,String svg_img ) async{
    setloading(true);
    var result=await service.airtimePurchaseApi(mytoken, service_provider, phoneNumber, amount.replaceAll(",", ""), transactionPin);
    if(result['error'] == true){
      if(context.mounted){
        errorCherryToast(context, result['message']);
      }
    }else{
      if (context.mounted){

        Provider.of<AuthProvider>(context, listen: false).fetchUserDetailApi(context);
        Provider.of<EventProvider>(context, listen: false).fetchTransactionListApi();

        popupWithTwoBtnDialog(context: context, title: "Top-up Successful",
            content: result["message"]/*"$phoneNumber has been credited with ₦${amount}"*/,
            buttonTxt: "Okay", onTap: (){
              Navigator.pushAndRemoveUntil(context, FadeRoute(page: DasboardScreen()),(Route<dynamic> route) => false);
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

        Provider.of<AuthProvider>(context, listen: false).fetchUserDetailApi(context);
        Provider.of<EventProvider>(context, listen: false).fetchTransactionListApi();

        popupWithTwoBtnDialog(context: context, title: "Top-up Successful",
            content: result["message"]/*"$phoneNumber has been credited with ₦${amount}"*/,
            buttonTxt: "Okay", onTap: (){
              Navigator.pushAndRemoveUntil(context, FadeRoute(page: DasboardScreen()),(Route<dynamic> route) => false);
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
      String transactionPin,String svg_img, String dataPlanId ) async{
    setloading(true);
    var result=await service.dataPurchaseApi(mytoken, service_provider, phoneNumber,dataPlanId, transactionPin);
    if(result['error'] == true){
      if(context.mounted){
        errorCherryToast(context, result['message']);
      }
    }else{
      if (context.mounted){

        Provider.of<AuthProvider>(context, listen: false).fetchUserDetailApi(context);
        Provider.of<EventProvider>(context, listen: false).fetchTransactionListApi();

        popupWithTwoBtnDialog(context: context, title: "Top-up Successful",
            content: result["message"]/*"$phoneNumber has been credited with ₦${amount}"*/,
            buttonTxt: "Okay", onTap: (){
              Navigator.pushAndRemoveUntil(context, FadeRoute(page: DasboardScreen()),(Route<dynamic> route) => false);
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



}