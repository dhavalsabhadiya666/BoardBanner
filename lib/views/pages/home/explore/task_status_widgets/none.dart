part of 'task_status_widgets.dart';

class TaskStatusNone extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String>? onChanged;
  final Function(int) onTabChanged;
  final VoidCallback? onFilter;

  final bool isSearch;
  final List<Place> places;
  final Function(Place) onPlaceSelected;

  const TaskStatusNone({
    Key? key,
    required this.searchController,
    required this.onChanged,
    required this.onTabChanged,
    this.onFilter,
    required this.isSearch,
    required this.places,
    required this.onPlaceSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var taskProvider = context.read<TaskProvider>();

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(kPadding),
          child: Column(
            children: [
              SizedBox(height: Sizes.s20.h),
              Row(
                children: [
                  _buildSearchBox(),
                  SizedBox(width: Sizes.s20.w),
                  _buildFilterButton(),
                ],
              ),
              SizedBox(height: Sizes.s20.h),
              WidgetDelegate(
                shouldShowPrimary: searchController.text.isEmpty,
                primaryWidget: () {
                  return AppTabBar(
                    initialIndex: taskProvider.isMapView ? 0 : 1,
                    tabs: const {0: 'Map View', 1: 'List View'},
                    onTabChanged: onTabChanged,
                  );
                },
                alternateWidget: () {
                  return _PlacesListView(
                    places: places,
                    onPlaceSelected: onPlaceSelected,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Expanded(
      child: Container(
        height: Sizes.s44.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Sizes.s8.h),
          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5)],
        ),
        child: TextField(
          controller: searchController,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: 'Search ...',
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.darkGrey.withOpacity(0.5),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return GestureDetector(
      onTap: onFilter,
      child: Container(
        height: Sizes.s44.h,
        width: Sizes.s44.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Sizes.s8.h),
          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5)],
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          AppAssets.filter,
          height: Sizes.s20.h,
          width: Sizes.s20.h,
        ),
      ),
    );
  }
}

class _PlacesListView extends StatelessWidget {
  final List<Place> places;
  final Function(Place) onPlaceSelected;

  const _PlacesListView({
    Key? key,
    required this.places,
    required this.onPlaceSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight / 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Sizes.s8.h),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5)],
      ),
      child: WidgetDelegate(
        shouldShowPrimary: places.isNotEmpty,
        primaryWidget: () {
          return ListView.builder(
            itemCount: places.length,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              final place = places[index];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: Sizes.s2.h),
                child: ListTile(
                  onTap: () {
                    onPlaceSelected(place);
                  },
                  dense: true,
                  title: Text(
                    place.description ?? '',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Sizes.s14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    place.secondaryText ?? '',
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: Sizes.s12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          );
        },
        alternateWidget: () {
          return SizedBox(
            height: ScreenUtil().screenHeight * 0.2,
            width: ScreenUtil().screenWidth,
            child: Center(
              child: Text(
                'Result not found',
                style: TextStyle(
                  fontSize: Sizes.s14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
