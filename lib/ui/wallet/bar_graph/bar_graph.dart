import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/ui/wallet/bar_graph/bar_data.dart';
import 'package:spraay/view_model/event_provider.dart';

class SprayBarGraph extends StatelessWidget {
  EventProvider? eventProvider;
   SprayBarGraph(this.eventProvider, {Key? key}) : super(key: key);

  // List<double> weeklySummary=[4.00, 20.00, 42.00, 10.00, 99.00, 88.90, 12.00];

  double findHighestTotalAmount(List<double> totalAmountList) {
    return totalAmountList.reduce((value, element) => value > element ? value : element);
  }

  // List<double> extractTotalAmounts(String jsonData) {
  //   final Map<String, dynamic> data = json.decode(jsonData);
  //
  //   // Extract the 'data' list from the JSON
  //   List<dynamic> dataList = data['data'];
  //
  //   // Extract 'totalAmount' values and convert them to doubles
  //   List<double> totalAmountList = dataList.map((item) {
  //     return (item['totalAmount'] as int).toDouble();
  //   }).toList();
  //
  //   return totalAmountList;
  // }


  @override
  Widget build(BuildContext context) {


    if(eventProvider?.datum_graph_histories==null){
      return Container(
          height: 380.h,
          padding: EdgeInsets.only(top: 40.h, bottom: 20.h, right: 8.w, left: 16.w),
          decoration: BoxDecoration(
              color: CustomColors.sDarkColor2,
              borderRadius: BorderRadius.all(Radius.circular(20.r))
          ),
          child: Center(child: Text("Loading...", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w700, color: CustomColors.sPrimaryColor100))));
    }

    else if(eventProvider!.datum_graph_histories!.isEmpty){
      return Container(
          height: 380.h,
          padding: EdgeInsets.only(top: 40.h, bottom: 20.h, right: 8.w, left: 16.w),
          decoration: BoxDecoration(
              color: CustomColors.sDarkColor2,
              borderRadius: BorderRadius.all(Radius.circular(20.r))
          ),
          child: Center(child: Text("No Chart", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w700, color: CustomColors.sPrimaryColor100))));
    }

    else{



      // List<double> weeklySummary=eventProvider!.datum_graph_histories!.map((item) => item.totalAmount!.toDouble()).toList();
      // //initialize bar data
      // BarData myBarData=BarData(sunAmount: weeklySummary[0], monAmount: weeklySummary[1], tueAmount: weeklySummary[2], wedAmount: weeklySummary[3],
      //     thurAmount: weeklySummary[4], friAmount: weeklySummary[5], satAmount: weeklySummary[6]);
      //
      // myBarData.initializeBarData();

      return Container(
        height: 380.h,
        padding: EdgeInsets.only(top: 40.h, bottom: 20.h, right: 8.w, left: 16.w),
        decoration: BoxDecoration(color: CustomColors.sDarkColor2, borderRadius: BorderRadius.all(Radius.circular(20.r))),
        child: BarChart(

          BarChartData(
              maxY: /*100*/findHighestTotalAmount(eventProvider!.datum_graph_histories!.map((item) => item.totalAmount!.toDouble()).toList())*2,//max amount
              minY: 0,
              // alignment: BarChartAlignment.spaceBetween,
              titlesData: FlTitlesData(
                show: true,
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: bottomTitles)),
                leftTitles: AxisTitles(sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 46.r,
                  getTitlesWidget: (dataValue, value) => Text("N${dataValue.toInt()/1000}K", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 11.sp, fontWeight: FontWeight.w700, color: Color(0xff9E9E9E)),),

                )),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(horizontalInterval: 100.r, drawHorizontalLine: false, drawVerticalLine: false),
              barGroups:eventProvider!.datum_graph_histories!.map((data) => BarChartGroupData(x: data.monthCode??0,
                  barRods: [
                    BarChartRodData(
                      width: 24.w,
                      borderRadius:BorderRadius.zero,
                      toY: data.totalAmount!.toDouble(),
                      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xffAB9FFF), Color(0xff5B45FF)]),
                    )
                  ])).toList()
          ),
        ),
      );
    }
  }


  Widget bottomTitles(double value, TitleMeta titleMeta){

     TextStyle style=CustomTextStyle.kTxtBold.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w700, color: Color(0xff9E9E9E));

     Widget text;
     switch(value.toInt()){
       case 1:
         text= Text('Jan', style: style,);
         break;
       case 2:
         text= Text('Feb', style: style,);
         break;
       case 3:
         text= Text('Mar', style: style,);
         break;
       case 4:
         text= Text('Apr', style: style,);
         break;
       case 5:
         text= Text('May', style: style,);
         break;
       case 6:
         text= Text('Jun', style: style,);
         break;
       case 7:
         text= Text('Jul', style: style,);
         break;
       case 8:
         text= Text('Aug', style: style,);
         break;
       case 9:
         text= Text('Sep', style: style,);
         break;
       case 10:
         text= Text('Oct', style: style,);
         break;
       case 11:
         text= Text('Nov', style: style,);
         break;
       case 12:
         text= Text('Dec', style: style,);
         break;
       default:
         text= Text('', style: style,);
         break;

     }
     return SideTitleWidget(child: text, axisSide: titleMeta.axisSide);

  }
}
