import 'package:flutter/material.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/ui/crypto/widgets/misc.dart';

class ChooseRecipientScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppBar(context: context, title: "Buy Asset"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomizedTextField(
              textEditingController: TextEditingController(),
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
                    onDone: () {},
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
