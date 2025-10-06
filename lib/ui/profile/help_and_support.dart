import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:open_mail_app/open_mail_app.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:url_launcher/url_launcher.dart' show LaunchMode, canLaunchUrl, launch, launchUrl;
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

  String firstBtn = "";
  @override
  void dispose() {
    _textField2Focus?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context: context, title: "Help and Support"),
        body: DefaultTabController(
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
                    unselectedLabelColor: CustomColors.sDarkColor3,
                    padding: EdgeInsets.zero,
                    labelPadding: EdgeInsets.zero,
                    labelStyle: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),
                    unselectedLabelStyle: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),
                    physics: const NeverScrollableScrollPhysics(),
                    tabs: const [
                      Tab(
                        text: "Help",
                      ),
                      Tab(
                        text: "Contact us",
                      )
                    ]),
              ),
              Expanded(
                child: TabBarView(physics: const NeverScrollableScrollPhysics(), children: [buildHelpWidget(), buildContactUs()]),
              )
            ],
          ),
        ));
  }

  TextEditingController controllerSearch = TextEditingController();
  Widget buildHelpWidget() {
    return Padding(
      padding: horizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // shrinkWrap: true,
        children: [
          height26,
          CustomizedTextField(
            textEditingController: controllerSearch,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            hintTxt: "Search",
            focusNode: _textField2Focus,
            onChanged: (value) {
              setState(() {
                firstBtn = value;
              });
            },
            prefixIcon: Padding(
              padding: EdgeInsets.only(right: 8.w, left: 10.w),
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

  int index_pos = 0;
  String titleContent = "General";
  List<String> horizList = ["General", "Account", "Events", "Top-up", "Withdraw"];
  Widget buildHorizontalTicket() {
    return SizedBox(
      height: 40.h,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: horizList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, int position) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  index_pos = position;
                  titleContent = horizList[position];
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                margin: EdgeInsets.only(right: 16.w),
                decoration: BoxDecoration(
                    color: index_pos == position ? CustomColors.sPrimaryColor500 : const Color(0x40335EF7),
                    border: Border.all(color: index_pos == position ? Colors.transparent : const Color(0xffFAFAFA)),
                    borderRadius: BorderRadius.all(Radius.circular(30.r))),
                child: Text(horizList[position], style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500, color: CustomColors.sWhiteColor)),
              ),
            );
          }),
    );
  }

  Widget _buildExpandedList(String title, String content) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        unselectedWidgetColor: CustomColors.sPrimaryColor500, // here for close state
        colorScheme: const ColorScheme.light(primary: CustomColors.sPrimaryColor500),
      ),
      child: ExpansionTile(
        //trailing: Padding(padding: EdgeInsets.zero,),
        childrenPadding: EdgeInsets.symmetric(horizontal: 16.w),
        collapsedBackgroundColor: CustomColors.sDarkColor2,
        collapsedIconColor: CustomColors.sPrimaryColor500,

        tilePadding: EdgeInsets.symmetric(horizontal: 16.w),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        backgroundColor: CustomColors.sDarkColor2,
        initiallyExpanded: false,
        title: Text(
          title,
          style: CustomTextStyle.kTxtBold.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),
        ),
        children: <Widget>[
          Text(
            content,
            style: CustomTextStyle.kTxtRegular.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKulean() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildExpandedList("What is Spraay and who can use it?",
            "Spraay is a digital money-spraying and payment app that makes celebrations and everyday transactions more fun. It replicates the act of 'spraying' money in a virtual way. Anyone can use it – event organizers, celebrants, attendees, churches, fundraisers, or anyone sending money to friends. Combines traditional gifting with modern features like a built-in wallet and bill payments."),
        height16,
        _buildExpandedList("Where can I download or access Spraay?",
            "Available on iOS, Android, and Web. Search 'Spraay' on Apple App Store/Google Play Store. Web version accessible via browser. Accounts sync across all platforms."),
        height16,
        _buildExpandedList("How do I sign up and create an account?",
            "1. Download app/web app → Tap 'Sign Up'\n2. Enter phone/email + password\n3. Verify with OTP\n4. Complete profile\nNo bank details needed initially. Free to sign up."),
        height16,
        _buildExpandedList("Does it cost anything to use Spraay?",
            "Free to download/sign up. No fees for receiving money or peer-to-peer gifts. Some services (bill payments/gift cards) may have partner fees shown upfront. No hidden/monthly charges."),
        height16,
        _buildExpandedList("Who is behind Spraay? Is it a legit service?",
            "Developed by Spraay Software Ltd (registered fintech). Partners with licensed payment providers. Complies with financial regulations. Funds held securely with banks."),
        height16,
        _buildExpandedList("How do I create an event on Spraay for my celebration?",
            "1. Tap 'Create Event' (+ button)\n2. Enter event name, date, location (virtual/physical)\n3. Set fundraising goal\n4. Share generated invite link/code"),
        height16,
        _buildExpandedList("How do invitations and RSVPs work in Spraay?",
            "Share unique event link/code via SMS/email/social. Guests tap 'Join Event' to RSVP. Host sees real-time RSVP list. Works for physical/virtual events."),
        height16,
        _buildExpandedList("What types of events can I use Spraay for?",
            "Weddings, birthdays, church events, fundraisers, graduations, concerts, virtual baby showers, etc. Any occasion involving gifts/cash spraying."),
        height16,
        _buildExpandedList("As an event host, can I see who gifted me and how much was raised?",
            "Yes. Event dashboard shows:\n- Live total amount\n- Contributor list with amounts/messages\n- Optional leaderboard\nOnly host/celebrant sees full details."),
        height16,
        _buildExpandedList("I’m attending an event – how do I spray money to the celebrant?",
            "1. RSVP first\n2. Open event page during live period\n3. Tap 'Spray Now'\n4. Enter amount + message/emoji\n5. Confirm – instant transfer with animation"),
        height16,
        _buildExpandedList("What exactly is 'digital money spraying'?",
            "Virtual version of tossing physical cash at celebrations. Transfers include festive animations/sounds. Safe alternative to physical money spraying."),
        height16,
        _buildExpandedList("Can I send money to someone outside of an event?",
            "Yes. Use 'Send Money' section:\n1. Select contact/enter details\n2. Enter amount\n3. Add message/emoji\n4. Instant transfer to recipient's wallet"),
        height16,
        _buildExpandedList("Do gifts or spray transfers happen instantly?", "Yes. Recipient's wallet updates immediately. Bank withdrawals may take 1-2 days. In-app balances are instant."),
        height16,
        _buildExpandedList("Are there limits on how much I can spray or gift?",
            "Yes. Limits include:\n- Per transaction cap\n- Daily/monthly limits\n- Higher limits after KYC verification\nApp alerts when approaching limits."),
        height16,
        _buildExpandedList("Can I cancel or undo a money spray after I’ve sent it?", "No. Transfers are final like cash. Contact recipient for refunds. Report fraud immediately to support."),
        height16,
        _buildExpandedList("What is the Spraay wallet and how does it work?",
            "Secure digital wallet for:\n- Storing received funds\n- Paying bills\n- Buying gift cards\n- Funding events\nSupports multiple currencies. Funds held with licensed partners."),
        height16,
        _buildExpandedList("How do I add money to my Spraay wallet?",
            "Options:\n- Bank transfer to virtual account\n- Mobile money/USSD (supported regions)\n- Payment gateways\nNo direct card entry – uses secure partner channels."),
        height16,
        _buildExpandedList("Can I use a debit/credit card to fund my wallet?", "Not directly. Cards processed via PCI-compliant partner gateways. Spraay never stores card details."),
        height16,
        _buildExpandedList("How do I withdraw money from my Spraay wallet?", "1. Tap 'Withdraw'\n2. Choose bank/mobile money\n3. Enter amount\nProcesses in 1-2 business days. Small fees may apply."),
        height16,
        _buildExpandedList("What can I pay for with Spraay besides sending gifts?", "Utility bills, airtime/data, gift cards, betting wallet funding. All via licensed providers."),
        height16,
        _buildExpandedList("Are there fees when paying bills or buying through Spraay?", "No fees for P2P transfers. Bill payments/gift cards may have partner fees shown upfront. No hidden markups."),
        height16,
        _buildExpandedList(
            "Is my money and personal data safe with Spraay?", "Yes. Features include:\n- Encryption\n- 2FA\n- Fraud monitoring\n- Funds held with licensed institutions\nNo card data stored."),
        height16,
        _buildExpandedList("Who processes payments on Spraay?", "Licensed payment providers/banks. Spraay acts as interface – money moves through regulated channels."),
        height16,
        _buildExpandedList("Why no direct card payments in-app?", "Security choice. Uses PCI-compliant gateways instead. Prevents card data storage. Compliant with regulations."),
        height16,
        _buildExpandedList(
            "Why see 'Spraay' on bank statement if unused?", "Possible reasons:\n1. Partner service used Spraay API\n2. Event funds withdrawal\n3. Fraud – contact bank/support immediately"),
        height16,
        _buildExpandedList("How can I contact Spraay support?", "1. In-app chat\n2. Email: hello@spraay.ng\n3. Help Center\n4. Social media (@Spraay_ng)\nInclude username/transaction details.")
      ],
    );
  }

  Widget buildData() {
    if (titleContent == "General") {
      return _buildKulean();
    } else if (titleContent == "Account") {
      return _buildKulean();
    } else if (titleContent == "Events") {
      return _buildKulean();
    } else if (titleContent == "Top-up") {
      return _buildKulean();
    } else if (titleContent == "Withdraw") {
      return _buildKulean();
    } else {
      return _buildKulean();
    }
  }

  Widget buildContactUs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height26,
        Expanded(
          child: ListView(
            padding: horizontalPadding,
            shrinkWrap: true,
            children: [
              _buildContainer(
                  img: "customer_serv",
                  title: "Customer Service",
                  onTap: () {
                    openEmailApp(context, "support@spraay.ng");
                  }),
              // _buildContainer(img: "whatsapp", title: "WhatsApp", onTap:(){
              //   openwhatsapp("08132567783");
              // }),
              _buildContainer(
                  img: "instagram",
                  title: "Instagram",
                  onTap: () async {
                    openUrlExternal(url: instagram);
                  }),
              _buildContainer(
                  img: "twitter",
                  title: "Twitter",
                  onTap: () async {
                    await openWeb1(twitter);
                  }),
              _buildContainer(
                  img: "fb",
                  title: "Facebook",
                  onTap: () async {
                    launchFacebookProfile();
                    // openUrlExternal(url: "https://www.facebook.com/share/1ABX6njiD3/?mibextid=wwXIfr");
                  }),
            ],
          ),
        ),
      ],
    );
  }

  void openEmailApp(BuildContext context, String emailAdd) async {
    //TODO: email app
    sendEmailTOCustomerCare(emailAdd);
    // EmailContent email = EmailContent(
    //   to: [emailAdd],
    //   subject: 'Customer Service',
    //   body: 'Hello! My name is',
    //   // cc: ['user2@domain.com', 'user3@domain.com'],
    //   // bcc: ['boss@domain.com'],
    // );
    //
    // OpenMailAppResult result = await OpenMailApp.composeNewEmailInMailApp(nativePickerTitle: 'Select email app to compose', emailContent: email);
    // if (!result.didOpen && !result.canOpen) {
    //   showNoMailAppsDialog(context);
    // } else if (!result.didOpen && result.canOpen) {
    //   showDialog(
    //     context: context,
    //     builder: (_) => MailAppPickerDialog(
    //       mailApps: result.options,
    //       emailContent: email,
    //     ),
    //   );
    // }
  }

  Widget _buildContainer({required String img, required String title, required void Function()? onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(color: CustomColors.sDarkColor2, borderRadius: BorderRadius.all(Radius.circular(18.r))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "images/$img.svg",
              width: 24.w,
              height: 24.w,
            ),
            SizedBox(
              width: 12.w,
            ),
            Expanded(
                child: Text(
              title,
              style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400),
            )),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: const Color(0xff9E9E9E),
              size: 20.r,
            )
          ],
        ),
      ),
    );
  }

  openWeb(String value) async {
    if (await canLaunchUrl(Uri.parse(value))) {
      await launchUrl(Uri.parse(value), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $value';
    }
  }

  openWeb1(String value) async {
    try {
      await launchUrl(Uri.parse(value), mode: LaunchMode.externalApplication);
    } catch (e) {
      throw 'Could not launch $value';
    }
  }

  openUrl(String v) async {
    launchUrl(Uri.parse(v), mode: LaunchMode.externalApplication);
  }

  openwhatsapp(String phone) async {
    final link = WhatsAppUnilink(
      phoneNumber: phone,
      text: "Hello",
    );
    // await launch('$link');
  }

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Open Mail App"),
          content: const Text("No mail apps installed"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}

void openMailApp({String? receiver, String? title, String? body}) {
  launchUrl(Uri.parse("mailto:$receiver?subject=$title&body=$body"));
}

sendEmailTOCustomerCare(String email) async {
  openMailApp(title: "Customer Service", receiver: email, body: "Hello \n\n My name is");
}

void openUrlExternal({String? url}) {
  launchUrl(Uri.parse(url ?? ""), mode: LaunchMode.externalApplication);
}

void launchFacebookProfile() async {
  final String fbProtocolUrl = Platform.isIOS ? 'fb://profile/1038452176342825' : facebook;
  const String fallbackUrl = 'https://www.facebook.com/1038452176342825';
  try {
    bool launched = await launchUrl(
      Uri.parse(fbProtocolUrl),
    );
    if (!launched) {
      await launchUrl(Uri.parse(fallbackUrl));
    }
  } catch (e) {
    print(e.toString());
    await launchUrl(Uri.parse(fallbackUrl));
  }
}
