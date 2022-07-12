part of 'providers.dart';

class UploadedTaskProvider extends DefaultChangeNotifier {
  List<UploadedTask> _uploadedTasks = [];

  StreamSubscription? _uploadedTaskSubscription;

  final UploadedTaskRepository _uploadedTaskRepository =
      GetIt.I<UploadedTaskRepository>();

  void getUploadedTasks(String? userId) {
    Stream<List<UploadedTask>> _uploadedTaskStream =
        _uploadedTaskRepository.getUploadedTasks(userId);
    _uploadedTaskSubscription =
        _uploadedTaskStream.listen(_uploadedTaskHander, cancelOnError: true);
  }

  void _uploadedTaskHander(List<UploadedTask> data) {
    _uploadedTasks = data;
    notify();
  }

  List<UploadedTask> get uploadedTasks => _uploadedTasks;

  List<UploadedTask> get completedTasks {
    return _uploadedTasks.where((e) => e.status == 1).toList();
  }

  num get totalEarninhg {
    return completedTasks.fold(
        0, (sum, e) => sum + (e.rewardAmount ?? 0.0));
  }

  int get completedTasksCount => completedTasks.length;

  @override
  void dispose() {
    _uploadedTaskSubscription?.cancel();
    _uploadedTaskSubscription = null;
    super.dispose();
  }
}
