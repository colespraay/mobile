// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:contacts_service/contacts_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// // import 'package:fluttercontactpicker/fluttercontactpicker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:spraay/components/constant.dart';
// import 'package:spraay/components/reusable_widget.dart';
// import 'package:spraay/components/themes.dart';
// import 'package:spraay/models/user_name_with_phone_contact_model.dart';
// import 'package:spraay/ui/events/new_event/contacts/custom_class.dart';
// import 'package:spraay/view_model/event_provider.dart';
//
// class PhoneContacts extends StatefulWidget {
//   const PhoneContacts({Key? key}) : super(key: key);
//
//   @override
//   State<PhoneContacts> createState() => _PhoneContactsState();
// }
//
// class _PhoneContactsState extends State<PhoneContacts> {
//   // EventProvider? eventProvider;
//   late EventProvider eventProvider;
//   // @override
//   // void didChangeDependencies() {
//   //   eventProvider = context.watch<EventProvider>();
//   //   super.didChangeDependencies();
//   // }
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     eventProvider = Provider.of<EventProvider>(context);
//   }
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   // Provider.of<EventProvider>(context, listen: false).fetchUserDetailApi(context);
//   //   _askPermissions();
//   // }
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _askPermissions();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return LoadingOverlayWidget(
//       loading: eventProvider?.loading ?? false,
//       child: SafeArea(
//         child: Scaffold(
//           appBar: buildAppBar(context: context, title: "Share Event"),
//           body: Builder(builder: (context) {
//             if (_isLoading == true) {
//               return const LoadingWidget();
//             } else {
//               return Stack(
//                 children: [
//                   Positioned(
//                     left: 0.w,
//                     right: 0.w,
//                     top: 1.h,
//                     bottom: 1.h,
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: eventProvider?.userPhoneContactData.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         return Padding(
//                           padding: EdgeInsets.only(bottom: 10.h),
//                           child: _buildListTile(eventProvider?.userPhoneContactData[index], index),
//                         );
//                       },
//                     ),
//                   ),
//                   Positioned(
//                     left: 24.w,
//                     right: 24.w,
//                     bottom: 24.h,
//                     child: CustomButton(
//                         onTap: () {
//                           if (selectedIndex.isNotEmpty) {
//                             eventProvider?.fetchSendInviteApi(context, eventProvider?.eventId ?? "", selectedIndex, selectedName);
//                           }
//                         },
//                         buttonText: 'Send(${selectedIndex.length})',
//                         borderRadius: 30.r,
//                         width: 380.w,
//                         buttonColor: selectedIndex.isNotEmpty ? CustomColors.sPrimaryColor500 : CustomColors.sDisableButtonColor),
//                   ),
//                 ],
//               );
//             }
//           }),
//         ),
//       ),
//     );
//   }
//
//   List<String> selectedIndex = [];
//   List<String> selectedName = [];
//
//   ListTile _buildListTile(UserPhoneWithNameContactDatum? userInformationList, int position) {
//     return ListTile(
//       leading: CircleAvatar(
//         radius: 28.r,
//         child: CachedNetworkImage(
//           width: 28.w,
//           height: 28.h,
//           imageUrl: userInformationList?.profileImageUrl ?? "",
//           placeholder: (context, url) => const Center(
//               child: SpinKitFadingCircle(
//             size: 30,
//             color: Colors.grey,
//           )),
//           errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
//         ),
//       ),
//       title: Text(
//         "${userInformationList?.firstName ?? ""} ${userInformationList?.lastName ?? ""}",
//         style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400, color: CustomColors.sWhiteColor),
//       ),
//       trailing: Checkbox(
//           activeColor: CustomColors.sPrimaryColor500,
//           value: selectedIndex.contains(userInformationList?.id ?? ""),
//           onChanged: (bool? value) {
//             setState(() {
//               if (selectedIndex.contains(userInformationList?.id ?? "")) {
//                 selectedIndex.remove(userInformationList?.id ?? ""); //
//                 selectedName.remove(userInformationList?.firstName ?? "");
//               } else {
//                 selectedIndex.add(userInformationList?.id ?? "");
//                 selectedName.add(userInformationList?.firstName ?? "");
//               }
//             });
//           }),
//     );
//   }
//
//   // Future<void> _askPermissions() async {
//   //   PermissionStatus permissionStatus = await _getContactPermission();
//   //   if (permissionStatus == PermissionStatus.granted) {
//   //     refreshContacts();
//   //   } else {
//   //     _handleInvalidPermissions(permissionStatus);
//   //   }
//   // }
//   Future<void> _askPermissions() async {
//     PermissionStatus status = await _getContactPermission();
//
//     if (status == PermissionStatus.granted) {
//       refreshContacts();
//     } else {
//       setState(() => _isLoading = false); // ← FIX
//       _handleInvalidPermissions(status);
//     }
//   }
//
//   Future<PermissionStatus> _getContactPermission() async {
//     PermissionStatus permission = await Permission.contacts.status;
//     if (permission != PermissionStatus.granted && permission != PermissionStatus.permanentlyDenied) {
//       PermissionStatus permissionStatus = await Permission.contacts.request();
//       return permissionStatus;
//     } else {
//       return permission;
//     }
//   }
//
//   void _handleInvalidPermissions(PermissionStatus permissionStatus) {
//     if (permissionStatus == PermissionStatus.denied) {
//       const snackBar = SnackBar(content: Text('Access to contact data denied'));
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//     } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
//       const snackBar = SnackBar(content: Text('Contact data not available on device'));
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//     }
//   }
//
//   List<Contact> _contacts = [];
//   List<CustomContact> _uiCustomContacts = [];
//   List<CustomContact> _allContacts = [];
//   bool _isLoading = false;
//   bool _isSelectedContactsView = false;
//   List<String> _phoneNumberList = [];
//   List<CustomContact> _myselectedContacts = [];
//
// // List<UserPhoneWithNameContact> userPhoneWithNameContacts=[];
//   List<Map<String, String?>> userPhoneWithNameContacts = [];
//
//   refreshContacts() async {
//     try {
//       setState(() {
//         _isLoading = true;
//       });
//       var contacts = await ContactsService.getContacts();
//       _populateContacts(contacts);
//     } catch (e) {
//       print(e.toString());
//     }
//   }
//
//   void _populateContacts(Iterable<Contact> contacts) {
//     print('populating contacts');
//     print(_contacts.length);
//     _contacts = contacts.where((item) => item.displayName != null).toList();
//     _contacts.sort((a, b) => a.displayName!.compareTo(b.displayName ?? ""));
//     _allContacts = _contacts.map((contact) => CustomContact(contact: contact)).toList();
//     setState(() {
//       _uiCustomContacts = _allContacts;
//
//       userPhoneWithNameContacts = _allContacts
//           .map((contact) => {
//                 'name': contact.contact.displayName?.replaceAll(" ", "").replaceAll("+234", "0").replaceAll("-", "") ?? "",
//                 'phoneNumber': contact.contact.phones!.isEmpty ? "" : contact.contact.phones?[0].value?.replaceAll(" ", "").replaceAll("+234", "0").replaceAll("-", "") ?? "",
//               })
//           .toList();
//       _isLoading = false;
//     });
//
//     Provider.of<EventProvider>(context, listen: false).fetchUserContactApi(userPhoneWithNameContacts);
//   }
// }
//
// class LoadingWidget extends StatelessWidget {
//   const LoadingWidget({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//         child: Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         SpinKitFadingCircle(size: 50.r, color: CustomColors.sPrimaryColor500),
//         height4,
//         Text(
//           "Loading...",
//           style: CustomTextStyle.kTxtRegular.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400, color: CustomColors.sWhiteColor),
//         ),
//       ],
//     ));
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/components/themes.dart';
import 'package:spraay/models/user_name_with_phone_contact_model.dart';
import 'package:spraay/view_model/event_provider.dart';

class PhoneContacts extends StatefulWidget {
  const PhoneContacts({Key? key}) : super(key: key);

  @override
  State<PhoneContacts> createState() => _PhoneContactsState();
}

class _PhoneContactsState extends State<PhoneContacts> {
  final Set<String> _selectedUserIds = {};
  final Set<String> _selectedUserNames = {};
  bool _isLoadingContacts = false;
  String _debugMessage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestContactsPermission();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, eventProvider, _) {
        debugPrint('🔍 EventProvider contacts count: ${eventProvider.userPhoneContactData.length}');

        return LoadingOverlayWidget(
          loading: eventProvider.loading,
          child: Scaffold(
            appBar: buildAppBar(context: context, title: "Share Event"),
            body: _buildBody(eventProvider),
          ),
        );
      },
    );
  }

  Widget _buildBody(EventProvider eventProvider) {
    // Show loading state
    if (_isLoadingContacts) {
      return _LoadingWidget(message: _debugMessage);
    }

    final contacts = eventProvider.userPhoneContactData;

    debugPrint('📱 Building body with ${contacts.length} contacts');

    // Show empty state
    if (contacts.isEmpty && !_isLoadingContacts) {
      return _EmptyContactsWidget(
        debugMessage: _debugMessage,
        onRetry: _requestContactsPermission,
      );
    }

    return Column(
      children: [
        // Debug info banner (remove in production)
        if (_debugMessage.isNotEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.h),
            color: Colors.orange.withOpacity(0.2),
            child: Text(
              _debugMessage,
              style: TextStyle(fontSize: 10.sp, color: Colors.orange),
              textAlign: TextAlign.center,
            ),
          ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            itemCount: contacts.length,
            separatorBuilder: (_, __) => SizedBox(height: 8.h),
            itemBuilder: (context, index) {
              return _ContactListTile(
                contact: contacts[index],
                isSelected: _selectedUserIds.contains(contacts[index].id),
                onSelectionChanged: (isSelected) {
                  _handleContactSelection(contacts[index], isSelected);
                },
              );
            },
          ),
        ),
        _SendButton(
          selectedCount: _selectedUserIds.length,
          onSend: _handleSendInvites,
        ),
      ],
    );
  }

  void _handleContactSelection(
    UserPhoneWithNameContactDatum contact,
    bool isSelected,
  ) {
    setState(() {
      final userId = contact.id ?? '';
      final firstName = contact.firstName ?? '';

      if (isSelected) {
        _selectedUserIds.add(userId);
        _selectedUserNames.add(firstName);
      } else {
        _selectedUserIds.remove(userId);
        _selectedUserNames.remove(firstName);
      }
    });
  }

  Future<void> _handleSendInvites() async {
    if (_selectedUserIds.isEmpty) return;

    final eventProvider = context.read<EventProvider>();
    final eventId = eventProvider.eventId ?? '';

    await eventProvider.fetchSendInviteApi(
      context,
      eventId,
      _selectedUserIds.toList(),
      _selectedUserNames.toList(),
    );
  }

  // ========== Permission Handling ==========

  Future<void> _requestContactsPermission() async {
    setState(() {
      _isLoadingContacts = true;
      _debugMessage = 'Requesting permission...';
    });

    final status = await _getContactsPermissionStatus();
    debugPrint('📋 Permission status: $status');

    if (status == PermissionStatus.granted) {
      await _loadContacts();
    } else {
      setState(() {
        _isLoadingContacts = false;
        _debugMessage = 'Permission denied: $status';
      });
      _showPermissionDeniedMessage(status);
    }
  }

  Future<PermissionStatus> _getContactsPermissionStatus() async {
    PermissionStatus status = await Permission.contacts.status;
    debugPrint('📋 Initial permission status: $status');

    if (status.isDenied) {
      status = await Permission.contacts.request();
      debugPrint('📋 After request permission status: $status');
    }

    return status;
  }

  void _showPermissionDeniedMessage(PermissionStatus status) {
    final String message;

    if (status.isPermanentlyDenied) {
      message = 'Contact permission permanently denied. Please enable it in settings.';
    } else {
      message = 'Contact permission denied';
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(
            label: 'Settings',
            onPressed: () => openAppSettings(),
          ),
        ),
      );
    }
  }

  // ========== Contact Loading ==========

  Future<void> _loadContacts() async {
    setState(() {
      _isLoadingContacts = true;
      _debugMessage = 'Loading device contacts...';
    });

    try {
      debugPrint('📱 Fetching contacts from device...');

      // Fetch contacts with withThumbnails and photoHighResolution set to false for better performance
      final contacts = await ContactsService.getContacts(
        withThumbnails: false,
        photoHighResolution: false,
      );

      debugPrint('📱 Raw contacts fetched: ${contacts.length}');

      if (contacts.isEmpty) {
        setState(() {
          _debugMessage = 'No contacts found on device';
          _isLoadingContacts = false;
        });
        return;
      }

      setState(() {
        _debugMessage = 'Processing ${contacts.length} contacts...';
      });

      final processedContacts = _processContacts(contacts);
      debugPrint('📱 Processed contacts: ${processedContacts.length}');

      if (processedContacts.isEmpty) {
        setState(() {
          _debugMessage = 'No valid contacts after processing';
          _isLoadingContacts = false;
        });
        return;
      }

      // Log first few contacts for debugging
      debugPrint('📱 Sample contacts:');
      for (var i = 0; i < processedContacts.length && i < 3; i++) {
        debugPrint('  - ${processedContacts[i]}');
      }

      setState(() {
        _debugMessage = 'Syncing with server...';
      });

      if (mounted) {
        await context.read<EventProvider>().fetchUserContactApi(
              processedContacts,
            );

        setState(() {
          _debugMessage = 'Sync complete';
        });
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error loading contacts: $e');
      debugPrint('Stack trace: $stackTrace');

      if (mounted) {
        setState(() {
          _debugMessage = 'Error: ${e.toString()}';
          _isLoadingContacts = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load contacts: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingContacts = false);
      }
    }
  }

  List<Map<String, String?>> _processContacts(Iterable<Contact> contacts) {
    debugPrint('🔄 Processing contacts...');

    // Filter out contacts without display names or phone numbers
    final validContacts = contacts.where((contact) {
      final hasName = contact.displayName != null && contact.displayName!.isNotEmpty;
      final hasPhone = contact.phones != null && contact.phones!.isNotEmpty;

      if (!hasName) {
        debugPrint('  ⚠️ Skipping contact without name');
      }
      if (!hasPhone) {
        debugPrint('  ⚠️ Skipping contact without phone: ${contact.displayName}');
      }

      return hasName && hasPhone;
    }).toList();

    debugPrint('📱 Valid contacts (with name and phone): ${validContacts.length}');

    // Sort alphabetically
    validContacts.sort(
      (a, b) => (a.displayName ?? '').toLowerCase().compareTo((b.displayName ?? '').toLowerCase()),
    );

    // Map to required format
    final processed = validContacts.map((contact) {
      final phoneNumber = contact.phones!.first.value ?? '';
      final normalizedPhone = _normalizePhoneString(phoneNumber);
      final normalizedName = _normalizePhoneString(contact.displayName ?? '');

      return {
        'name': normalizedName,
        'phoneNumber': normalizedPhone,
      };
    }).toList();

    debugPrint('✅ Processed ${processed.length} contacts');
    return processed;
  }

  /// Normalize phone numbers and names by removing spaces, dashes, and converting +234 to 0
  String _normalizePhoneString(String value) {
    return value.replaceAll(' ', '').replaceAll('-', '').replaceAll('(', '').replaceAll(')', '').replaceAll('+234', '0');
  }
}

// ========== Contact List Tile Widget ==========

class _ContactListTile extends StatelessWidget {
  final UserPhoneWithNameContactDatum contact;
  final bool isSelected;
  final ValueChanged<bool> onSelectionChanged;

  const _ContactListTile({
    required this.contact,
    required this.isSelected,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onSelectionChanged(!isSelected),
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
          child: Row(
            children: [
              _buildAvatar(),
              SizedBox(width: 12.w),
              Expanded(child: _buildName()),
              _buildCheckbox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 24.r,
      backgroundColor: CustomColors.sPrimaryColor500.withOpacity(0.1),
      child: ClipOval(
        child: CachedNetworkImage(
          width: 48.r,
          height: 48.r,
          imageUrl: contact.profileImageUrl ?? '',
          fit: BoxFit.cover,
          placeholder: (context, url) => SpinKitFadingCircle(
            size: 24.r,
            color: CustomColors.sPrimaryColor500,
          ),
          errorWidget: (context, url, error) => Icon(
            Icons.person,
            size: 24.r,
            color: CustomColors.sPrimaryColor500,
          ),
        ),
      ),
    );
  }

  Widget _buildName() {
    final fullName = '${contact.firstName ?? ''} ${contact.lastName ?? ''}'.trim();

    return Text(
      fullName.isNotEmpty ? fullName : 'Unknown',
      style: CustomTextStyle.kTxtRegular.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: CustomColors.sWhiteColor,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildCheckbox() {
    return Checkbox(
      value: isSelected,
      activeColor: CustomColors.sPrimaryColor500,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.r),
      ),
      onChanged: (value) => onSelectionChanged(value ?? false),
    );
  }
}

// ========== Send Button Widget ==========

class _SendButton extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onSend;

  const _SendButton({
    required this.selectedCount,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = selectedCount > 0;

    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: CustomButton(
        onTap: isEnabled ? onSend : null,
        buttonText: 'Send${selectedCount > 0 ? ' ($selectedCount)' : ''}',
        borderRadius: 30.r,
        width: double.infinity,
        buttonColor: isEnabled ? CustomColors.sPrimaryColor500 : CustomColors.sDisableButtonColor,
      ),
    );
  }
}

// ========== Loading Widget ==========

class _LoadingWidget extends StatelessWidget {
  final String message;

  const _LoadingWidget({this.message = 'Loading contacts...'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitFadingCircle(
            size: 50.r,
            color: CustomColors.sPrimaryColor500,
          ),
          SizedBox(height: 16.h),
          Text(
            message,
            style: CustomTextStyle.kTxtRegular.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: CustomColors.sWhiteColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ========== Empty Contacts Widget ==========

class _EmptyContactsWidget extends StatelessWidget {
  final String debugMessage;
  final VoidCallback onRetry;

  const _EmptyContactsWidget({
    required this.debugMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.contacts_outlined,
              size: 64.r,
              color: CustomColors.sWhiteColor.withOpacity(0.3),
            ),
            SizedBox(height: 16.h),
            Text(
              'No contacts found',
              style: CustomTextStyle.kTxtRegular.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: CustomColors.sWhiteColor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Make sure you have contacts saved on your device\nand have granted permission to access them',
              style: CustomTextStyle.kTxtRegular.copyWith(
                fontSize: 12.sp,
                color: CustomColors.sWhiteColor.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            // if (debugMessage.isNotEmpty) ...[
            //   SizedBox(height: 16.h),
            //   Container(
            //     padding: EdgeInsets.all(12.w),
            //     decoration: BoxDecoration(
            //       color: Colors.orange.withOpacity(0.1),
            //       borderRadius: BorderRadius.circular(8.r),
            //       border: Border.all(color: Colors.orange.withOpacity(0.3)),
            //     ),
            //     child: Text(
            //       'Debug: $debugMessage',
            //       style: TextStyle(
            //         fontSize: 10.sp,
            //         color: Colors.orange,
            //       ),
            //       textAlign: TextAlign.center,
            //     ),
            //   ),
            // ],
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text(
                'Retry',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.sPrimaryColor500,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
