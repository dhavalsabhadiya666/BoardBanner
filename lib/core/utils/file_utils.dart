part of 'utils.dart';

class FileUtils {
  FileUtils._();

  static final _picker = ImagePicker();

  static Future<File?> pickImage(ImageSource source) async {
    bool granted = false;

    try {
      if (source == ImageSource.camera) {
        granted = await Permission.camera.request().isGranted;
      } else {
        if (Platform.isIOS) {
          granted = await Permission.photos.request().isGranted;
        } else {
          granted = await Permission.storage.request().isGranted;
        }
      }

      if (granted) {
        XFile? xFile = await _picker.pickImage(source: source);
        if (xFile != null) {
          return File(xFile.path);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<File?> pickVideo(ImageSource source) async {
    bool granted = false;

    try {
      if (source == ImageSource.camera) {
        granted = await Permission.camera.request().isGranted;
      } else {
        if (Platform.isIOS) {
          granted = await Permission.photos.request().isGranted;
        } else {
          granted = await Permission.storage.request().isGranted;
        }
      }

      if (granted) {
        XFile? xFile = await _picker.pickVideo(source: source);

        if (xFile != null) {
          return File(xFile.path);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<Uint8List?> getVideoThumbnail(File file) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: file.path,
      quality: 80,
    );
    return uint8list;
  }
}
