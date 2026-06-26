import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/modal_buttom.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/components/wallet_card.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/home/event_slidder.dart';
import 'package:spraay/ui/home/mini_transaction_history.dart';
import 'package:spraay/ui/home/notification_screen.dart';
import 'package:spraay/ui/home/transaction_history.dart';
import 'package:spraay/ui/profile/user_profile/edit_profile.dart';
import 'package:spraay/utils/secure_storage.dart';
import 'package:spraay/view_model/auth_provider.dart';
import 'package:spraay/view_model/event_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).fetchUserDetailApi();
    Provider.of<EventProvider>(context, listen: false).fetchTransactionListApi();
    Provider.of<EventProvider>(context, listen: false).fetchNotificationApi();

    SecureStorage().getVn().then((value) {
      if (value.isEmpty) {
        //showd bvn modal
        verifyYourIdentityBModal(context: context);
      }
    });
  }

  AuthProvider? credentialsProvider;

  EventProvider? eventProvider;
  @override
  void didChangeDependencies() {
    credentialsProvider = context.watch<AuthProvider>();
    eventProvider = context.watch<EventProvider>();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarSize(),
        body: Padding(
          padding: horizontalPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // shrinkWrap: true,
            children: [
              buildTopRow(),
              height20,
              const WalletCard(),
              height26,
              // GestureDetector(
              //     onTap: () {
              //       Navigator.push(context, SlideLeftRoute(page: const PhoneContacts()));
              //     },
              //     child: const Icon(
              //       Icons.add,
              //       color: Colors.white,
              //     )),
              GestureDetector(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const PhoneContacts()));
                  },
                  child: Text("Events for you", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700))),
              height10,
              const EventSlidder(),
              height26,
              Expanded(child: buildTransactionList())
            ],
          ),
        ));
  }

  Widget buildTopRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
            onTap: () {
              Navigator.push(context, FadeRoute(page: EditProfile(credentialsProvider?.dataResponse)));
            },
            child: buildCircularNetworkImage(imageUrl: credentialsProvider?.dataResponse?.profileImageUrl ?? "", radius: 26.r)),
        SizedBox(
          width: 12.w,
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Hello", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400)),
              Text(" ${credentialsProvider?.dataResponse?.firstName ?? ""}", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        InkWell(
            onTap: () {
              showNotification(context);
            },
            child: SvgPicture.asset("images/note_bell.svg"))
      ],
    );
  }

  Widget buildTransactionList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Transactions", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700)),
            GestureDetector(
                onTap: () {
                  seeAllTransaction(context);
                },
                child: Text("See all", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400))),
          ],
        ),
        height16,
        Expanded(
            child: eventProvider?.transactionList == null
                ? const ShimmerList()
                : MiniTransactionHistory(
                    assetsList: eventProvider?.transactionList,
                  ))
      ],
    );
  }

  void showNotification(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: const Color(0xff1A1A21),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(25.r), topLeft: Radius.circular(25.r)),
        ),
        context: context,
        builder: (context) {
          return NotificationScreen(
            notificationlist: eventProvider?.notificationlist ?? [],
          );
        });
  }

  void seeAllTransaction(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: const Color(0xff1A1A21),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(25.r), topLeft: Radius.circular(25.r)),
        ),
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
              return DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 0.92,
                  minChildSize: 0.92,
                  maxChildSize: 0.92,
                  builder: (BuildContext context, ScrollController scrollController) {
                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                        width: double.infinity,
                        height: 30.h,
                        decoration: BoxDecoration(color: CustomColors.sDarkColor2, borderRadius: BorderRadius.only(topLeft: Radius.circular(25.r), topRight: Radius.circular(25.r))),
                        child: Center(child: SvgPicture.asset("images/indicate.svg")),
                      ),
                      height12,
                      Expanded(
                        child: Padding(
                          padding: horizontalPadding,
                          child: TransactionHistory(transactionList: eventProvider?.transactionList),
                        ),
                      ),
                    ]);
                  });
            }),
          );
        });
  }
}
