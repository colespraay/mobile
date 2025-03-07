import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/ui/home/mini_transaction_history.dart';
import 'package:spraay/ui/home/transaction_detail.dart';
import 'package:spraay/ui/home/transaction_history.dart';
import 'package:spraay/ui/wallet/bar_graph/bar_graph.dart';
import 'package:spraay/utils/my_sharedpref.dart';
import 'package:spraay/view_model/event_provider.dart';

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {

  EventProvider? eventProvider;


  dynamic _total,_income,_expense;

  bool _isloading=false;
  filterHistory(String filter) async{
    setState(() {_isloading=true;});
    var result = await apiResponse.historySummaryFilter(MySharedPreference.getToken(), filter);
    if (result['error'] == true) {
      log("ChatView screen: ${result['message']}");
    }
    else {
      setState(() {
        _total= result["total"];
        _income= result["income"];
        _expense= result["expense"];
      });

    }

    setState(() {_isloading=false;});
  }

  @override
  void didChangeDependencies() {
    eventProvider=context.watch<EventProvider>();
    super.didChangeDependencies();
  }


  @override
  void initState() {
    filterHistory("LAST_6_MONTHS");

    Provider.of<EventProvider>(context, listen: false).fetchGraphHistoryApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SprayBarGraph(eventProvider),
        height30,
        buildContainer(),
        height20,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: buildRowContainer(title: 'Income', content: _isloading?"...": '₦${_income??0}', color: CustomColors.sSuccessColor)),
            SizedBox(width: 25.w,),
            Expanded(child: buildRowContainer(title: 'Expense', content:  _isloading?"...": '₦${_expense??0}', color: CustomColors.sErrorColor))

          ],
        ),
        height34,
        Text("Transactions", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700)),
        height18,
        buildTransactionList(),


      ],
    );
  }


  Widget buildContainer(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(color: CustomColors.sDarkColor2, borderRadius: BorderRadius.all(Radius.circular(16.r))
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 180.w,
              child: Text( _isloading?"...": "₦${_total??0}", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 30.sp, fontWeight: FontWeight.w700, fontFamily: "PlusJakartaSans"))),

          SizedBox(width: 8.w,),
          Expanded(child: buildGender())

        ],
      ),
    );
  }

  Widget buildRowContainer({required String title,required String content,required Color color}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(color: CustomColors.sDarkColor2, borderRadius: BorderRadius.all(Radius.circular(16.r))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: CustomTextStyle.kTxtBold.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w700, color: color)),
          height4,
          Text(content, style: CustomTextStyle.kTxtBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700, fontFamily: "PlusJakartaSans")),

        ],
      ),
    );
  }


  List<String> monthlist=["Last 6 Months", "Last 3 Months", "Last 30 Days","Last 7 Days"];
  Widget buildGender(){
    return DropdownButtonFormField<String>(
      iconEnabledColor: CustomColors.sDisableButtonColor,
      isDense: false,
      dropdownColor: CustomColors.sDarkColor3,
      items: monthlist.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: CustomTextStyle.kTxtSemiBold.copyWith(color: CustomColors.sGreyScaleColor100,
              fontSize: 14.sp, fontWeight: FontWeight.w500), ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        // thirdVal=newValue??"";
        filterHistory(newValue!.replaceAll(" ", "_").toUpperCase());
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
        hintText: "Filter",
        isDense: true,
        filled: true,
        prefixIconConstraints:  BoxConstraints(minWidth: 19, minHeight: 19,),
        prefixIcon:Padding(
          padding:  EdgeInsets.only(right: 8.w, left: 10.w),
          child: SizedBox.shrink(),
        ),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0.1),borderRadius: BorderRadius.circular(8.r),),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0.5),borderRadius: BorderRadius.circular(8.r),),
        hintStyle: CustomTextStyle.kTxtRegular.copyWith(color: CustomColors.sGreyScaleColor100, fontSize: 14.sp, fontWeight: FontWeight.w400),

        fillColor:CustomColors.sDarkColor3,
        errorBorder:  OutlineInputBorder(borderSide:  BorderSide(color:Colors.transparent, width: 0.1.w), borderRadius: BorderRadius.circular(8.r),),
        focusedErrorBorder: OutlineInputBorder(borderSide:  BorderSide(color:Colors.transparent, width: 0.1.w), borderRadius: BorderRadius.circular(8.r),),
      ),
    );
  }

  Widget buildTransactionList(){
    if(eventProvider!.transactionList!.isEmpty)
    {
      return Center(child:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("No Transactions has been made.", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor50),),
          height4,
          Text("Make one!", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: CustomColors.sPrimaryColor500),),
        ],
      ),);
    }else{
      // return MiniTransactionHistory(transactionList:eventProvider?.transactionList,);


    return ListView.builder(
        shrinkWrap: true,
        itemCount: eventProvider!.transactionList!.length <5? eventProvider!.transactionList!.length: 5,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder:(context, int position){
          return InkWell(
            onTap: (){
              Navigator.push(context, FadeRoute(page: TransactionDetail(eventProvider?.transactionList?[position])));

            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(color: CustomColors.sDarkColor3, shape: BoxShape.circle,
                          image: DecorationImage(image: AssetImage("images/cash_png.png"), fit: BoxFit.fill,)
                      ),
                    ),

                    SizedBox(width: 10.w,),

                    Expanded(
                      child: SizedBox(
                        width: 175.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(eventProvider?.transactionList?[position].narration??"", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400,fontFamily: "LightPlusJakartaSans"),),
                            height4,
                            Text("${DateFormat.MMMd().format(eventProvider!.transactionList![position].dateCreated!)}, ${DateFormat.jm().format(eventProvider!.transactionList![position].dateCreated!)}",
                              style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor500),textAlign: TextAlign.center,),
                          ],
                        ),
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("${eventProvider?.transactionList?[position].type=="Debit"?"-":"+"} ₦${eventProvider?.transactionList?[position].amount??0}", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700,
                            color:eventProvider?.transactionList?[position].type=="Debit"? CustomColors.sErrorColor: CustomColors.sSuccessColor, fontFamily: "PlusJakartaSans")),

                        Text("${DateFormat.jm().format(eventProvider!.transactionList![position].dateCreated!)}",
                          style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400, color: CustomColors.sGreyScaleColor500),textAlign: TextAlign.center,),

                      ],
                    ),
                  ],
                ),
                height10,
              ],
            ),
          );
        });
    }
  }





}
