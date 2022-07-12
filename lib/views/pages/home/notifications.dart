import 'package:adscope/core/constants/constants.dart';
import 'package:adscope/core/enums/enums.dart';
import 'package:adscope/models/models.dart';
import 'package:adscope/providers/providers.dart';
import 'package:adscope/repositories/notification_repository.dart';
import 'package:adscope/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  //
  final NotificationRepository _notificationRepository =
      GetIt.I<NotificationRepository>();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        var user = userProvider.user;
        return Scaffold(
          appBar: AppBars.homeAppBar(context, title: 'Notifications'),
          body: StreamBuilder<List<NotificationData>>(
            stream: _notificationRepository.getNotifications(user?.userId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<NotificationData> notifications = snapshot.data ?? [];

                return WidgetDelegate(
                  shouldShowPrimary: notifications.isNotEmpty,
                  primaryWidget: () {
                    return ListView.separated(
                      itemCount: notifications.length,
                      padding: EdgeInsets.all(kPadding),
                      itemBuilder: (context, index) {
                        var notification = notifications[index];
                        return _NotificationTile(notification: notification);
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                    );
                  },
                  alternateWidget: () {
                    return const EmptyWidget('No Notifications');
                  },
                );
              } else {
                return Loader.circularProgressIndicator();
              }
            },
          ),
        );
      },
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationData notification;

  const _NotificationTile({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildLeading(notification.type),
      contentPadding: EdgeInsets.symmetric(vertical: Sizes.s4.h),
      title: Row(
        children: [
          Expanded(
            child: Text(
              notification.title ?? '',
              style: TextStyle(
                fontSize: Sizes.s15.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(width: Sizes.s10.h),
          Text(
            notification.getTime(),
            style: TextStyle(
              fontSize: Sizes.s12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.darkGrey,
            ),
          )
        ],
      ),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Sizes.s4.h),
          Text(
            notification.content ?? '',
            style: TextStyle(fontSize: Sizes.s14.sp, color: Colors.black),
          ),
          SizedBox(height: Sizes.s2.h),
          Text(
            notification.getDate(),
            style: TextStyle(
              fontSize: Sizes.s12.sp,
              color: AppColors.darkGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeading(NotificationType? type) {
    IconData icon = Icons.notifications;
    Color color = Colors.black;

    switch (type) {
      case NotificationType.taskSuccess:
        color = Colors.indigo;
        icon = Icons.check_circle_rounded;
        break;
      case NotificationType.taskFailed:
        color = Colors.red;
        icon = Icons.cancel_rounded;
        break;
      case NotificationType.payout:
        color = Colors.green;
        icon = Icons.wallet_outlined;
        break;
      default:
    }

    return CircleAvatar(
      radius: Sizes.s24.h,
      backgroundColor: color.withOpacity(0.1),
      child: Icon(icon, size: Sizes.s28.h, color: color),
    );
  }
}
