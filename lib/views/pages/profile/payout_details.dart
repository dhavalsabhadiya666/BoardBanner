import 'package:adscope/core/constants/constants.dart';
import 'package:adscope/core/enums/enums.dart';
import 'package:adscope/core/utils/utils.dart';
import 'package:adscope/models/models.dart';
import 'package:adscope/services/services.dart';
import 'package:adscope/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:adscope/providers/providers.dart';

class PayoutDetailsPage extends StatefulWidget {
  const PayoutDetailsPage({Key? key}) : super(key: key);

  @override
  State<PayoutDetailsPage> createState() => _PayoutDetailsPageState();
}

class _PayoutDetailsPageState extends State<PayoutDetailsPage> {
  //
  PayoutType? _payoutType = PayoutType.bankTransfer;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // For Bank Transfer
  final TextEditingController _bankName = TextEditingController();
  final TextEditingController _holderName = TextEditingController();
  final TextEditingController _accountNumber = TextEditingController();
  final TextEditingController _ifscCode = TextEditingController();
  final TextEditingController _branchName = TextEditingController();

  // For Paypal
  final TextEditingController _paypalId = TextEditingController();

  Future<void> _savePayoutDetailsHandler() async {
    var userProvider = context.read<UserProvider>();

    if (_formKey.currentState!.validate()) {
      if (await ConnectivityService.isConnected) {
        if (isPaypalPayout) {
          userProvider
              .savePayPalId(context, _paypalId.text.trim())
              .whenComplete(_saveHandler);
        } else {
          BankDetails bankDetails = BankDetails();
          bankDetails.bankName = _bankName.text.trim();
          bankDetails.accountHolderName = _holderName.text.trim();
          bankDetails.accountNumber = _accountNumber.text.trim();
          bankDetails.ifscCode = _ifscCode.text.trim();
          bankDetails.branchName = _branchName.text.trim();
          userProvider
              .saveBankDetails(context, bankDetails)
              .whenComplete(_saveHandler);
        }
      } else {
        SnackUtils(context).showSnakBar(noConnectionMessage);
      }
    }
  }

  void _saveHandler() {
    Navigator.pop(context);
    SnackUtils(context).showSnakBar('Payout details saved successfully');
  }

  bool get isPaypalPayout => _payoutType == PayoutType.paypal;

  @override
  void initState() {
    super.initState();
    var user = context.read<UserProvider>().user;
    var bankDetails = user?.bankDetails;

    _bankName.text = bankDetails?.bankName ?? '';
    _accountNumber.text = bankDetails?.accountNumber ?? '';
    _ifscCode.text = bankDetails?.ifscCode ?? '';
    _branchName.text = bankDetails?.branchName ?? '';
    _holderName.text = bankDetails?.accountHolderName ?? '';
    _paypalId.text = user?.paypalId ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.backAppBar(context, title: 'Payout'),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildPayoutMethods(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: kPadding),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  children: [
                    SizedBox(height: Sizes.s20.h),
                    WidgetDelegate(
                      shouldShowPrimary: isBankTransfer,
                      primaryWidget: () {
                        return _buildBankDetailsForm();
                      },
                      alternateWidget: () {
                        return PrimaryTextField(
                          labelText: 'Paypal Id',
                          controller: _paypalId,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Paypal Id is required';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    SizedBox(height: Sizes.s40.h),
                    PrimaryButton(
                      label: 'Confirm',
                      onPressed: _savePayoutDetailsHandler,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: Sizes.s20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPayoutMethods() {
    return Row(
      children: PayoutType.values.map(
        (type) {
          return Expanded(
            child: RadioListTile(
              contentPadding: EdgeInsets.zero,
              activeColor: AppColors.primary,
              selected: _payoutType == type,
              value: type,
              title: Text(
                payoutTypeName[type] ?? '',
                style: TextStyle(
                  fontSize: Sizes.s16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              groupValue: _payoutType,
              onChanged: (PayoutType? value) {
                setState(() {
                  _payoutType = value;
                });
              },
            ),
          );
        },
      ).toList(),
    );
  }

  Widget _buildBankDetailsForm() {
    return Column(
      children: [
        PrimaryTextField(
          labelText: 'Bank Name',
          controller: _bankName,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Bank Name is required';
            }
            return null;
          },
        ),
        SizedBox(height: Sizes.s20.h),
        PrimaryTextField(
          labelText: 'Account Holder Name',
          controller: _holderName,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Account Holder Name is required';
            }
            return null;
          },
        ),
        SizedBox(height: Sizes.s20.h),
        PrimaryTextField(
          labelText: 'Acount Number',
          controller: _accountNumber,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Acount Number is required';
            }
            return null;
          },
        ),
        SizedBox(height: Sizes.s20.h),
        PrimaryTextField(
          labelText: 'IFSC Code',
          controller: _ifscCode,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'IFSC Code is required';
            }
            return null;
          },
        ),
        SizedBox(height: Sizes.s20.h),
        PrimaryTextField(
          labelText: 'Branch Name',
          controller: _branchName,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Branch Name is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  bool get isBankTransfer => _payoutType == PayoutType.bankTransfer;
}
