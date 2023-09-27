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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context: context, title: "Select Bank"),
        body:  Padding(
          padding: horizontalPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height26,
              Expanded(
                child: FutureBuilder<ApiResponse<ListOfBankModel>>(
                  future: ApiServices().listOfBankApi(MySharedPreference.getToken()),
                  builder: (context, snapshot) {

                    if (ConnectionState.active != null && !snapshot.hasData) {
                      return Center(child: SpinKitFadingCircle(size: 30,color: Colors.grey,));
                    }
                    else if (ConnectionState.done != null && snapshot.hasError || snapshot.data!.error==true) {

                    return Center(child: Text(snapshot.data!.errorMessage!, style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 18.sp,
                        fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor50),));
                    }
                    else if(snapshot.data!.data!.data!.isEmpty)
                    {
                      return Center(child: Text("Empty bank", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 18.sp,
                          fontWeight: FontWeight.w500, color: CustomColors.sGreyScaleColor50),));
                    }

                    return ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                        itemBuilder: (_, int position){
                      return InkWell(
                        onTap:(){
                          Navigator.push(context, SlideLeftRoute(page: ReceiverDetailScreen(snapshot.data?.data?.data?[position], widget.amount)));
                          },
                          child: buildContainer(snapshot.data?.data?.data?[position]));
                    },
                        separatorBuilder: (_, int posit){
                      return height26;
                        },
                        itemCount: snapshot.data!.data!.data!.length
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
            decoration: BoxDecoration(
              color: CustomColors.sTransparentPurplecolor,
              shape: BoxShape.circle
            ),
            child: Center(child: Text(getInitials(bankDetail?.bankName??""), style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400)))),

        // SvgPicture.asset("images/bnk.svg", width: 40.w, height: 40.h,),
        SizedBox(width: 16.w,),
        Text(bankDetail?.bankName??"", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400)),

      ],
    );
  }

}
