import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';

class ViewProfile extends StatelessWidget {
  String imageUrl;
   ViewProfile({Key? key,required this.imageUrl }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context: context, title: "View Image"),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // height20,
            Hero(
              tag: "hero_image",
              transitionOnUserGestures: true,
              child: SizedBox(
                height: MediaQuery.of(context).size.height/2,
                  width: double.infinity,
                  child: _buildProfile(imageUrl: imageUrl)),
            ),
            // height20,

          ],
        )
    );
  }

  Widget _buildProfile({required String imageUrl}){
    return  CachedNetworkImage(
      imageUrl:imageUrl,
      fit: BoxFit.cover,
      // imageBuilder: (context, imageProvider) => Container(decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: imageProvider, fit: BoxFit.cover,),),),
      placeholder: (context, url) => const Center(child: SpinKitFadingCircle(size: 30,color: Colors.grey,)),
      errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
    );
  }

}
