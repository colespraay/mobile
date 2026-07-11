import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/navigations/fade_route.dart';
import 'package:spraay/navigations/scale_transition.dart';
import 'package:spraay/ui/crypto/crypto.ui.dart';
import 'package:spraay/ui/others/bill_payments/bill_payment_screen.dart';
import 'package:spraay/ui/others/spray/join_event.dart';
import 'package:spraay/ui/others/spray_gifting/spray_gifting.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  static final _actions = [
    const _QuickAction(
      icon: 'images/a-spray.svg',
      label: 'Spraay',
      transition: _QuickActionTransition.scale,
      destination: JoinEvent(),
    ),
    const _QuickAction(
      icon: 'images/a-virtual-number.svg',
      label: 'Bills',
      transition: _QuickActionTransition.scale,
      destination: BillPaymentScreen(),
    ),
    const _QuickAction(
      icon: 'images/a-crypto.svg',
      label: 'Crypto',
      transition: _QuickActionTransition.fade,
      destination: CryptoPage(),
    ),
    const _QuickAction(
      icon: 'images/a-giftcard.svg',
      label: 'Gift a Friend',
      transition: _QuickActionTransition.fade,
      destination: SprayGifting(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: CustomTextStyle.kTxtBold.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700),
        ),
        height16,
        Row(
          children: _actions
              .map(
                (action) => Expanded(
                  child: _QuickActionTile(action: action),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

enum _QuickActionTransition { scale, fade }

class _QuickAction {
  final String icon;
  final String label;
  final _QuickActionTransition transition;
  final Widget destination;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.transition,
    required this.destination,
  });
}

class _QuickActionTile extends StatelessWidget {
  final _QuickAction action;

  const _QuickActionTile({required this.action});

  void _onTap(BuildContext context) {
    final route = action.transition == _QuickActionTransition.scale
        ? ScaleTransition1(page: action.destination)
        : FadeRoute(page: action.destination);

    Navigator.push(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            action.icon,
            width: 64.w,
            height: 64.w,
          ),
          height8,
          Text(
            action.label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyle.kTxtRegular.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
