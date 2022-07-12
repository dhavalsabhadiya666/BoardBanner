import 'package:adscope/models/models.dart';

class TaskLocationArgs {
  final TaskLocation taskLocation;
  final bool isAccepted;

  TaskLocationArgs({required this.taskLocation, this.isAccepted = false});
}
