import 'package:flutter/material.dart';

class GoogleMapLocationScreen extends StatefulWidget {
  const GoogleMapLocationScreen({Key? key}) : super(key: key);

  @override
  State<GoogleMapLocationScreen> createState() => _GoogleMapLocationScreenState();
}

class _GoogleMapLocationScreenState extends State<GoogleMapLocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  Container(color: Colors.pink,));
  }
}
