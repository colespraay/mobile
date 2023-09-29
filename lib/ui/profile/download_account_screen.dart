import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/file_storage.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/view_model/transaction_provider.dart';

class DownloadAccountUi extends StatefulWidget {
  const DownloadAccountUi({super.key});

  @override
  State<DownloadAccountUi> createState() => _DownloadAccountUiState();
}

class _DownloadAccountUiState extends State<DownloadAccountUi> {

  TextEditingController startDateController=TextEditingController();
  TextEditingController endDateController=TextEditingController();


  final GlobalKey<FormState> _myKey = GlobalKey<FormState>();

  FocusNode? _textField3Focus;
  FocusNode? _textField4Focus;

  TransactionProvider? _transactionProvider;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _transactionProvider=context.watch<TransactionProvider>();
  }


  @override
  void initState() {
    FileStorage.getExternalDocumentPath();

    setState(() {
      _textField3Focus = FocusNode();
      _textField4Focus = FocusNode();
    });
  }


  String thirdVal="";
  String forthVal="";
  @override
  void dispose() {
    _textField3Focus?.dispose();
    _textField4Focus?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  LoadingOverlayWidget(
      loading: _transactionProvider!.loading,
      child: Scaffold(
          appBar: buildAppBar(context: context, title:"Download Statement" ),
          body: Form(
            key: _myKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: buildStep1Widget(),
          )),
    );

  }

  Widget buildStep1Widget(){
    return ListView(
      padding: horizontalPadding,
      shrinkWrap: true,
      children: [
        height20,
        Text("Choose period you want to download", style: CustomTextStyle.kTxtRegular.copyWith(fontWeight: FontWeight.w400, fontSize: 18.sp)),
        height40,

        CustomizedTextField(textEditingController:startDateController, keyboardType: TextInputType.datetime,
          textInputAction: TextInputAction.next,hintTxt: "Start Date",focusNode: _textField3Focus,
          surffixWidget: Padding(
            padding:  EdgeInsets.only(right: 10.w,),
            child: SvgPicture.asset("images/calendar.svg"),
          ),
            readOnly: true,
            onTap:(){
              _selectStartDate(context);
            },
          onChanged:(value){
            setState(() {thirdVal=value;});
          },
        ),

        height16,
        CustomizedTextField(textEditingController:endDateController, keyboardType: TextInputType.datetime,
          textInputAction: TextInputAction.done,hintTxt: "End Date",focusNode: _textField4Focus,
          surffixWidget: Padding(
            padding:  EdgeInsets.only(right: 10.w),
            child: SvgPicture.asset("images/calendar.svg"),
          ),
          onChanged:(value){
            setState(() {forthVal=value;});
          },
          readOnly: true,
          onTap:(){
            _selectDate(context);
          },
        ),

        height26,



        height26,
        CustomButton(
            onTap: () {
              // fetchdownloadSOAApi
              // print("endDateController=${selectedDate}  selectedStartDate=${selectedStartDate}");

              if(thirdVal.isNotEmpty && forthVal.isNotEmpty){

                Provider.of<TransactionProvider>(context, listen: false).fetchdownloadSOAApi(context, selectedStartDate.toString(), selectedDate.toString());

              }
            },
            buttonText: 'Download', borderRadius: 30.r,width: 380.w,
            buttonColor: ( thirdVal.isNotEmpty && forthVal.isNotEmpty) ? CustomColors.sPrimaryColor500:
            CustomColors.sDisableButtonColor),
        height34,



      ],
    );
  }



  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1800, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        forthVal="value";
      });
      endDateController.text=  DateFormat('yyyy-MM-dd').format(selectedDate);
      // print("selectedDate==${selectedDate}");
    }
  }

  DateTime selectedStartDate = DateTime.now();

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedStartDate,
        firstDate: DateTime(1800, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedStartDate) {
      setState(() {
        selectedStartDate = picked;
        thirdVal="value";
      });
      startDateController.text=  DateFormat('yyyy-MM-dd').format(selectedStartDate);
      // print("selectedDate==${selectedDate}");
    }
  }


}
