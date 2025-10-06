import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/view_model/bill_payment_provider.dart';

class CustomGiftCardCountryDropdown extends StatefulWidget {
  const CustomGiftCardCountryDropdown({Key? key}) : super(key: key);

  @override
  State<CustomGiftCardCountryDropdown> createState() => _CustomGiftCardCountryDropdownState();
}

class _CustomGiftCardCountryDropdownState extends State<CustomGiftCardCountryDropdown> {
  bool _isDropdownOpen = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _toggleDropdown() {
    setState(() {
      _isDropdownOpen = !_isDropdownOpen;

      if (_isDropdownOpen) {
        _showDropdown();
      } else {
        _removeOverlay();
      }
    });
  }

  void _showDropdown() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Consumer<BillPaymentProvider>(
          builder: (context, provider, _) {
            return Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height),
                child: Material(
                  elevation: 4,
                  color: CustomColors.sDarkColor2,
                  borderRadius: BorderRadius.circular(8.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    constraints: BoxConstraints(
                      maxHeight: 250.h,
                    ),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: provider.giftCardCountries.value
                          .map((country) => InkWell(
                                onTap: () {
                                  provider.selectedGiftCardCountry = country;
                                  Provider.of<BillPaymentProvider>(context, listen: false).fetchGiftCardsByCountry();
                                  setState(() {
                                    _isDropdownOpen = false;
                                  });
                                  _removeOverlay();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                                  color: provider.selectedGiftCardCountry?.name == country.name ? CustomColors.sPrimaryColor500.withOpacity(0.2) : Colors.transparent,
                                  child: Text(
                                    country.name ?? "",
                                    style: CustomTextStyle.kTxtRegular.copyWith(
                                      color: CustomColors.sWhiteColor,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BillPaymentProvider>(
      builder: (context, provider, _) {
        return CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: _toggleDropdown,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: CustomColors.sDarkColor2,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: _isDropdownOpen ? CustomColors.sPrimaryColor500 : Colors.transparent,
                  width: _isDropdownOpen ? 0.5 : 0.1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      provider.selectedGiftCardCountry?.name ?? "Choose Country",
                      style: CustomTextStyle.kTxtRegular.copyWith(
                        color: provider.selectedGiftCardCountry != null ? CustomColors.sWhiteColor : CustomColors.sGreyScaleColor500,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    _isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: CustomColors.sDisableButtonColor,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget buildGiftCardCountryDropdown() {
  return const CustomGiftCardCountryDropdown();
}
