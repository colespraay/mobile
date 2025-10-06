import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:provider/provider.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/models/giftcard/giftcard-categories.dart';
import 'package:spraay/models/result-model.dart';
import 'package:spraay/services/api_response.dart';
import 'package:spraay/ui/others/bill_payments/giftcard/widgets/dropdown.dart';
import 'package:spraay/ui/others/bill_payments/giftcard/widgets/giftcard-display-widget.dart';
import 'package:spraay/utils/debounce.dart';
import 'package:spraay/view_model/bill_payment_provider.dart';

class GiftCardPage extends StatefulWidget {
  String title;
  GiftCardPage({super.key, required this.title});
  // const CableSubscriptionscreen({Key? key}) : super(key: key);

  @override
  State<GiftCardPage> createState() => _GiftCardPageState();
}

class _GiftCardPageState extends State<GiftCardPage> {
  final GlobalKey<FormState> _myKey = GlobalKey<FormState>();
  TextEditingController countryController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  FocusNode? _textField1Focus;

  FocusNode? _textField2Focus;

  FocusNode? _textField3Focus;
  final Debounce _debouncer = Debounce();

  @override
  void initState() {
    setState(() {
      _textField1Focus = FocusNode();
      _textField2Focus = FocusNode();
      _textField3Focus = FocusNode();
    });
  }

  @override
  void dispose() {
    _debouncer.cancel();
    _textField1Focus?.dispose();
    _textField2Focus?.dispose();
    countryController.dispose();
    _textField3Focus?.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayWidget(
      loading: Provider.of<BillPaymentProvider>(context, listen: true).giftCardLoading,
      child: Scaffold(
          appBar: buildAppBar(context: context, title: "GiftCard"),
          body: Form(
            key: _myKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: giftCardBody(),
          )),
    );
  }

  Widget giftCardBody() {
    return ListView(
      padding: horizontalPadding,
      shrinkWrap: true,
      children: [
        Consumer<BillPaymentProvider>(builder: (context, provider, widget) {
          return CustomizedTextField(
            textEditingController: searchController,
            textInputAction: TextInputAction.next,
            hintTxt: "Search",
            focusNode: _textField1Focus,
            onChanged: (value) {
              provider.setQuery(value);
              if (value.length > 2) {
                _debouncer(() {
                  provider.fetchGiftCardsBySearch();
                });
                // fetchTransactionPinApi(context, value);
              }
            },
            surffixWidget: (provider.giftCardQuery != null && provider.giftCardQuery!.isNotEmpty)
                ? GestureDetector(
                    onTap: () {
                      searchController.clear();
                      provider.giftCardQuery = null;
                      provider.fetchGiftCardsByCountry(showLoading: true);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: const Icon(Icons.close))
                : const SizedBox.shrink(),
          );
        }),
        height20,
        buildGiftCardCountryDropdown(),
        height20,
        Consumer<BillPaymentProvider>(builder: (context, provider, widget) {
          return ValueListenableBuilder(
            valueListenable: provider.selectedGiftCardCategory,
            builder: (context, vu, _) => GiftCardCategoryWidget(
                categories: provider.giftCardCategories.value,
                onSelected: (v) {
                  if (v.id == provider.selectedGiftCardCategory.value?.id) {
                    provider.selectedGiftCardCategory.value = null;
                    provider.fetchGiftCardsByCountry(showLoading: true);
                  } else {
                    provider.selectedGiftCardCategory.value = v;
                    provider.fetchGiftCardsByCategories();
                  }
                },
                value: vu),
          );
        }),
        height20,
        Consumer<BillPaymentProvider>(builder: (context, provider, widget) {
          return ValueListenableBuilder(
            valueListenable: provider.giftCards,
            builder: (context, list, _) => Wrap(
              alignment: WrapAlignment.spaceAround,
              children: list.map((e) => GiftCardDisplayWidget(card: e)).toList(),
            ),
          );
        }),
        height20,
        height34,
      ],
    );
  }
}

class GiftCardCategoryWidget extends StatelessWidget {
  final List<GiftCardCategories> categories;
  final Function(GiftCardCategories) onSelected;
  GiftCardCategories? value;
  GiftCardCategoryWidget({super.key, this.categories = const [], required this.onSelected, this.value});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: categories
            .map((e) => GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onSelected(e),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(
                      color: value == e ? const Color(0xFF335EF740).withOpacity(0.25) : const Color(0xff1A1A21),
                      border: Border.all(color: value == e ? Colors.white : Colors.transparent),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Text(
                      e.name ?? "",
                      style: TextStyle(color: value == e ? Colors.white : const Color(0xff9E9E9E), fontWeight: FontWeight.w500, fontSize: 14.sp),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

handleError(BuildContext context, ApiResponse<ResModel> res, {required Function() onDone}) {
  if (res.error == true) {
    if (context.mounted) {
      popupDialog(
          context: context,
          title: "Request Failed",
          content: res.errorMessage ?? "",
          buttonTxt: 'Try again',
          onTap: () {
            Navigator.pop(context);
          },
          png_img: 'Incorrect_sign');
    }
  } else {
    onDone;
  }
}
