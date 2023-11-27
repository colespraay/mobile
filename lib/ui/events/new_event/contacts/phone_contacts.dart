import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/registered_user_model.dart';
import 'package:spraay/models/user_name_with_phone_contact_model.dart';
import 'package:spraay/ui/events/new_event/contacts/custom_class.dart';
import 'package:spraay/view_model/event_provider.dart';

class PhoneContacts extends StatefulWidget {
  const PhoneContacts({Key? key}) : super(key: key);

  @override
  State<PhoneContacts> createState() => _PhoneContactsState();
}

class _PhoneContactsState extends State<PhoneContacts> {

  EventProvider? eventProvider;
  @override
  void didChangeDependencies() {
    eventProvider=context.watch<EventProvider>();
    super.didChangeDependencies();
  }
  @override
  void initState() {
    super.initState();
    // Provider.of<EventProvider>(context, listen: false).fetchUserDetailApi(context);
    _askPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayWidget(
      loading: eventProvider?.loading??false,
      child: SafeArea(
        child: Scaffold(
          appBar: buildAppBar(context: context, title: "Share Event"),
          body: Builder(
            builder: (context) {
              if(_isLoading==true){
                return Center(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitFadingCircle(size: 50.r,color:CustomColors.sPrimaryColor500),
                    height4,
                    Text("Loading...", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp,
                        fontWeight: FontWeight.w400, color: CustomColors.sWhiteColor),),
                  ],
                ));
              }

             else{
                return Stack(
                  children: [

                    Positioned(
                      left: 0.w,
                      right: 0.w,
                      top: 1.h,
                      bottom: 1.h,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: eventProvider?.userPhoneContactData.length,
                        itemBuilder: (BuildContext context, int index) {

                          return Padding(
                            padding:  EdgeInsets.only(bottom: 10.h),
                            child: _buildListTile(eventProvider?.userPhoneContactData[index], index),
                          );
                        },
                      ),
                    ),

                    Positioned(
                      left: 24.w,
                      right: 24.w,
                      bottom: 24.h,
                      child: CustomButton(
                          onTap: () {

                            if(selectedIndex.isNotEmpty){

                              eventProvider?.fetchSendInviteApi(context, eventProvider?.eventId??"", selectedIndex, selectedName);

                            }

                          },
                          buttonText: 'Send(${selectedIndex.length})', borderRadius: 30.r,width: 380.w,
                          buttonColor:selectedIndex.isNotEmpty? CustomColors.sPrimaryColor500: CustomColors.sDisableButtonColor),
                    ),

                  ],
                );
              }
            }
          ),

        ),
      ),
    );
  }




  List<String> selectedIndex = [];
  List<String> selectedName = [];

  ListTile _buildListTile(UserPhoneWithNameContactDatum? userInformationList, int position) {
    return ListTile(
      leading:  CircleAvatar(
        radius: 28.r,
        child: CachedNetworkImage(
          width: 28.w,
          height: 28.h,
          imageUrl:userInformationList?.profileImageUrl??"",
          placeholder: (context, url) => Center(child: SpinKitFadingCircle(size: 30,color: Colors.grey,)),
          errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
        ),
      ),

      title: Text("${userInformationList?.firstName??""} ${userInformationList?.lastName??""}", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp,
          fontWeight: FontWeight.w400, color: CustomColors.sWhiteColor),),

      trailing: Checkbox(
          activeColor: CustomColors.sPrimaryColor500,
          value: selectedIndex.contains(userInformationList?.id??""),
          onChanged: (bool? value) {
            setState(() {
              if (selectedIndex.contains(userInformationList?.id??"")) {
                selectedIndex.remove(userInformationList?.id??""); //
                selectedName.remove(userInformationList?.firstName??"");
              } else {
                selectedIndex.add(userInformationList?.id??"");
                selectedName.add(userInformationList?.firstName??"");

              }
            });

          }),
    );
  }

  Future<void> _askPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      refreshContacts();
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted && permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      const snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      const snackBar = SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

List<Contact> _contacts = [];
List<CustomContact> _uiCustomContacts = [];
List<CustomContact> _allContacts = [];
bool _isLoading = false;
bool _isSelectedContactsView = false;
List<String> _phoneNumberList=[];
List<CustomContact> _myselectedContacts = [];

// List<UserPhoneWithNameContact> userPhoneWithNameContacts=[];
List<Map<String, String?>> userPhoneWithNameContacts=[];


refreshContacts() async {
  setState(() {_isLoading = true;});
  var contacts = await ContactsService.getContacts();
  _populateContacts(contacts);
}

void _populateContacts(Iterable<Contact> contacts) {
  _contacts = contacts.where((item) => item.displayName != null).toList();
  _contacts.sort((a, b) => a.displayName!.compareTo(b.displayName??""));
  _allContacts = _contacts.map((contact) => CustomContact(contact: contact)).toList();
  setState(() {
    _uiCustomContacts = _allContacts;

    userPhoneWithNameContacts= _allContacts.map((contact) => {
      'name': contact.contact.displayName?.replaceAll(" ", "").replaceAll("+234", "0").replaceAll("-", "")??"",
      'phoneNumber': contact.contact.phones!.isEmpty?"": contact.contact.phones?[0].value?.replaceAll(" ", "").replaceAll("+234", "0").replaceAll("-", "")??"",}).toList();
    _isLoading = false;
  });

  Provider.of<EventProvider>(context, listen: false).fetchUserContactApi(userPhoneWithNameContacts);
}

}
