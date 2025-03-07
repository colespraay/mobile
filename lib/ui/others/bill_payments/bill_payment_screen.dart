import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/image_title_models.dart';
import 'package:spraay/ui/others/bill_payments/betting_screen/betting_screens.dart';
import 'package:spraay/ui/others/bill_payments/cable_sub/cable_subscription.dart';
import 'package:spraay/ui/others/bill_payments/data/data_top_up.dart';
import 'package:spraay/view_model/bill_payment_provider.dart';

import '../../../navigations/scale_transition.dart';
import 'bill_payment_detail.dart';

class BillPaymentScreen extends StatefulWidget {
  const BillPaymentScreen({Key? key}) : super(key: key);

  @override
  State<BillPaymentScreen> createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends State<BillPaymentScreen> {

  @override
  void initState() {
    super.initState();
    Provider.of<BillPaymentProvider>(context,listen: false).fetchAirtimeTopUpList();
    Provider.of<BillPaymentProvider>(context,listen: false).fetchCableTvListList();
    Provider.of<BillPaymentProvider>(context,listen: false).fetchEletricityProvidersApiList();
    Provider.of<BillPaymentProvider>(context,listen: false).fetchGameProvidersApiList();
  }

  @override
  Widget build(BuildContext context) {
    final loader= context.watch<BillPaymentProvider>();
    return  LoadingOverlayWidget(
      loading: loader.loading,
      child: Scaffold(
          appBar: buildAppBar(context: context, title:"Pay Bills"),
          body: buildInviWidget()),
    );
  }

  Widget buildInviWidget(){
    return Padding(
      padding: horizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          height80,
          buildHorizontalTicket(),

          height34,

        ],
      ),
    );
  }

  List<ImageTitleModel> cableList=[
    ImageTitleModel(image: "airtime_topup", title: "Airtime Top-up"),
    // ImageTitleModel(image: "airtime_topup", title: "Data Top-up"),
    ImageTitleModel(image: "electricity", title: "Electricity"),
    ImageTitleModel(image: "Internet", title: "Internet"),
    ImageTitleModel(image: "tv", title: "Television"),
    ImageTitleModel(image: "game", title: "BET"),
  ];
  //
  Widget buildHorizontalTicket(){
    return   Center(
      child: Wrap(
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: cableList.asMap().entries.map((e) => GestureDetector(
          onTap:(){
            int position = e.key;//position

            if(e.value.title=="Airtime Top-up"){
              Navigator.push(context, ScaleTransition1(page: PayBilDetail(title:e.value.title,)));
            }
            else if(e.value.title=="Internet"){
              Navigator.push(context, ScaleTransition1(page: DataTopUp(title:"Data Top-up",)));
            }
            else if(e.value.title=="Television"){
              Navigator.push(context, ScaleTransition1(page: CableSubscriptionscreen(title:e.value.title,)));
            }

            else if(e.value.title=="Electricity"){
              Navigator.push(context, ScaleTransition1(page: PayBilDetail(title:e.value.title,)));
            }

            else{
              Navigator.push(context, ScaleTransition1(page: BettingScreen(title:e.value.title,)));
            }

          },
          child: Container(
            width: 105.w,
            // height: 200.h,
            margin: EdgeInsets.only(right: 14.w, bottom: 40.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset("images/${e.value.image}.svg", width: 80.w, height: 80.h,),
                height12,
                Text(e.value.title, style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 14.sp, color: CustomColors.sWhiteColor)),
              ],
            ),
          ),
        ) ).toList(),
      ),
    );
  }


}
