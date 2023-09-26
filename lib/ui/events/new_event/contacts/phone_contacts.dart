import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/registered_user_model.dart';
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
    Provider.of<EventProvider>(context, listen: false).fetchUserDetailApi(context);
    // _askPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayWidget(
      loading: eventProvider?.loading??false,
      child: SafeArea(
        child: Scaffold(
          appBar: buildAppBar(context: context, title: "Share Event"),
          body: Stack(
            children: [
              Positioned(
                left: 0.w,
                right: 0.w,
                top: 1.h,
                bottom: 1.h,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: eventProvider?.userInformationList.length,
                  itemBuilder: (BuildContext context, int index) {
                    // CustomContact _contact = _uiCustomContacts[index];
                    // var _phonesList = _contact.contact.phones!.toList();

                    return Padding(
                      padding:  EdgeInsets.only(bottom: 10.h),
                      child: _buildListTile(eventProvider?.userInformationList[index], index),
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

                      //selectedIndex is the list of userID

                      if(selectedIndex.isNotEmpty){
                        selectedIndex.forEach((element) {
                          print("studentid=${element}");
                        });

                        eventProvider?.fetchSendInviteApi(context, eventProvider?.eventId??"", selectedIndex, selectedName);


                      }



                      // Navigator.push(context, SlideLeftRoute(page: EventConfirmationPage()));

                    },
                    buttonText: 'Send(${selectedIndex.length})', borderRadius: 30.r,width: 380.w,
                    buttonColor:selectedIndex.isNotEmpty? CustomColors.sPrimaryColor500: CustomColors.sDisableButtonColor),
              ),
            ],
          ),


        ),
      ),
    );
  }

  List<String> selectedIndex = [];
  List<String> selectedName = [];

  ListTile _buildListTile(RegisteredDatum? userInformationList, int position) {
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

}
