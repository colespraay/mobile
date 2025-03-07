import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/ui/events/new_event/contacts/phone_contacts.dart';
import 'package:spraay/ui/events/new_event/view_event.dart';
import 'package:spraay/view_model/event_provider.dart';

class EventConfirmationPage extends StatefulWidget {
  const EventConfirmationPage({Key? key}) : super(key: key);

  @override
  State<EventConfirmationPage> createState() => _EventConfirmationPageState();
}

class _EventConfirmationPageState extends State<EventConfirmationPage> {

  TextEditingController phoneController=TextEditingController();

  EventProvider? eventProvider;
  @override
  void didChangeDependencies() {
    eventProvider=context.watch<EventProvider>();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarSize(),
        body:  Padding(
          padding: horizontalPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text("Confirmation", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 24.sp, fontWeight: FontWeight.w700) )),
              height26,
              Center(child: Text("Event Registration Success!", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700) )),
              height12,
              Center(child: Text("Here is your invitation code to your event. Share this code with your guests to receive sprays.",
                  style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor50) )),
              height22,
              Center(
                child: QrImageView(
                  data:eventProvider?.eventCode??"",
                  backgroundColor: CustomColors.sWhiteColor,
                  version: QrVersions.auto,
                  size: 220.r,
                  gapless: true,
                  errorCorrectionLevel: QrErrorCorrectLevel.H,
                  embeddedImage: const AssetImage('images/s_biglogo.png'),
                  embeddedImageStyle: QrEmbeddedImageStyle(size: Size(70.w, 70.h),),
                ),
              ),

              // QrImageView(
              //   data: codeLink,//codeLink
              //   version: QrVersions.auto,
              //   size: 170.r,
              // ),


              height26,
              buildCode(),

              height26,
              CustomButton(
                  onTap: () {
                    Navigator.push(context, SlideLeftRoute(page: const PhoneContacts()));

                  },
                  buttonText: "Invite friends", borderRadius: 30.r,width: 380.w,
                  buttonColor:  CustomColors.sPrimaryColor500),
              height16,
              CustomButton(
                  onTap: () {
                    Navigator.push(context, SlideLeftRoute(page: const ViewEvent()));
                  },
                  buttonText: 'View Event', borderRadius: 30.r,width: 380.w,
                  buttonColor: CustomColors.sDarkColor3),


            ],
          ),
        ));

  }

  Widget buildCode(){
    return Container(
      width: 380.w,
      height: 58.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
          color: CustomColors.sDarkColor2,
          borderRadius: BorderRadius.circular(12.r)),
      child: Material(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(eventProvider?.eventCode??"", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500),),
            GestureDetector(
              onTap:(){

                Clipboard.setData( ClipboardData(text: eventProvider?.eventCode??"")).then((_) {
                  toastMessage("copied!");
                });

              },
                child: SvgPicture.asset("images/copy.svg"))
          ],
        ),

      ),

    );

  }
}
