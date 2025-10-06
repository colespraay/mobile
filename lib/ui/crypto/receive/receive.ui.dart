import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/ui/crypto/crypto.vm.dart';
import 'package:spraay/ui/crypto/receive/receive-item-tiles.dart';

class ReceiveCryptoScreen extends StatefulWidget {
  const ReceiveCryptoScreen({super.key});

  @override
  State<ReceiveCryptoScreen> createState() => _ReceiveCryptoScreenState();
}

class _ReceiveCryptoScreenState extends State<ReceiveCryptoScreen> {
  CryptoProvider? cryptoProvider;

  @override
  void didChangeDependencies() {
    cryptoProvider = context.watch<CryptoProvider>();

    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<CryptoProvider>(context, listen: false).getUserWallets(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppBar(context: context, title: "Receive Crypto"),
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
                children: [ReceiveAssetList(assetsList: cryptoProvider?.wallets, isBuy: false)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
