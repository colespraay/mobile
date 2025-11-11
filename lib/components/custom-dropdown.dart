import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GenericDropdown<T> extends StatefulWidget {
  final List<T> items;
  final String hintText;
  final String Function(T item) displayText;
  final void Function(T selected)? onSelected;
  final Color? dropdownColor;
  final Color? textColor;
  final double? width;

  const GenericDropdown({
    Key? key,
    required this.items,
    required this.displayText,
    this.onSelected,
    this.hintText = "Select an item",
    this.dropdownColor,
    this.textColor,
    this.width,
  }) : super(key: key);

  @override
  State<GenericDropdown<T>> createState() => _GenericDropdownState<T>();
}

class _GenericDropdownState<T> extends State<GenericDropdown<T>> {
  T? selectedItem;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: selectedItem,
      dropdownColor: widget.dropdownColor ?? Colors.grey[850],
      iconEnabledColor: Colors.grey,
      focusColor: Colors.transparent,
      isDense: false,
      decoration: _buildInputDecoration(widget.hintText),
      items: widget.items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: SizedBox(
            width: widget.width ?? 290.w,
            child: Text(
              widget.displayText(item),
              style: TextStyle(
                color: widget.textColor ?? Colors.white,
                fontSize: 14.sp,
              ),
            ),
          ),
        );
      }).toList(),
      onChanged: (T? newValue) {
        if (newValue == null) return;
        setState(() => selectedItem = newValue);
        widget.onSelected?.call(newValue);
      },
    );
  }

  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
      hintText: hintText,
      isDense: true,
      fillColor: Colors.grey[850],
      filled: true,
      hintStyle: TextStyle(
        color: Colors.grey[500],
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent, width: 0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 0.5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 0.2.w),
        borderRadius: BorderRadius.circular(8.r),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueAccent, width: 0.2.w),
        borderRadius: BorderRadius.circular(8.r),
      ),
    );
  }
}
