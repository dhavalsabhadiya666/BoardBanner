import 'package:adscope/core/constants/constants.dart';
import 'package:adscope/core/routes/app_routes.dart';
import 'package:adscope/core/routes/arguments.dart';
import 'package:adscope/models/models.dart';
import 'package:adscope/providers/providers.dart';
import 'package:adscope/repositories/task_repository.dart';
import 'package:adscope/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class MyTaskPage extends StatefulWidget {
  const MyTaskPage({Key? key}) : super(key: key);

  @override
  State<MyTaskPage> createState() => _MyTaskPageState();
}

class _MyTaskPageState extends State<MyTaskPage> {
  //
  final TaskRepository _taskRepository = GetIt.I<TaskRepository>();

  final Map<int, String> _tabs = {0: 'On Going', 1: 'Completed'};

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        var user = userProvider.user;
        return Scaffold(
          appBar: AppBars.homeAppBar(context, title: 'My Tasks'),
          body: DefaultTabController(
            length: _tabs.length,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinerTabBar(tabs: _tabs),
                  ],
                ),
                Expanded(
                  child: StreamBuilder<List<TaskLocation>>(
                    stream: _taskRepository.getMyTaksLocations(user?.userId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<TaskLocation> tasks = snapshot.data ?? [];
                        var onGoingTasks =
                            tasks.where((e) => e.status == 1).toList();

                        var completedTasks = tasks
                            .where((e) => (e.status == 2 || e.status == 3))
                            .toList();

                        return TabBarView(
                          children: [
                            _buildMyTaskListView(onGoingTasks),
                            _buildMyTaskListView(completedTasks, true),
                          ],
                        );
                      } else {
                        return Loader.circularProgressIndicator();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMyTaskListView(List<TaskLocation> tasks,
      [bool isCompleted = false]) {
    return WidgetDelegate(
      shouldShowPrimary: tasks.isNotEmpty,
      primaryWidget: () {
        return ListView.builder(
          itemCount: tasks.length,
          padding: EdgeInsets.all(kPadding),
          itemBuilder: (context, index) {
            var task = tasks[index];
            return TaskListTile(
              taskLocation: task,
              onPressed: isCompleted
                  ? null
                  : () {
                      Navigator.pushNamed(
                        context,
                        Routes.taskLocationDetails,
                        arguments: TaskLocationArgs(
                          taskLocation: task,
                          isAccepted: true,
                        ),
                      );
                    },
            );
          },
        );
      },
      alternateWidget: () {
        return EmptyWidget(
          isCompleted ? 'No Completed Tasks' : 'No On Going Tasks',
        );
      },
    );
  }
}
