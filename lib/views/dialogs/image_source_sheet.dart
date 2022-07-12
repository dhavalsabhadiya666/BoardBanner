part of 'app_dialogs.dart';

class _ImageSourceSheet extends StatelessWidget {
  const _ImageSourceSheet({Key? key}) : super(key: key);

  static Future<File?> showSheet(BuildContext context) async {
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
        return const _ImageSourceSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const DialogHeader(title: 'Select Option'),
          _buildListTile(
            icon: Icons.image_rounded,
            title: 'Gallery',
            onTap: () async {
              File? file = await FileUtils.pickImage(ImageSource.gallery);
              Navigator.pop(context, file);
            },
          ),
          _buildListTile(
            icon: Icons.camera_alt_rounded,
            title: 'Camera',
            onTap: () async {
              File? file = await FileUtils.pickImage(ImageSource.camera);
              Navigator.pop(context, file);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        size: Sizes.s24.h,
        color: AppColors.secondary,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: Sizes.s16.sp,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
      onTap: onTap,
    );
  }
}
