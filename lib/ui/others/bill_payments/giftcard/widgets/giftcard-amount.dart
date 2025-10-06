import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/giftcard/giftcard-country-response.dart';
import 'package:spraay/view_model/bill_payment_provider.dart';

/// A generic modular dropdown widget that can be used with any type of data.
class CustomDropdown<T> extends StatefulWidget {
  /// The list of items to display in the dropdown.
  final List<T> items;

  /// The currently selected item.
  final T? selectedItem;

  /// Function that gets called when a new item is selected.
  final Function(T) onItemSelected;

  /// Function to extract the display name from an item.
  final String Function(T) itemLabelBuilder;

  /// Function to extract a unique identifier from an item for comparison.
  final dynamic Function(T)? itemIdBuilder;

  /// The hint text to show when no item is selected.
  final String hintText;

  /// Maximum height of the dropdown list.
  final double maxDropdownHeight;

  /// Text style for the dropdown items.
  final TextStyle? itemTextStyle;

  /// Text style for the hint text.
  final TextStyle? hintTextStyle;

  /// Text style for the selected item.
  final TextStyle? selectedItemTextStyle;

  /// Background color for the dropdown button.
  final Color backgroundColor;

  /// Background color for the dropdown list.
  final Color dropdownColor;

  /// Border color when dropdown is open.
  final Color focusBorderColor;

  /// Color for the dropdown icon.
  final Color iconColor;

  /// Background color for the selected item in the dropdown list.
  final Color selectedItemColor;

  const CustomDropdown({
    Key? key,
    required this.items,
    required this.selectedItem,
    required this.onItemSelected,
    required this.itemLabelBuilder,
    this.itemIdBuilder,
    this.hintText = "Select an item",
    this.maxDropdownHeight = 250,
    this.itemTextStyle,
    this.hintTextStyle,
    this.selectedItemTextStyle,
    this.backgroundColor = Colors.white,
    this.dropdownColor = Colors.white,
    this.focusBorderColor = Colors.blue,
    this.iconColor = Colors.grey,
    this.selectedItemColor = Colors.blue,
  }) : super(key: key);

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
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

  bool _itemsEqual(T? item1, T? item2) {
    if (item1 == null || item2 == null) return item1 == item2;

    if (widget.itemIdBuilder != null) {
      return widget.itemIdBuilder!(item1) == widget.itemIdBuilder!(item2);
    }

    return item1 == item2;
  }

  void _showDropdown() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, size.height),
            child: Material(
              elevation: 4,
              color: widget.dropdownColor,
              borderRadius: BorderRadius.circular(8.r),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                constraints: BoxConstraints(
                  maxHeight: widget.maxDropdownHeight.h,
                ),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.items[index];
                    final isSelected = _itemsEqual(item, widget.selectedItem);

                    return InkWell(
                      onTap: () {
                        widget.onItemSelected(item);
                        setState(() {
                          _isDropdownOpen = false;
                        });
                        _removeOverlay();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                        color: isSelected ? widget.selectedItemColor.withOpacity(0.2) : Colors.transparent,
                        child: Text(
                          widget.itemLabelBuilder(item),
                          style: widget.itemTextStyle ??
                              TextStyle(
                                fontSize: 14.sp,
                              ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: _isDropdownOpen ? widget.focusBorderColor : Colors.transparent,
              width: _isDropdownOpen ? 0.5 : 0.1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.selectedItem != null ? widget.itemLabelBuilder(widget.selectedItem!) : widget.hintText,
                  style: widget.selectedItem != null ? (widget.selectedItemTextStyle ?? TextStyle(fontSize: 14.sp)) : (widget.hintTextStyle ?? TextStyle(fontSize: 14.sp, color: Colors.grey)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                _isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: widget.iconColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Example usage with GiftCardCountry
Widget buildGiftCardCountryDropdown(BuildContext context) {
  return Consumer<BillPaymentProvider>(builder: (context, provider, _) {
    return CustomDropdown<GiftCardCountry>(
      items: provider.giftCardCountries.value,
      selectedItem: provider.selectedGiftCardCountry,
      onItemSelected: (GiftCardCountry country) {
        provider.selectedGiftCardCountry = country;
        Provider.of<BillPaymentProvider>(context, listen: false).fetchGiftCardsByCountry();
      },
      itemLabelBuilder: (country) => country.name ?? "",
      itemIdBuilder: (country) => country.name,
      hintText: "Choose Country",
      backgroundColor: CustomColors.sDarkColor2,
      dropdownColor: CustomColors.sDarkColor2,
      focusBorderColor: CustomColors.sPrimaryColor500,
      iconColor: CustomColors.sDisableButtonColor,
      selectedItemColor: CustomColors.sPrimaryColor500,
      selectedItemTextStyle: CustomTextStyle.kTxtRegular.copyWith(
        color: CustomColors.sWhiteColor,
        fontSize: 14.sp,
      ),
      hintTextStyle: CustomTextStyle.kTxtRegular.copyWith(
        color: CustomColors.sGreyScaleColor500,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      itemTextStyle: CustomTextStyle.kTxtRegular.copyWith(
        color: CustomColors.sWhiteColor,
        fontSize: 14.sp,
      ),
    );
  });
}
