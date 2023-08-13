import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/SlideLeftRoute.dart';
import 'package:spraay/ui/others/spray/join_event_info.dart';

class JoinEvent extends StatefulWidget {
  const JoinEvent({Key? key}) : super(key: key);

  @override
  State<JoinEvent> createState() => _JoinEventState();
}

class _JoinEventState extends State<JoinEvent> {

  final GlobalKey<FormState> _myKey = GlobalKey<FormState>();
  TextEditingController invitationController=TextEditingController();
  FocusNode? _textField1Focus;

  @override
  void initState() {
    setState(() {
      _textField1Focus = FocusNode();
    });
  }

  String firstVal="";
  @override
  void dispose() {
    _textField1Focus?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: buildAppBar(context: context, title:"Join Event" ),
        body: Form(
          key: _myKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child:  buildInviWidget(),
        ));
  }

  Widget buildInviWidget(){
    return ListView(
      padding: horizontalPadding,
      shrinkWrap: true,
      children: [
        height20,
        Center(child: Text("Please enter the event invitation code", style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400,),)),
        height20,

        CustomizedTextField(textEditingController:invitationController, keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,hintTxt: "Invitation Code",focusNode: _textField1Focus,
          onChanged:(value){
            setState(() {firstVal=value;});
          },
        ),
        height26,

        CustomButton(
            onTap: () {
              if( firstVal.isNotEmpty){
                Navigator.push(context, SlideLeftRoute(page: JoinEventInfo()));
              }
            },
            buttonText: 'Next', borderRadius: 30.r,width: 380.w,
            buttonColor: (firstVal.isNotEmpty) ? CustomColors.sPrimaryColor500:
            CustomColors.sDisableButtonColor),
        height34,

      ],
    );
  }

}
