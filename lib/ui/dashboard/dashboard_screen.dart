
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/ui/events/events.dart';
import 'package:spraay/ui/home/home_screen.dart';
import 'package:spraay/view_model/auth_provider.dart';

class DasboardScreen extends StatefulWidget {
  const DasboardScreen({Key? key}) : super(key: key);

  @override
  State<DasboardScreen> createState() => _DasboardScreenState();
}

class _DasboardScreenState extends State<DasboardScreen> {

  List<Widget> _widgetOption = [
    HomeScreen(),
    EventsScreen(),
    SizedBox.shrink(),//empty page between
    Container(color: Colors.pinkAccent,),
    Container(color: Colors.brown,),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: IndexedStack(
          children: [
            _widgetOption.elementAt( Provider.of<AuthProvider>(context, listen: true).selectedIndex),
          ]),
      floatingActionButton:  SizedBox(
        width: 80.w,
        height: 80.h,
        child: FittedBox(
          child: FloatingActionButton(
            shape: RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(40.r))),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            elevation: 10,
            backgroundColor: Color(0xffD3F701),
            onPressed: () {
              // _choseAnimalModal();
            },
            child: SvgPicture.asset("images/add_icon.svg"),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.r),
          topRight: Radius.circular(15.r),
        ),
        child: BottomNavigationBar(
          backgroundColor:CustomColors.sDarkColor2,
          type: BottomNavigationBarType.fixed,
          selectedItemColor:CustomColors.sPrimaryColor500 ,
          selectedLabelStyle: CustomTextStyle.kTxtBold.copyWith(fontSize: 12.sp,color: Color(0xff868686)),
          unselectedLabelStyle: CustomTextStyle.kTxtRegular.copyWith(fontSize: 12.sp,color: Color(0xff868686)),
          unselectedItemColor:Color(0xff868686),
          items: [
            buildButomNav(img: "selected_home", title: "Home"),
            buildButomNav(img: "selected_event", title: "Events"),

            BottomNavigationBarItem(activeIcon: SizedBox(width: 24.w,),
                icon:SizedBox(width: 24.w,), label: ""),

            buildButomNav(img: "selected_wallet", title: "Wallet"),
            buildButomNav(img: "selected_profile", title: "Profile"),
          ],
          currentIndex: Provider.of<AuthProvider>(context, listen: true).selectedIndex,
          onTap:  (index) {Provider.of<AuthProvider>(context, listen: false).onItemTap(index);},
        ),
      ),


      // bottomNavigationBar: Container(
      //   padding:  EdgeInsets.only(top: 10.h,bottom: 16.h),
      //   child: Row(
      //     mainAxisSize: MainAxisSize.max,
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: <Widget>[
      //
      //       buildBtmNav(position: 0, img: "selected_home", title: "Home", grey_img: 'un_selected_home'),
      //
      //       buildBtmNav(position: 1, img: "selected_event", title: "Events", grey_img: 'un_selected_event'),
      //       SizedBox(width: 48.w,),
      //
      //       // Container(
      //       //   width: 80.w,
      //       //   height: 80.h,
      //       //   decoration: BoxDecoration(
      //       //     color: Color(0xffD3F701),
      //       //     shape: BoxShape.circle
      //       //   ),
      //       // ),
      //
      //       buildBtmNav(position: 2, img: "selected_wallet", title: "Wallet", grey_img: 'un_selected_wallet'),
      //       buildBtmNav(position: 3, img: "selected_profile", title: "Profile", grey_img: 'un_selected_profile'),
      //     ],
      //   ),
      // ),
    );
  }


  BottomNavigationBarItem buildButomNav({required String img, required String title}){
    return   BottomNavigationBarItem(activeIcon: SvgPicture.asset("images/$img.svg",color: CustomColors.sPrimaryColor500),
        icon:SvgPicture.asset('images/$img.svg',color: Color(0xff868686),), label: title);
  }

  Widget buildBtmNav({required int position,required String img,required String title,required String grey_img }){
    return   InkWell(
      onTap:(){
        Provider.of<AuthProvider>(context, listen: false).onItemTap(position);

      },
      child:  Provider.of<AuthProvider>(context, listen: true).selectedIndex == position ?  Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset("images/$img.svg"),
          Text(title, style: CustomTextStyle.kTxtBold.copyWith(fontSize: 12.sp,color: CustomColors.sPrimaryColor500),)
        ],
      )

          : Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset("images/$grey_img.svg"),
              Text(title, style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 12.sp,color: Color(0xff868686)),)
            ],
          ) ,
    );
  }
}
