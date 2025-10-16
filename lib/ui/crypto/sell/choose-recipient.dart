import 'package:flutter/material.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/ui/crypto/widgets/misc.dart';

class ChooseRecipientScreen extends StatelessWidget {
  final addressController = TextEditingController();
  ValueNotifier<num> pageIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: pageIndex,
        builder: (context, page, _) {
          switch (page) {
            case 0:
              return Scaffold(
                backgroundColor: Colors.black,
                appBar: buildAppBar(context: context, title: "Buy Asset"),
                body: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CustomizedTextField(
                        textEditingController: addressController,
                        textInputAction: TextInputAction.next,
                        hintTxt: "Search",
                        // focusNode: _textField1Focus,
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 54,
                            ),
                            buttonWidget(
                              onDone: () {
                                if (addressController.text.isNotEmpty) {}
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            case 1:
              return SizedBox.shrink();
            default:
              return SizedBox.shrink();
          }
        });
  }
}
