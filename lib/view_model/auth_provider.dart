import 'package:flutter/cupertino.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/models/user_profile.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/services/api_services.dart';
import 'package:spraay/ui/authentication/create_account_otp_page.dart';
import 'package:spraay/ui/authentication/create_new_password.dart';
import 'package:spraay/ui/authentication/forgot_password_otp_verif.dart';
import 'package:spraay/ui/authentication/login_screen.dart';
import 'package:spraay/ui/authentication/pin_creation.dart';
import 'package:spraay/ui/authentication/tell_us_about_yourself.dart';
import 'package:spraay/ui/dashboard/dashboard_screen.dart';
import 'package:spraay/utils/my_sharedpref.dart';

class AuthProvider extends ChangeNotifier{

  //routing page for bottom nav
  int selectedIndex = 0;
  void onItemTap(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  bool get loading => isLoading;
  setloading(bool loading) async{
    isLoading = loading;
    notifyListeners();
  }

  setloadingNoNotif(bool loading) async{
    isLoading = loading;
  }


  // bool sWvalueFaceId = false;
  bool? value= MySharedPreference.getSwitchValuesForTouchID()==null? false: MySharedPreference.getSwitchValuesForTouchID();
  void changeSwitch(bool myvalue){
    value=myvalue;
    notifyListeners();
  }

  fetchRegistertEndpoint(context,String password,String email,String deviceId) async{
    setloading(true);
    var result = await apiResponse.register(password, email, deviceId);
    if (result['error'] == true) {
      errorCherryToast(context, result['message']);
    }
    else {
      toastMessage(result["message"]);
      await MySharedPreference.saveToken(result["token"]);
      await MySharedPreference.saveUId(result["userId"]);
      await MySharedPreference.savePhoneNumber(result["phoneNumber"]);

      Navigator.push(context, SlideLeftRoute(page: CreateAccountOtpPage()));
    }
    setloading(false);
  }


  resendOTPCodeEndpoint(context,String userID) async{
    setloading(true);
    var result = await apiResponse.resendOTPCode(userID);
    if (result['error'] == true) {
      errorCherryToast(context, result['message']);
    }
    else {
     toastMessage(result["message"]);
    }
    setloading(false);
  }


  int step=1;
  tellUsAboutYourselfEndpoint(context,String email, String userId, String firstName, String lastName, String gender,String dob ) async{
    setloading(true);
    var result = await apiResponse.tellUsAboutYourself(email, userId, firstName, lastName, gender, dob);
    if (result['error'] == true) {
      errorCherryToast(context, result['message']);
    }
    else {
       step=2;
      // successCherryToast(context, result["message"]);
    }
    setloading(false);
  }


  tellUsAboutYourselfTagEndpoint(context,String userTag, String userId) async{
    setloading(true);
    var result = await apiResponse.tellUsAboutYourselfTag(userTag, userId);
    if (result['error'] == true) {
      errorCherryToast(context, result['message']);
    }
    else {
      successCherryToast(context, result["message"]);
      Navigator.pushReplacement(context, FadeRoute(page: PinCreation()));
    }
    setloading(false);
  }


  initiateForgotPasswordEmailEndpoint(context,String emailAddress, String statusValue) async{
    setloading(true);
    var result = await apiResponse.initiateForgotPasswordEmail(emailAddress);
    if (result['error'] == true) {
      errorCherryToast(context, result['message']);
    }
    else {
      Navigator.push(context, SlideLeftRoute(page: ForgotPassOtp(emailAddress, statusValue)));

      // successCherryToast(context, result["message"]);
      // Navigator.pushReplacement(context, FadeRoute(page: PinCreation()));
    }
    setloading(false);
  }


  initiateForgotPasswordPhoneEndpoint(context,String phoneNumber, String statusValue) async{
    setloading(true);
    var result = await apiResponse.initiateForgotPasswordPhoneNumber(phoneNumber);
    if (result['error'] == true) {
      errorCherryToast(context, result['message']);
    }
    else {
      Navigator.push(context, SlideLeftRoute(page: ForgotPassOtp(phoneNumber, statusValue)));

      // successCherryToast(context, result["message"]);
      // Navigator.pushReplacement(context, FadeRoute(page: PinCreation()));
    }
    setloading(false);
  }


  initiateResendForgotPasswordPhoneEndpoint(context,String phoneNumber) async{
    setloading(true);
    var result = await apiResponse.initiateForgotPasswordPhoneNumber(phoneNumber);
    if (result['error'] == true) {
      errorCherryToast(context, result['message']);
    }
    else {
      // Navigator.push(context, SlideLeftRoute(page: ForgotPassOtp(phoneNumber, statusValue)));

      successCherryToast(context, result["message"]);
      // Navigator.pushReplacement(context, FadeRoute(page: PinCreation()));
    }
    setloading(false);
  }

  initiateResendForgotPasswordEmailEndpoint(context,String emailAddress) async{
    setloading(true);
    var result = await apiResponse.initiateForgotPasswordEmail(emailAddress);
    if (result['error'] == true) {
      errorCherryToast(context, result['message']);
    }
    else {
      successCherryToast(context, result["message"]);
    }
    setloading(false);
  }


  verifyOtpEndpoint(context,String uniqueVerificationCode) async{
    setloading(true);
    var result = await apiResponse.verifyOtp(uniqueVerificationCode);
    if (result['error'] == true) {
      errorCherryToast(context, result['message']);
    }
    else {
      Navigator.pushReplacement(context, SlideLeftRoute(page: CreateNewPassword(uniqueVerificationCode)));
    }
    setloading(false);
  }


  changeForgotPasswordEndpoint(context,String uniqueVerificationCode, String newPassword) async{
    setloading(true);
    var result = await apiResponse.changeForgotPassword(uniqueVerificationCode, newPassword);
    if (result['error'] == true) {
      errorCherryToast(context, result['message']);
    }
    else {
      popupDialog(context: context, title: "Password Changed", content: "You now have access to your account.",
          buttonTxt: 'Access Account',
          onTap: () {
            Navigator.pushAndRemoveUntil(context, FadeRoute(page: LoginScreen()),(Route<dynamic> route) => false);
          }, png_img: 'verified');
      // Navigator.pushReplacement(context, SlideLeftRoute(page: CreateNewPassword(uniqueVerificationCode)));
    }
    setloading(false);
  }


  createTransactionPinEndpoint(context,String transactionPin, String userId) async{
    setloading(true);
    var result = await apiResponse.createTransactionPin(transactionPin, userId);
    if (result['error'] == true) {
      errorCherryToast(context, result['message']);
    }
    else {

      //Save some info before moving them to home page

      // await MySharedPreference.saveEmail(result["email"]);
      // await MySharedPreference.saveToken(result["token"]);
      // await MySharedPreference.saveUId(result["id"]);
      // await MySharedPreference.saveFname(result["firstname"]);
      // await MySharedPreference.saveLastname(result["lastname"]);
      // await MySharedPreference.savePhoneNumber(result["phone"]);
      // await MySharedPreference.saveProfilePicture(result["profileImageUrl"]);


      // result["deviceId"]=loginResponse.data?.user?.deviceId??"";
      // result["virtualAccountName"]=loginResponse.data?.user?.virtualAccountName??"";
      // result["virtualAccountNumber"]=loginResponse.data?.user?.virtualAccountNumber??"";
      // result["bankName"]=loginResponse.data?.user?.bankName??"";
      // result["gender"]=loginResponse.data?.user?.gender??"";
      // result["dob"]=loginResponse.data?.user?.dob??"";
      // result["userTag"]=loginResponse.data?.user?.userTag??"";
      // result["allowPushNotifications"]=loginResponse.data?.user?.allowPushNotifications??false;
      // result["allowSmsNotifications"]=loginResponse.data?.user?.allowSmsNotifications??false;
      // result["allowEmailNotifications"]=loginResponse.data?.user?.allowEmailNotifications??false;
      // result["displayWalletBalance"]=loginResponse.data?.user?.displayWalletBalance??false;
      // result["enableFaceId"]=loginResponse.data?.user?.enableFaceId??false;

      MySharedPreference.setVisitingFlag();
      Navigator.pushAndRemoveUntil(context, FadeRoute(page: DasboardScreen()),(Route<dynamic> route) => false);
    }
    setloading(false);
  }

  registerVerifyCodeEndpoint(context,String uniqueVerificationCode) async{
    setloading(true);
    var result = await apiResponse.registerVerifyCode(uniqueVerificationCode, MySharedPreference.getToken());
    if (result['error'] == true) {
      errorCherryToast(context, result['message']);
    }
    else {
      popupDialog(context: context, title: "Registration Successful", content: "You have successfully registered your account. Now let’s know you.",
          buttonTxt: 'Continue',
          onTap: () {
            Navigator.pushReplacement(context, FadeRoute(page: TellUsAboutYourself()));
          }, png_img: 'verified');

    }
    setloading(false);
  }


  fetchLoginEndpoint(context,String password,String phoneNumber) async{
    setloading(true);
    var result = await apiResponse.logIn(phoneNumber, password);
    if (result['error'] == true) {
      errorCherryToast(context, result['message']);
    }
    else {
      await MySharedPreference.saveEmail(result["email"]);
      await MySharedPreference.saveToken(result["token"]);
      await MySharedPreference.saveUId(result["id"]);
      await MySharedPreference.saveFname(result["firstname"]);
      await MySharedPreference.saveLastname(result["lastname"]);
      await MySharedPreference.savePhoneNumber(result["phone"]);
      await MySharedPreference.saveProfilePicture(result["profileImageUrl"]);


      // result["deviceId"]=loginResponse.data?.user?.deviceId??"";
      // result["virtualAccountName"]=loginResponse.data?.user?.virtualAccountName??"";
      // result["virtualAccountNumber"]=loginResponse.data?.user?.virtualAccountNumber??"";
      // result["bankName"]=loginResponse.data?.user?.bankName??"";
      // result["gender"]=loginResponse.data?.user?.gender??"";
      // result["dob"]=loginResponse.data?.user?.dob??"";
      // result["userTag"]=loginResponse.data?.user?.userTag??"";
      // result["allowPushNotifications"]=loginResponse.data?.user?.allowPushNotifications??false;
      // result["allowSmsNotifications"]=loginResponse.data?.user?.allowSmsNotifications??false;
      // result["allowEmailNotifications"]=loginResponse.data?.user?.allowEmailNotifications??false;
      // result["displayWalletBalance"]=loginResponse.data?.user?.displayWalletBalance??false;
      // result["enableFaceId"]=loginResponse.data?.user?.enableFaceId??false;

      MySharedPreference.setVisitingFlag();
      Navigator.pushAndRemoveUntil(context, FadeRoute(page: DasboardScreen()),(Route<dynamic> route) => false);

    }
    setloading(false);
  }

  ApiServices service=ApiServices();
  String mytoken=MySharedPreference.getToken();
  DataResponse? dataResponse;
  fetchUserDetailApi(BuildContext context) async{
    setloadingNoNotif(true);
    var apiResponse=await service.userDetailApi(mytoken, MySharedPreference.getUId());
    if(apiResponse.error==true){
      errorCherryToast(context, apiResponse.errorMessage??"");
    }else{
      dataResponse= apiResponse.data?.data;
    }
    setloadingNoNotif(false);
    notifyListeners();
  }

}