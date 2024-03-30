import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/list_of_banks_model.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/services/api_response.dart';
import 'package:spraay/services/api_services.dart';
import 'package:spraay/ui/wallet/withdrawal/receiver_detail.dart';
import 'package:spraay/utils/my_sharedpref.dart';

class SelectBankScreen extends StatefulWidget {
  String amount;
  SelectBankScreen({required this.amount, Key? key}) : super(key: key);

  @override
  State<SelectBankScreen> createState() => _SelectBankScreenState();
}

class _SelectBankScreenState extends State<SelectBankScreen> {

  List<DatumBankModel> banklist=[];

  @override
  void initState() {
    _fetchGetAllBankList();
  }

  ApiResponse<ListOfBankModel>? _apiResponse;
  bool _isLoading=false;
  _fetchGetAllBankList() async{
    setState(() {_isLoading=true;});
    _apiResponse=await ApiServices().listOfBankApi(MySharedPreference.getToken());
    if(_apiResponse?.data?.code==200){
      setState(() {banklist=_apiResponse?.data?.data??[];});
    }else{
      setState(() {banklist=[];});
    }
    setState(() {_isLoading=false;});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context: context, title: "Select Bank"),
        body:  Padding(
          padding: horizontalPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              TextField(
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  decoration:  InputDecoration(
                      hintText: "Search Bank",
                      hintStyle: TextStyle(color: Colors.white60, fontSize: 16.sp),
                      isDense: true,
                    enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xff4D4850), width: 0.5),),
                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color:CustomColors.sPrimaryColor400, width: 0.5),),
                  ),
                  onChanged: (value) =>_runFilter(value)
              ),

              height20,

              Expanded(
                child: Builder(
                  builder: (context) {

                    if (_isLoading==true) {
                      return const Center(child: SpinKitFadingCircle(size: 30,color: Colors.grey,));
                    }
                    // else if () {
                    //
                    // return Center(child: Text(snapshot.data!.errorMessage!, style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 18.sp,
                    //     fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor50),));
                    // }
                    else if(banklist.isEmpty)
                    {
                      return Center(child: Text("Empty bank", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 18.sp,
                          fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor50),));
                    }


                    return ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                        itemBuilder: (_, int position){
                      return InkWell(
                        onTap:(){
                          Navigator.push(context, SlideLeftRoute(page: ReceiverDetailScreen(banklist[position], widget.amount)));
                          },
                          child: buildContainer(banklist[position]));
                    },
                        separatorBuilder: (_, int posit){return height26;},
                        itemCount: banklist.length
                    );


                  }
                ),
              ),

              height18,



            ],
          ),
        ));
  }

  Widget buildContainer(DatumBankModel? bankDetail){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 40.w,
            height: 40.h,
            decoration: const BoxDecoration(color: CustomColors.sTransparentPurplecolor, shape: BoxShape.circle),
            child: Center(child: Text(getInitials(bankDetail?.bankName??""), style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400)))),

        // SvgPicture.asset("images/bnk.svg", width: 40.w, height: 40.h,),
        SizedBox(width: 16.w,),
        Expanded(child: Text(bankDetail?.bankName??"", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400))),

      ],
    );
  }

  void _runFilter(String enteredKeyword) {
    List<DatumBankModel>? results=[];
    if (enteredKeyword.isEmpty) {
      results = _apiResponse?.data?.data??[];
    } else {
      results=_apiResponse?.data?.data?.where((element) => element.bankName!.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
    }

    // Refresh the UI
    setState(() {
      banklist = results??[];
    });
  }

}
