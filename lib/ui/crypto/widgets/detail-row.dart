// Detail Row Component
import 'package:flutter/material.dart';

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  DetailRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Flexible(
            child: Text(
              value,
              // maxLines: 1,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
