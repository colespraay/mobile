import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/ui/events/new_event/contacts/custome_contact.dart';

class PhoneContacts extends StatefulWidget {
  const PhoneContacts({Key? key}) : super(key: key);

  @override
  State<PhoneContacts> createState() => _PhoneContactsState();
}

class _PhoneContactsState extends State<PhoneContacts> {

  List<Contact> _contacts = [];
  List<CustomContact> _uiCustomContacts = [];
  List<CustomContact> _allContacts = [];
  bool _isLoading = false;
  bool _isSelectedContactsView = false;

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

  @override
  void initState() {
    super.initState();
    _askPermissions();
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(context: context, title: "Share Event"),
        body: Builder(
          builder: (context) {
            if(_isLoading==true){
              return Center(child: SpinKitFadingCircle(size: 50.r,color:CustomColors.sPrimaryColor500));
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

                          if(_myselectedContacts.isNotEmpty){
                            _myselectedContacts.forEach((element) {
                              print("phoneNumber=${element.contact.phones?[0].value}");
                            });


                            popupDialog(context: context, title: "Invites successfully sent!", content: "You have successfully sent Adam Smith and ${_myselectedContacts.length} others an invite to your event!",
                                buttonTxt: 'Home',
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }, png_img: 'verified');

                          }



                          // Navigator.push(context, SlideLeftRoute(page: EventConfirmationPage()));

                        },
                        buttonText: 'Send(${_myselectedContacts.length})', borderRadius: 30.r,width: 380.w,
                        buttonColor:_myselectedContacts.isNotEmpty? CustomColors.sPrimaryColor500: CustomColors.sDisableButtonColor),
                  ),
                ],
              );
            }
          }
        ),

        // floatingActionButton: new FloatingActionButton.extended(
        //   backgroundColor: Colors.red,
        //   onPressed: _onSubmit,
        //   icon: Icon(Icons.add),
        //   label: Text("pick"),
        // ),
      ),
    );
  }

  ListTile _buildListTile(CustomContact c, List<Item> list) {
    return ListTile(
      leading: /*(c.contact.avatar != null) ? CircleAvatar(backgroundImage: MemoryImage(c.contact.avatar!))
          :*/ CircleAvatar(
        backgroundColor: CustomColors.sDarkColor3,
        child: Text(getInitials(c.contact.displayName??""),
            style:  CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400, color: CustomColors.sWhiteColor)),),

      title: Text(c.contact.displayName ?? "", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400, color: CustomColors.sWhiteColor),),

      // subtitle: list.length >= 1 && list[0].value != null ? Text(list[0].value??"") : Text(''),

      trailing: Checkbox(
          activeColor: CustomColors.sPrimaryColor500,
          value: c.isChecked,
          onChanged: (bool? value) {
            setState(() {c.isChecked = value!;});

            setState(() {
              // if(c.isChecked==true){
                _myselectedContacts=_allContacts.where((contact) => contact.isChecked == true).toList();
              // }

            });


          }),
    );
  }
  void _onSubmit() {
    setState(() {
      if (!_isSelectedContactsView) {
        _uiCustomContacts = _allContacts.where((contact) => contact.isChecked == true).toList();
        _isSelectedContactsView = true;

      } else {
        _uiCustomContacts = _allContacts;
        _isSelectedContactsView = false;
      }
    });
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
      final snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      final snackBar =
      SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
