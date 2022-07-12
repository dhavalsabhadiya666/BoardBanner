part of 'app_dialogs.dart';

class _BillBoardDetailsDailog extends StatefulWidget {
  const _BillBoardDetailsDailog({Key? key}) : super(key: key);

  static Future<bool?> show(BuildContext context) async {
    return await showCupertinoDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: const _BillBoardDetailsDailog(),
        );
      },
    );
  }

  @override
  State<_BillBoardDetailsDailog> createState() =>
      _BillBoardDetailsDailogState();
}

class _BillBoardDetailsDailogState extends State<_BillBoardDetailsDailog> {
  //
  bool _dontShowAgain = false;

  List<String> details = [
    'Take note on which way you need to approach the billboard for a successful video capture.',
    ' Videos can not appear to be taken from the driver\'s seat.',
    'Once you accept a billboard task, you have 24 hours to complete the job or it will be relisted'
  ];

  @override
  void initState() {
    super.initState();
    _dontShowAgain = PreferencesService.pref
            ?.getBool(Preferences.doNotShowAgainBillBoardsDetails) ??
        false;
  }

  void _onChanged(bool? value) {
    PreferencesService.pref
        ?.setBool(Preferences.doNotShowAgainBillBoardsDetails, value ?? false);

    setState(() {
      _dontShowAgain = PreferencesService.pref
              ?.getBool(Preferences.doNotShowAgainBillBoardsDetails) ??
          false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Sizes.s14.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Billboards Details',
              style: TextStyle(
                fontSize: Sizes.s16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          Divider(
            color: const Color(0xffF2F2F2),
            height: 0,
            thickness: Sizes.s1.h,
          ),
          SizedBox(height: Sizes.s10.h),
          Column(
            children: List.generate(
              details.length,
              (index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: Sizes.s10.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '•',
                        style: TextStyle(
                          fontSize: Sizes.s12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      SizedBox(width: Sizes.s4.h),
                      Expanded(
                        child: Text(
                          details[index],
                          style: TextStyle(
                            fontSize: Sizes.s12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: Sizes.s10.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: Sizes.s20.h,
                width: Sizes.s20.h,
                child: Checkbox(
                  value: _dontShowAgain,
                  activeColor: Colors.green,
                  onChanged: _onChanged,
                ),
              ),
              SizedBox(width: Sizes.s10.h),
              Text(
                'Do not show again',
                style: TextStyle(
                  fontSize: Sizes.s12.h,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
          SizedBox(height: Sizes.s20.h),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: 'Ignore',
                  isOutlined: true,
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
              ),
              SizedBox(width: Sizes.s20.h),
              Expanded(
                child: PrimaryButton(
                  label: 'Accept',
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: Sizes.s16.h),
        ],
      ),
    );
  }
}
