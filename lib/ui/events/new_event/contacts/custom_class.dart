
import 'package:contacts_service_plus/contacts_service_plus.dart';

class CustomContact {
  final Contact contact;
  bool isChecked;

  CustomContact({required this.contact, this.isChecked = false,});
}