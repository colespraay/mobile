// import 'package:contacts_service/contacts_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> _askPermissions(BuildContext context, Function(String)? function) async {
  PermissionStatus permissionStatus = await _getContactPermission();
  print(permissionStatus.name);
  if (permissionStatus == PermissionStatus.granted) {
    final Contact? contact = await FlutterContacts.openExternalPick();

    if (contact != null) {
      function!(contact.phones[0].number.toString().stripInternationalNumbers()!.replaceAll(" ", "").toString());
    }
  } else {
    print("_handleInvalidPermissions");
    _handleInvalidPermissions(permissionStatus, context);
  }
}

extension on String {
  String? stripInternationalNumbers() => isNotEmpty
      ? contains("+234")
          ? replaceAll("+234", "0")
          : this
      : "";
}

Future<PermissionStatus> _getContactPermission() async {
  print("_getContactPermission");
  PermissionStatus permission = await Permission.contacts.status;
  if (permission != PermissionStatus.granted && permission != PermissionStatus.permanentlyDenied) {
    PermissionStatus permissionStatus = await Permission.contacts.request();

    print(permissionStatus.name);
    return permissionStatus;
  } else {
    return permission;
  }
}

void _handleInvalidPermissions(PermissionStatus permissionStatus, BuildContext context) {
  if (permissionStatus == PermissionStatus.denied) {
    const snackBar = SnackBar(content: Text('Access to contact data denied'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
    const snackBar = SnackBar(content: Text('Contact data not available on device'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

void openContactPicker({required BuildContext context, Function? function}) async {
  print("openContactPicker");
  try {
    await _askPermissions(
        context,
        (c) => {
              function!(c),
            });
  } catch (e) {
    debugPrint(e.toString());
  }
}

class ContactPickerIcon extends StatelessWidget {
  Function? function;
  final Widget Function(BuildContext context)? builder;

  ContactPickerIcon({Key? key, this.function, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        openContactPicker(context: context, function: (c) => function!(c));
      },
      child: builder != null
          ? builder!(context)
          : Icon(
              Icons.account_circle,
              color: Theme.of(context).colorScheme.primary,
              size: 24.h,
            ),
    );
  }
}
