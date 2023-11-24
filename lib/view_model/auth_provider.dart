import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
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
import 'package:spraay/ui/profile/reset_trans_pin/change_transaction_pin.dart';
import 'package:spraay/utils/my_sharedpref.dart';
import 'package:spraay/utils/secure_storage.dart';

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

  //Inactivity Session timeout
  final sessionStateStream = StreamController<SessionState>();

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


  changePasswordEndpoint(context,String token,String currentPassword, String newPassword) async{
    setloading(true);
    var result = await apiResponse.changePassword(token, currentPassword, newPassword);
    if (result['error'] == true) {
      errorCherryToast(context, result['message']);
    }
    else {
      popupDialog(context: context, title: "Password Changed", content: "You have successfully changed your password.",
          buttonTxt: 'Great!',
          onTap: () {
            Navigator.pop(context);
            Navigator.pop(context);

          }, png_img: 'verified');
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

      Navigator.pushAndRemoveUntil(context, FadeRoute(page: LoginScreen()),(Route<dynamic> route) => false);

      // MySharedPreference.setVisitingFlag();
      // Navigator.pushAndRemoveUntil(context, FadeRoute(page: DasboardScreen()),(Route<dynamic> route) => false);
    }
    setloading(false);
  }

  changeTransactionPinEndpoint(context,String transactionPin, String userId) async{
    setloading(true);
    var result = await apiResponse.createTransactionPin(transactionPin, userId);
    if (result['error'] == true) {
      errorCherryToast(context, result['message']);
    }
    else {
      popupDialog(context: context, title: "PIN changed successfully", content: "You have successfully changed your transaction PIN.",
          buttonTxt: 'Great!',
          onTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          }, png_img: 'verified');

      // MySharedPreference.setVisitingFlag();
      // Navigator.pushAndRemoveUntil(context, FadeRoute(page: DasboardScreen()),(Route<dynamic> route) => false);
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


  verifyBvnCodeEndpoint(context,String userId, String bvn) async{
    setloading(true);
    var result = await apiResponse.verifyBvnCode(userId, bvn, MySharedPreference.getToken());
    if (result['error'] == true) {
      errorCherryToast(context, result['message']);
    }
    else {
      await SecureStorage().saveVn(bvn);

      popupDialog(context: context, title: "Identity Verified", content: "Yaay!!! You can now enjoy all the features of Spray App!",
          buttonTxt: 'Let’s get started',
          onTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
          }, png_img: 'verified');
    }
    setloading(false);
  }


  fetchLoginEndpoint( context,String password,String phoneNumber) async{
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

      // await MySharedPreference.savePass(password);
      await SecureStorage().savePassword(password);

      await MySharedPreference.saveVAccName(result["virtualAccountName"].toString());
      await MySharedPreference.saveVAccNumber(result["virtualAccountNumber"].toString());
      await MySharedPreference.saveVBankName(result["bankName"].toString());


      await SecureStorage().saveVn(result["bvn"]);
      // await MySharedPreference.saveCheckBvn(result["bvn"].toString());
      await MySharedPreference.saveWalletBalance(result["walletBalance"].toString());

      MySharedPreference.setVisitingFlag();

      // start listening to session only after user logs in
      sessionStateStream.add(SessionState.startListening);


      Navigator.pushAndRemoveUntil(context, FadeRoute(page: DasboardScreen()),(Route<dynamic> route) => false);

    }
    setloading(false);
  }

  fetchConfLoginEndpoint(context,String password,String phoneNumber) async{
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
      await MySharedPreference.saveVAccName(result["virtualAccountName"].toString());
      await MySharedPreference.saveVAccNumber(result["virtualAccountNumber"].toString());
      await MySharedPreference.saveVBankName(result["bankName"].toString());


      Navigator.push(context, FadeRoute(page: ChangeTransactionPin()));

      // MySharedPreference.setVisitingFlag();
      // Navigator.pushAndRemoveUntil(context, FadeRoute(page: DasboardScreen()),(Route<dynamic> route) => false);

    }
    setloading(false);
  }


  ApiServices service=ApiServices();
  String mytoken=MySharedPreference.getToken();
  DataResponse? dataResponse;
  fetchUserDetailApi() async{
    setloadingNoNotif(true);
    var apiResponse=await service.userDetailApi(mytoken, MySharedPreference.getUId());
    if(apiResponse.error==true){
      log("UserDetailApi:${apiResponse.errorMessage}");
      // errorCherryToast(context, apiResponse.errorMessage??"");
    }else{
      dataResponse= apiResponse.data?.data;
      await MySharedPreference.saveWalletBalance(apiResponse.data?.data?.walletBalance.toString()??"");
      if(dataResponse?.bvn !=null){
        await SecureStorage().saveVn(dataResponse?.bvn);
      }
    }
    setloadingNoNotif(false);
    notifyListeners();
  }

  updateProfileEndpoint(context,String email, String userId, String firstName, String lastName, String gender) async{
    setloading(true);
    var result = await apiResponse.updateProfile(email, userId, firstName, lastName, gender);
    if (result['error'] == true) {
      errorCherryToast(context, result['message']);
    }
    else {
      popupDialog(context: context, title: "Profile updated",
          content: "You have successfully update your profile",
          buttonTxt: "Great!", onTap: (){
            fetchUserDetailApi();
            Navigator.pop(context);
            Navigator.pop(context);


          }, png_img: "verified");
    }
    setloading(false);
  }


  fetchuploadImageUrl(context,String profileImageUrl, String userId) async{
    setloading(true);
    var result = await apiResponse.uploadImageUrl(profileImageUrl, userId);
    if (result['error'] == true) {
      errorCherryToast(context, result['message']);
    }
    else {
      fetchUserDetailApi();
    }
    setloading(false);
  }

  fetchUploadFile(context,File image, String filename) async{
    setloading(true);
    var result = await apiResponse.uploadFile(image, filename);
    if (result['error'] == true) {
      errorCherryToast(context, result['message']);
    }
    else {
      fetchuploadImageUrl(context, result['file_url'], MySharedPreference.getUId());
    }
    setloading(false);
  }



}