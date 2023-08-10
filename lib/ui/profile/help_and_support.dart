import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class HelpAndSupportScreen extends StatefulWidget {
  const HelpAndSupportScreen({Key? key}) : super(key: key);

  @override
  State<HelpAndSupportScreen> createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {

  FocusNode? _textField2Focus;
  @override
  void initState() {
    setState(() {
      _textField2Focus = FocusNode();
    });
  }

  String firstBtn="";
  @override
  void dispose() {
    _textField2Focus?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context: context, title: "Help and Support"),
        body:  DefaultTabController(
          length: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height18,
              SizedBox(
                width: double.infinity,
                height: 40.h,
                child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,

                    indicatorColor: CustomColors.sPrimaryColor500,
                    labelColor: CustomColors.sPrimaryColor500,
                    unselectedLabelColor:CustomColors.sDarkColor3,
                    padding: EdgeInsets.zero,
                    labelPadding: EdgeInsets.zero,
                    labelStyle: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),
                    unselectedLabelStyle: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),
                    physics: NeverScrollableScrollPhysics(),
                    tabs:[Tab(text: "Help",), Tab(text: "Contact us",)]),
              ),

              Expanded(
                child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      buildHelpWidget(),
                      buildContactUs()
                    ]),
              )



            ],
          ),
        ));
  }

  TextEditingController controllerSearch=TextEditingController();
  Widget buildHelpWidget(){
    return Padding(
      padding: horizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // shrinkWrap: true,
        children: [
          height26,
          CustomizedTextField(textEditingController:controllerSearch, keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,hintTxt: "Search", focusNode: _textField2Focus,
            onChanged:(value){
              setState(() {firstBtn=value;});
            },
            prefixIcon: Padding(
              padding:  EdgeInsets.only(right: 8.w, left: 10.w),
              child: SvgPicture.asset("images/search.svg"),
            ),
          ),

          height26,
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                buildHorizontalTicket(),
                height22,
                buildData(),

              ],
            ),
          )


        ],
      ),
    );
  }


  int index_pos=0;
  String titleContent="General";
  List<String> horizList=["General", "Account", "Events", "Top-up", "Withdraw"];
  Widget buildHorizontalTicket(){
    return SizedBox(
      height: 40.h,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: horizList.length,
          scrollDirection:  Axis.horizontal,
          itemBuilder: (context,int position){
            return GestureDetector(
              onTap:(){
                setState(() {
                  index_pos=position;
                  titleContent=horizList[position];
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                margin: EdgeInsets.only(right: 16.w),
                decoration: BoxDecoration(
                    color:index_pos==position? CustomColors.sPrimaryColor500: Color(0x40335EF7),
                    border: Border.all(color:index_pos==position? Colors.transparent: Color(0xffFAFAFA)),
                    borderRadius: BorderRadius.all(Radius.circular(30.r))
                ),
                child: Text(horizList[position], style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500, color: CustomColors.sWhiteColor) ),
              ),
            );
          }),
    );
  }

  Widget _buildExpandedList(String title, String content){
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent,
        unselectedWidgetColor: CustomColors.sPrimaryColor500, // here for close state
        colorScheme: ColorScheme.light(primary: CustomColors.sPrimaryColor500),
      ),
      child: ExpansionTile(
        //trailing: Padding(padding: EdgeInsets.zero,),
        childrenPadding:EdgeInsets.symmetric(horizontal: 16.w),
        collapsedBackgroundColor: CustomColors.sDarkColor2,
        collapsedIconColor: CustomColors.sPrimaryColor500,

        tilePadding: EdgeInsets.symmetric(horizontal: 16.w),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        backgroundColor: CustomColors.sDarkColor2,
        initiallyExpanded: false,
        title: Text(title, style: CustomTextStyle.kTxtBold.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),),
        children: <Widget>[
          Text(content, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400,),),
        ],
      ),
    );

  }

  Widget _buildKulean(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildExpandedList("What is Spraay?", "What is Spraay? is a one stop payment solution for individuals, businesses, marketplaces, and ecommerceplatforms. It allows you to make secure payments for goods and services."),
        height16,
        _buildExpandedList("What is Spraay?", "What is Spraay? is a one stop payment solution for individuals, businesses, marketplaces, and ecommerceplatforms. It allows you to make secure payments for goods and services."),
        height16,
        _buildExpandedList("What is Spraay?", "What is Spraay? is a one stop payment solution for individuals, businesses, marketplaces, and ecommerceplatforms. It allows you to make secure payments for goods and services."),
        height16,
        _buildExpandedList("What is Spraay?", "What is Spraay? is a one stop payment solution for individuals, businesses, marketplaces, and ecommerceplatforms. It allows you to make secure payments for goods and services."),
        height16,
        _buildExpandedList("What is Spraay?", "What is Spraay? is a one stop payment solution for individuals, businesses, marketplaces, and ecommerceplatforms. It allows you to make secure payments for goods and services."),

      ],
    );
  }

  Widget buildData(){
    if( titleContent=="General"){
      return _buildKulean();
    }
    else if(titleContent=="Account"){
      return _buildKulean();
    }
    else if(titleContent=="Events"){
      return _buildKulean();
    }
    else if(titleContent=="Top-up"){
      return _buildKulean();
    }
    else if(titleContent=="Withdraw"){
      return _buildKulean();
    }
   else{
      return _buildKulean();
    }
  }

  Widget buildContactUs(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height26,
        Expanded(
          child: ListView(
            padding: horizontalPadding,
            shrinkWrap: true,
            children: [
              _buildContainer(img: "customer_serv", title: "Customer Service", onTap:(){

              }),
              _buildContainer(img: "whatsapp", title: "WhatsApp", onTap:(){
                openwhatsapp("08132567783");
              }),
              _buildContainer(img: "instagram", title: "Instagram", onTap:(){
                openWeb("url");
              }),
              _buildContainer(img: "twitter", title: "Twitter", onTap:(){
                openWeb("url");
              }),
              _buildContainer(img: "fb", title: "Facebook", onTap:(){
                openWeb("url");
              }),


            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContainer({required String img, required String title, required void Function()? onTap }){
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: CustomColors.sDarkColor2,
          borderRadius: BorderRadius.all(Radius.circular(18.r))
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset("images/$img.svg", width: 24.w, height: 24.w,),
            SizedBox(width: 12.w,),
            Expanded(child: Text(title, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400),)),
            Icon(Icons.arrow_forward_ios_outlined, color: Color(0xff9E9E9E), size: 20.r,)
          ],
        ),
      ),
    );
  }

  openWeb(String value)async{
    if (await canLaunchUrl(Uri.parse(value))) {
      await launchUrl(Uri.parse(value), mode:LaunchMode.externalApplication );
    } else {
      throw 'Could not launch $value';
    }}

  openwhatsapp(String phone) async {
    final link = WhatsAppUnilink(
      phoneNumber: phone,
      text: "Hello",
    );
    await launch('$link');
  }

}
