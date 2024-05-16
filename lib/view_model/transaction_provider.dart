import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/file_storage.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/user_saved_bank_model.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/services/api_services.dart';
import 'package:spraay/ui/dashboard/dashboard_screen.dart';
import 'package:spraay/ui/others/payment_receipt.dart';
import 'package:spraay/utils/my_sharedpref.dart';
import 'package:spraay/view_model/auth_provider.dart';

class TransactionProvider extends ChangeNotifier {


  ApiServices service=ApiServices();
  String mytoken=MySharedPreference.getToken();

  // bool get loading => isLoading;
  bool  loading =false;

  setloading(bool load) async{
    loading = load;
    notifyListeners();
  }

  setloadingNoNotif(bool load) async{
    loading = load;
  }


  fetchWithdrawalApi(BuildContext context, String bankName, String accountNumber,
      String bankCode, String transactionPin,String amount, String fromWhere, String accountName) async{
    setloading(true);
    var result=await service.withdrawalApi(mytoken, bankName, accountNumber, bankCode, transactionPin,amount.replaceAll(",", ""));
    if(result['error'] == true){

      //Failed transaction
      // ignore: use_build_context_synchronously
      popupDialog(context: context, title: "Transaction Failed", content: result['message'],
          buttonTxt: 'Try again',
          onTap: () {Navigator.pop(context);}, png_img: 'Incorrect_sign');
    }else{


      // ignore: use_build_context_synchronously
      popupSuccessfulDialog(context: context, title: "Transaction successful",
          content: "You have successfully withdrawn N$amount to $accountName $accountNumber",
          buttonTxt: "Great! Take me Home", onTap: (){
            Navigator.pushAndRemoveUntil(context, FadeRoute(page: const DasboardScreen()),(Route<dynamic> route) => false);
            Provider.of<AuthProvider>(context, listen: false).onItemTap(0);

          }, png_img: "verified", fromWhere: fromWhere,transactionId: result["transactionId"].toString(),amount: result["amount"].toString(),type: result["type"],
          dateCreated: result["dateCreated"].toString(),
          reference: result["reference"]);


    }
    setloading(false);
  }

  List<DatumSavedBank>? savedBankList;
  fetchSavedBanksInfoApi() async{
    setloadingNoNotif(true);
    var apiResponse=await service.savedBanksInfoApi(mytoken);
    if(apiResponse.error==true){
      savedBankList=[];
      print("No Category for event=${apiResponse.errorMessage??""}");
    }else{
      savedBankList=apiResponse.data?.data??[];
    }
    setloadingNoNotif(false);
    notifyListeners();
  }


  downloadPdf(BuildContext context ,String transactionListID) async{
    setloading(true);
    var result=await ApiServices().downloadSingleTransaction(MySharedPreference.getToken(), transactionListID);
    if(result['error'] == true){
      errorCherryToast(context, result['message']);
    }else{
      toastMessage("Receipt Downloaded");
      FileStorage.saveDownloadedFile(result["bytes"], "spray.pdf");
      sharePdfFile(context, result["bytes"],"spray");
    }
    setloading(false);
  }


  fetchdownloadSOAApi(BuildContext context ,String startDate, String endDate) async{
    setloading(true);
    var result=await ApiServices().downloadSOA(mytoken, MySharedPreference.getUId(), startDate, endDate);
    if(result['error'] == true){
      errorCherryToast(context, result['message']);
    }else{

      if (context.mounted){
        popupWithTwoBtnDialog(context: context, title: "Statement sent",
            content: "Your bank statement has been sent to ${MySharedPreference.getEmail()}",
            buttonTxt: "Great!", onTap: (){
              Navigator.pop(context);
              Navigator.pop(context);

            }, png_img: "verified", btn2Txt: 'Request another', onTapBtn2: () {
              Navigator.pop(context);
            });
      }

    }
    setloading(false);
  }

  popupSuccessfulDialog({ required BuildContext context, required String title, required String content, required String buttonTxt,
    required void Function() onTap, required String png_img, required String fromWhere,

    String? transactionId, String? amount, String? type,String? dateCreated, String? reference
  }){
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;

    return showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black54,
        builder: (BuildContext context){
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState){
                return Dialog(
                  backgroundColor: CustomColors.sDarkColor2,
                  insetPadding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.r),),
                  child: Container(
                    width: 340.w,
                    decoration: BoxDecoration(
                      color: CustomColors.sDarkColor2,
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                    child: Padding(
                      padding:  EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 20.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          height40,
                          Image.asset("images/$png_img.png",width: 140.w, height: 140.h),
                          // Container(width: 140.w, height: 140.h, color: Colors.yellow,),
                          height30,
                          Text(title, style: CustomTextStyle.kTxtBold.copyWith(fontSize: 24.sp, fontWeight: FontWeight.w700, color: CustomColors.sPrimaryColor400),),
                          height16,
                          SizedBox(
                              width: 276.w,
                              child: Text(content, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: CustomColors.sWhiteColor),
                                textAlign: TextAlign.center,)),
                          height30,
                          CustomButton(
                              onTap: onTap,
                              buttonText: buttonTxt, borderRadius: 30.r,
                              buttonColor:  CustomColors.sPrimaryColor500),
                          height22,
                          CustomButton(
                              onTap:(){
                                if(fromWhere=="new_bank_screen"){
                                  //call this if you route in through new_bank_screen
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(context, FadeRoute(page: PaymentReceipt(svg_img: 'spray_anim', type: type??"", date: dateCreated??"", amount: amount??"", meterNumber: '',
                                    transactionRef: reference??"", transStatus: 'Successful', transactionId: transactionId??"",)));

                                }else{
                                  //call this if you route in through to_bank_screen
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(context, FadeRoute(page: PaymentReceipt(svg_img: 'spray_anim', type: type??"", date: dateCreated??"", amount: amount??"", meterNumber: '',
                                    transactionRef: reference??"", transStatus: 'Successful', transactionId: transactionId??"",)));

                                }
                              },
                              buttonText: "View Receipt", borderRadius: 30.r,
                              buttonColor:  CustomColors.sDarkColor3),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

}