import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spraay/models/giftcard-model.dart';
import 'package:spraay/ui/others/bill_payments/giftcard/giftcard-details.ui.dart';

class GiftCardDisplayWidget extends StatelessWidget {
  final SingleGiftCardModel card;
  const GiftCardDisplayWidget({
    super.key,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => GiftCardDetails(
                    title: "title",
                    card: card,
                  ))),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        width: MediaQuery.of(context).size.width / 2.1 - 24,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: const Color(0xff09090B),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xff9E9E9E))),
        child: Column(
          children: [
            // Hero(
            // tag: card.productId.toString(),
            // child:
            Image.network(
              card.logoUrls?[0] ?? "",
              fit: BoxFit.cover,
            ),
            // ),
            const SizedBox(
              height: 10,
            ),
            Text(
              card.productName ?? "",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 14.sp),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
