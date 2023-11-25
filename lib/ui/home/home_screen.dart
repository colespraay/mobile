import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/fancy_fab.dart';
import 'package:spraay/components/modal_buttom.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/events/new_event/contacts/phone_contacts.dart';
import 'package:spraay/ui/home/event_slidder.dart';
import 'package:spraay/ui/home/fund_wallet.dart';
import 'package:spraay/ui/home/mini_transaction_history.dart';
import 'package:spraay/ui/home/notification_screen.dart';
import 'package:spraay/ui/home/transaction_history.dart';
import 'package:spraay/ui/profile/user_profile/edit_profile.dart';
import 'package:spraay/utils/my_sharedpref.dart';
import 'package:spraay/utils/secure_storage.dart';
import 'package:spraay/view_model/auth_provider.dart';
import 'package:spraay/view_model/event_provider.dart';
import 'package:spraay/view_model/home_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool _isObscure=false;

  @override
  void initState() {
    super.initState();
    _isObscure=Provider.of<HomeProvider>(context, listen: false).hideWalletvalue??false;
    Provider.of<AuthProvider>(context, listen: false).fetchUserDetailApi();
    Provider.of<EventProvider>(context, listen: false).fetchTransactionListApi();
    Provider.of<EventProvider>(context, listen: false).fetchNotificationApi();

    SecureStorage().getVn().then((value){
      if(value.isEmpty){
        //showd bvn modal
        verifyYourIdentityBModal(context: context);
      }
    });
  }

  AuthProvider? credentialsProvider;

  EventProvider? eventProvider;
  @override
  void didChangeDependencies() {
    credentialsProvider=context.watch<AuthProvider>();
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
            // shrinkWrap: true,
            children: [
              buildTopRow(),
              height20,
              buildWalletContainer(),
              height26,
              Text("Events for you", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700) ),
              height10,
              const EventSlidder(),
              height26,
              Expanded(child: buildTransactionList())

            ],
          ),
        ));
  }

  Widget buildTopRow(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap:(){
            Navigator.push(context,FadeRoute(page: EditProfile(credentialsProvider?.dataResponse)));
          },
            child: buildCircularNetworkImage(imageUrl: credentialsProvider?.dataResponse?.profileImageUrl??"", radius: 26.r)),
        SizedBox(width: 12.w,),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Hello", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400) ),
              Text(" ${credentialsProvider?.dataResponse?.firstName??""}", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w500) ),
            ],
          ),
        ),

        InkWell(
          onTap: (){
            showNotification(context);
          },
            child: SvgPicture.asset("images/note_bell.svg"))

      ],
    );
  }


  Widget buildWalletContainer(){
    // pattern.png
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(40.r)),
      child: Container(
        width: double.infinity,
        height: 200.h,
        padding: EdgeInsets.only(left: 18.w, right: 56.w),
        margin: EdgeInsets.zero,
        decoration: const BoxDecoration(
          color: CustomColors.sPrimaryColor500,
          image: DecorationImage(
            image: AssetImage('images/pattern_endd.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: SizedBox(
            // width: 275.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Wallet Balance", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 10.sp, fontWeight: FontWeight.w700) ),
                height16,
                // Text("N200,000.00", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 32.sp, fontWeight: FontWeight.w700) ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(_isObscure?'${MySharedPreference.getWalletBalance().replaceAll(RegExp(r"."), "*")}':
                      "₦${currrency.format(double.parse(MySharedPreference.getWalletBalance()))}" ,
                        style: CustomTextStyle.kTxtBold.copyWith(fontSize: 24.sp, fontWeight: FontWeight.bold, fontFamily: "PlusJakartaSans"),maxLines: 2, overflow: TextOverflow.ellipsis,),
                    ),
                    GestureDetector(
                        onTap: (){
                          setState(() {_isObscure = !_isObscure;});
                        },
                        child:  Icon(_isObscure ? Icons.visibility_off_outlined: Icons.visibility_outlined, color: CustomColors.sWhiteColor,)),

                  ],
                ),

                height18,
                GestureDetector(
                  onTap:(){
                    Navigator.push(context, FadeRoute(page: FundWallet()));
                  },
                  child: Align(
                    alignment: Alignment.bottomRight,
                      child: SvgPicture.asset("images/top_up.svg")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget buildTransactionList(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Transactions", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700)),

            GestureDetector(
              onTap:(){
                seeAllTransaction(context);
              },
                child: Text("See all", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400) )),

          ],
        ),
        height16,

        Expanded(child: eventProvider?.transactionList==null? ShimmerList(): MiniTransactionHistory(transactionList:eventProvider?.transactionList,))
      ],
    );
  }

  void showNotification(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Color(0xff1A1A21),
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.only(topRight: Radius.circular(25.r), topLeft: Radius.circular(25.r)),),
        context: context,
        builder: (context) {
          return NotificationScreen(notificationlist:eventProvider?.notificationlist??[],);
        });
  }

  void seeAllTransaction(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Color(0xff1A1A21),
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.only(topRight: Radius.circular(25.r), topLeft: Radius.circular(25.r)),),
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 0.92,
                      minChildSize: 0.92,
                      maxChildSize: 0.92,
                      builder: (BuildContext context, ScrollController scrollController) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(width: double.infinity, height: 30.h, decoration: BoxDecoration(color: CustomColors.sDarkColor2,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(25.r), topRight: Radius.circular(25.r))),
                                child: Center(child: SvgPicture.asset("images/indicate.svg")),),

                              height12,
                              Expanded(
                                child: Padding(
                                  padding: horizontalPadding,
                                  child: TransactionHistory(transactionList:eventProvider?.transactionList),
                                ),
                              ),

                            ]);
                      });
                }),
          );
        });
  }


}
