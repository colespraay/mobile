import 'package:flutter/material.dart';
import 'package:spraay/components/reusable_widget.dart';

class QrCodeScanner extends StatelessWidget {
  const QrCodeScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, appBar: buildAppBar(context: context, title: "Scan Address"), body: Container()
        // MobileScanner(
        //   onDetect: (result) {
        //     print(result.barcodes.first.rawValue);
        //     Navigator.pop(context, result.barcodes.first.rawValue);
        //   },
        // )
        );
  }
}
