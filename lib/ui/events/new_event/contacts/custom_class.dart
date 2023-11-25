
import 'package:contacts_service/contacts_service.dart';

class CustomContact {
  final Contact contact;
  bool isChecked;

  CustomContact({required this.contact, this.isChecked = false,});
}