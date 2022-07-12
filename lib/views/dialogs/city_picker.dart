part of 'app_dialogs.dart';

class _CityPicker extends StatefulWidget {
  final List<City> cities;

  const _CityPicker({Key? key, required this.cities}) : super(key: key);

  static Future<City?> showSheet(
      BuildContext context, List<City> cities) async {
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
        return _CityPicker(cities: cities);
      },
    );
  }

  @override
  State<_CityPicker> createState() => _CityPickerState();
}

class _CityPickerState extends State<_CityPicker> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenUtil().screenHeight * 0.6,
      child: Column(
        children: [
          const DialogHeader(title: 'Select City'),
          Expanded(
            child: ListView.builder(
              itemCount: widget.cities.length,
              itemBuilder: (context, index) {
                var state = widget.cities[index];
                return ListTile(
                  title: Text(state.cityName ?? ''),
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
