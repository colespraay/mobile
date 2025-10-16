import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/ui/crypto/buy/buy.ui.dart';
import 'package:spraay/ui/crypto/crypto.ui.dart';
import 'package:spraay/ui/crypto/crypto.vm.dart';
import 'package:spraay/utils/after-layout.dart';

class SellCryptoScreen extends StatefulWidget {
  const SellCryptoScreen({super.key});

  @override
  State<SellCryptoScreen> createState() => _SellCryptoScreenState();
}

class _SellCryptoScreenState extends State<SellCryptoScreen> with AfterLayoutMixin<SellCryptoScreen> {
  CryptoProvider? cryptoProvider;

  @override
  void didChangeDependencies() {
    cryptoProvider = context.watch<CryptoProvider>();

    super.didChangeDependencies();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    Provider.of<CryptoProvider>(context, listen: false).getUserWallets(context);
    Provider.of<CryptoProvider>(context, listen: false).getFees(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppBar(context: context, title: "Sell Asset"),
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
                  TradeAssetList(
                    assetsList: assets,
                    isBuy: false,
                    showAll: true,
                    wallet: cryptoProvider?.wallets ?? [],
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
