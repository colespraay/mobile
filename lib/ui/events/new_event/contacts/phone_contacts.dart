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
          // body: Stack(
          //   children: [
          //     Positioned(
          //       left: 0.w,
          //       right: 0.w,
          //       top: 1.h,
          //       bottom: 1.h,
          //       child: ListView.builder(
          //         shrinkWrap: true,
          //         itemCount: eventProvider?.userInformationList.length,
          //         itemBuilder: (BuildContext context, int index) {
          //           // CustomContact _contact = _uiCustomContacts[index];
          //           // var _phonesList = _contact.contact.phones!.toList();
          //
          //           return Padding(
          //             padding:  EdgeInsets.only(bottom: 10.h),
          //             child: _buildListTile(eventProvider?.userInformationList[index], index),
          //           );
          //         },
          //       ),
          //     ),
          //
          //     Positioned(
          //       left: 24.w,
          //       right: 24.w,
          //       bottom: 24.h,
          //       child: CustomButton(
          //           onTap: () {
          //
          //             //selectedIndex is the list of userID
          //
          //             if(selectedIndex.isNotEmpty){
          //               selectedIndex.forEach((element) {
          //                 print("studentid=${element}");
          //               });
          //
          //               eventProvider?.fetchSendInviteApi(context, eventProvider?.eventId??"", selectedIndex, selectedName);
          //
          //
          //             }
          //
          //             // Navigator.push(context, SlideLeftRoute(page: EventConfirmationPage()));
          //
          //           },
          //           buttonText: 'Send(${selectedIndex.length})', borderRadius: 30.r,width: 380.w,
          //           buttonColor:selectedIndex.isNotEmpty? CustomColors.sPrimaryColor500: CustomColors.sDisableButtonColor),
          //     ),
          //   ],
          // ),

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
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _uiCustomContacts.length,
                      itemBuilder: (BuildContext context, int index) {
                        CustomContact _contact = _uiCustomContacts[index];
                        var _phonesList = _contact.contact.phones!.toList();

                        return _buildListTile(_contact, _phonesList);
                      },
                    ),

                    Positioned(
                      left: 24.w,
                      right: 24.w,
                      bottom: 24.h,
                      child: CustomButton(
                          onTap: () {

                            if(selectedName.isNotEmpty){
                              // print("selectedNameeee=${selectedName[0]}");
                              _phoneNumberList.forEach((element) {
                                print("phoneNumber=${element.replaceAll(" ", "").replaceAll("+234", "0").replaceAll("-", "")}");
                              });

                              // eventProvider?.fetchSendInviteApi(context, eventProvider?.eventId??"", selectedIndex, selectedName);

                              // popupDialog(context: context, title: "Invites successfully sent!", content: "You have successfully sent ${selectedName[0]} and ${selectedName.length-1} others an invite to your event!",
                              //     buttonTxt: 'Home',
                              //     onTap: () {
                              //       Navigator.pop(context);
                              //       Navigator.pop(context);
                              //       Navigator.pop(context);
                              //       Navigator.pop(context);
                              //     }, png_img: 'verified');

                            }



                            // Navigator.push(context, SlideLeftRoute(page: EventConfirmationPage()));

                          },
                          buttonText: 'Send(${selectedName.length})', borderRadius: 30.r,width: 380.w,
                          buttonColor:selectedName.isNotEmpty? CustomColors.sPrimaryColor500: CustomColors.sDisableButtonColor),
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

  ListTile _buildListTile(CustomContact contact, List<Item> phonesList) {
    return ListTile(
      leading:  CircleAvatar(
        radius: 28.r,
        backgroundColor: CustomColors.sTransparentPurplecolor,
        child:  Center(child: Text(getInitials(contact.contact.displayName??""), style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400))),
      ),

      title: Text(contact.contact.displayName??"", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp,
          fontWeight: FontWeight.w400, color: CustomColors.sWhiteColor),),

      trailing: Checkbox(
          activeColor: CustomColors.sPrimaryColor500,
          value: selectedIndex.contains(contact.contact.displayName??""/*userInformationList?.id??""*/),
          onChanged: (bool? value) {
            setState(() {
              if (selectedIndex.contains(contact.contact.displayName??""/*userInformationList?.id??""*/)) {
                selectedIndex.remove(contact.contact.displayName??""/*userInformationList?.id??""*/); //
                selectedName.remove(contact.contact.displayName??""/*userInformationList?.firstName??""*/);
                _phoneNumberList.remove(contact.contact.phones?[0].value??"");
              } else {
                selectedIndex.add(contact.contact.displayName??""/*userInformationList?.id??""*/);
                selectedName.add(contact.contact.displayName??""/*userInformationList?.firstName??""*/);
                _phoneNumberList.add(contact.contact.phones?[0].value??"");

              }
            });

          }),
    );
  }

  //permissions
  Future<void> _askPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      refreshContacts();
      // if (routeName != null) {
      //   Navigator.of(context).pushNamed(routeName);
      // }
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
    _isLoading = false;
  });
}

}
