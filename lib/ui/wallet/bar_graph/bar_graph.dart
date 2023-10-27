import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/ui/wallet/bar_graph/bar_data.dart';
import 'package:spraay/view_model/event_provider.dart';

class SprayBarGraph extends StatelessWidget {
  EventProvider? eventProvider;
   SprayBarGraph(this.eventProvider, {Key? key}) : super(key: key);

  List<double> weeklySummary=[4.00, 20.00, 42.00, 10.00, 99.00, 88.90, 12.00];


  @override
  Widget build(BuildContext context) {
    //initialize bar data
    BarData myBarData=BarData(sunAmount: weeklySummary[0], monAmount: weeklySummary[1], tueAmount: weeklySummary[2], wedAmount: weeklySummary[3],
        thurAmount: weeklySummary[4], friAmount: weeklySummary[5], satAmount: weeklySummary[6]);

    myBarData.initializeBarData();

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

      return Container(
        height: 380.h,
        padding: EdgeInsets.only(top: 40.h, bottom: 20.h, right: 8.w, left: 16.w),
        decoration: BoxDecoration(
            color: CustomColors.sDarkColor2,
            borderRadius: BorderRadius.all(Radius.circular(20.r))
        ),
        child: BarChart(

          BarChartData(
              maxY: 100,//max amount
              minY: 0,
              // alignment: BarChartAlignment.spaceBetween,
              titlesData: FlTitlesData(
                show: true,
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: bottomTitles)),
                leftTitles: AxisTitles(sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 45.r,
                  getTitlesWidget: (dataValue, value) => Text("N${dataValue.toInt()}M", style: CustomTextStyle.kTxtBold.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w700, color: Color(0xff9E9E9E)),),

                )),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(horizontalInterval: 20.r, drawHorizontalLine: true, drawVerticalLine: false),
              barGroups: myBarData.barData.map((data) => BarChartGroupData(x: data.x,
                  barRods: [
                    BarChartRodData(
                      width: 24.w,
                      borderRadius:BorderRadius.zero,
                      toY: data.y,
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
       case 0:
         text= Text('Jan', style: style,);
         break;
       case 1:
         text= Text('Feb', style: style,);
         break;
       case 2:
         text= Text('Mar', style: style,);
         break;
       case 3:
         text= Text('Apr', style: style,);
         break;
       case 4:
         text= Text('May', style: style,);
         break;
       case 5:
         text= Text('Jun', style: style,);
         break;
       case 6:
         text= Text('Jul', style: style,);
         break;
       default:
         text= Text('', style: style,);
         break;

     }
     return SideTitleWidget(child: text, axisSide: titleMeta.axisSide);

  }
}
