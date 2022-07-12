part of 'app_dialogs.dart';

class _StatePicker extends StatefulWidget {
  final List<Land> states;

  const _StatePicker({Key? key, required this.states}) : super(key: key);

  static Future<Land?> showSheet(
      BuildContext context, List<Land> states) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 0,
      backgroundColor: Colors.white,
      barrierColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kDialogBorderRadius),
      ),
      builder: (context) {
        return _StatePicker(states: states);
      },
    );
  }

  @override
  State<_StatePicker> createState() => _StatePickerState();
}

class _StatePickerState extends State<_StatePicker> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenUtil().screenHeight * 0.6,
      child: Column(
        children: [
          const DialogHeader(title: 'Select State'),
          Expanded(
            child: ListView.builder(
              itemCount: widget.states.length,
              itemBuilder: (context, index) {
                var state = widget.states[index];
                return ListTile(
                  title: Text(state.stateName ?? ''),
                  onTap: () {
                    Navigator.pop(context, state);
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
