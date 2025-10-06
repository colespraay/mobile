import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as baseImg;
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/utils/my_sharedpref.dart';

import '../../view_model/auth_provider.dart';

class BvnVerification extends StatefulWidget {
  const BvnVerification({Key? key}) : super(key: key);

  @override
  State<BvnVerification> createState() => _BvnVerificationState();
}

class _BvnVerificationState extends State<BvnVerification> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController photoController = TextEditingController();
  FocusNode? _textField1Focus;

  @override
  void initState() {
    super.initState();
    setState(() {
      _textField1Focus = FocusNode();
    });
  }

  AuthProvider? credentialsProvider;

  @override
  void didChangeDependencies() {
    credentialsProvider = context.watch<AuthProvider>();
    super.didChangeDependencies();
  }

  String firstBtn = "";

  @override
  void dispose() {
    _textField1Focus?.dispose();
    super.dispose();
  }

  File? bvnImage;

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayWidget(
      loading: credentialsProvider?.loading ?? false,
      child: Scaffold(
          appBar: buildAppBar(context: context, title: "BVN Verification"),
          body: Padding(
            padding: horizontalPadding,
            child: ListView(
              shrinkWrap: true,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height22,
                buildContainer(),
                height26,
                CustomizedTextField(
                  textEditingController: phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  hintTxt: "7012345678",
                  focusNode: _textField1Focus,
                  maxLength: 11,
                  inputFormat: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    setState(() {
                      firstBtn = value;
                    });
                  },
                ),
                height16,
                CustomizedTextField(
                  readOnly: true,
                  onTap: () {
                    uploadPhoto(context, (p) {
                      print(p.path);
                      setState(() {
                        bvnImage = p;
                      });
                      photoController.text = baseImg.basename(bvnImage?.path ?? "").replaceAll("image_picker_", "");
                    });
                  },
                  textEditingController: photoController,
                  textInputAction: TextInputAction.done,
                  hintTxt: "Upload Photo",
                  focusNode: _textField1Focus,
                ),
                height50,
                CustomButton(
                    onTap: () async {
                      if (firstBtn.length == 11 && bvnImage != null) {
                        var result = await Provider.of<AuthProvider>(context, listen: false).uploadFile(context, bvnImage!, baseImg.basename(bvnImage?.path ?? ""));
                        Provider.of<AuthProvider>(context, listen: false).verifyBvnCodeEndpoint(context, MySharedPreference.getUId(), phoneController.text, selfie: result);
                      }
                    },
                    buttonText: 'Verify',
                    borderRadius: 30.r,
                    width: 380.w,
                    buttonColor: (firstBtn.length == 11 && bvnImage != null) ? CustomColors.sPrimaryColor500 : CustomColors.sDisableButtonColor),
                height40
              ],
            ),
          )),
    );
  }

  Widget buildContainer() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(color: CustomColors.sTransparentPurplecolor, borderRadius: BorderRadius.all(Radius.circular(30.r)), border: Border.all(color: CustomColors.sGreyScaleColor300)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "images/profile_avatar.svg",
            width: 60.w,
            height: 60.h,
          ),
          SizedBox(
            width: 12.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Why do we need your BVN?", style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w500, color: CustomColors.sPrimaryColor100)),
                height4,
                Text(
                    "We need your BVN to verify your identity. This does not give Spray app any access to your bank data or balances. This is just to enable us confirm your identity(real name, phone number & date of birth).",
                    style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> uploadPhoto(context, Function(File) onDone) async {
  var file = await _getImage(source: ImageSource.camera);
  if (file != null) {
    onDone(file);
    // Navigator.pop(context);
  }
  // return showModalBottomSheet(
  //     context: context,
  //     backgroundColor: CustomColors.sDarkColor2,
  //     isScrollControlled: true,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(30.r),
  //         topRight: Radius.circular(30.r),
  //       ),
  //     ),
  //     builder: (context) => StatefulBuilder(
  //         builder: (context, setState) => SizedBox(
  //               width: double.infinity,
  //               child: Padding(
  //                   padding: EdgeInsets.symmetric(horizontal: 16.w),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     mainAxisSize: MainAxisSize.min,
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       height34,
  //                       Text("Upload Photo",
  //                           style: CustomTextStyle.kTxtBold.copyWith(
  //                             fontSize: 22.sp,
  //                             fontWeight: FontWeight.w700,
  //                           )),
  //                       height18,
  //                       Text("Please select a source for selecting a photo to do your bvn verification",
  //                           style: CustomTextStyle.kTxtRegular.copyWith(
  //                             fontSize: 16.sp,
  //                             fontWeight: FontWeight.w400,
  //                           )),
  //                       height40,
  //                       CameraSourceListItem(
  //                         title: "Camera",
  //                         onTap: () async {
  //                           var file = await _getImage(source: ImageSource.camera);
  //                           if (file != null) {
  //                             onDone(file);
  //                             Navigator.pop(context);
  //                           }
  //                         },
  //                       ),
  //                       height12,
  //                       CameraSourceListItem(
  //                         title: "Gallery",
  //                         onTap: () async {
  //                           var file = await _getImage();
  //                           if (file != null) {
  //                             onDone(file);
  //                             Navigator.pop(context);
  //                           }
  //                         },
  //                       ),
  //                       height22,
  //
  //                       // height30,
  //                     ],
  //                   )),
  //             )));
}

class CameraSourceListItem extends StatelessWidget {
  final Function onTap;
  final String title;
  final String? icon;
  const CameraSourceListItem({super.key, required this.onTap, this.title = "", this.icon = "images/profile_avatar.svg"});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(color: CustomColors.sTransparentPurplecolor, borderRadius: BorderRadius.all(Radius.circular(30.r)), border: Border.all(color: CustomColors.sGreyScaleColor300)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.picture_in_picture,
              color: Colors.white,
            ),
            SizedBox(
              width: 12.w,
            ),
            Text(title, style: CustomTextStyle.kTxtSemiBold.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500, color: CustomColors.sPrimaryColor100)),
          ],
        ),
      ),
    );
  }
}

Future<File?> _getImage({ImageSource source = ImageSource.gallery}) async {
  final ImagePicker picker = ImagePicker();
  File? imageFile;
  final XFile? image = await picker.pickImage(source: source);
  if (image != null) {
    imageFile = File(image.path);
  }
  return imageFile;
}
