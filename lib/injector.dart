import 'package:adscope/blocs/authentication/authentication_bloc.dart';
import 'package:adscope/blocs/user/user_bloc.dart';
import 'package:adscope/core/helpers/helpers.dart';
import 'package:adscope/repositories/app_repository.dart';
import 'package:adscope/repositories/authentication_repository.dart';
import 'package:adscope/repositories/location_repository.dart';
import 'package:adscope/repositories/notification_repository.dart';
import 'package:adscope/repositories/social_auth_repository.dart';
import 'package:adscope/repositories/task_repository.dart';
import 'package:adscope/repositories/uploaded_task_repository.dart';
import 'package:adscope/repositories/user_repository.dart';
import 'package:get_it/get_it.dart';

class Injector {
  Injector._();

  static void init() {
    // Repositories
    GetIt.I.registerFactory(() => FirestoreCollections());
    GetIt.I.registerFactory(() => AuthenticationRepository());
    GetIt.I.registerFactory(() => SocialAuthRepository());
    GetIt.I.registerFactory(() => LocationRepository());
    GetIt.I.registerFactory(() => AppRepository(collections: GetIt.I()));
    GetIt.I.registerFactory(() => TaskRepository(collections: GetIt.I()));
    GetIt.I
        .registerFactory(() => NotificationRepository(collections: GetIt.I()));
    GetIt.I.registerFactory(() {
      return UserRepository(collections: GetIt.I(), auth: GetIt.I());
    });
    GetIt.I.registerFactory(() {
      return UploadedTaskRepository(
        collections: GetIt.I(),
        taskRepository: GetIt.I(),
      );
    });

    // Blocs
    GetIt.I.registerFactory(() {
      return AuthenticationBloc(
        authenticationRepository: GetIt.I(),
        socialAuthRepository: GetIt.I(),
        userRepository: GetIt.I(),
      );
    });
    GetIt.I.registerFactory(() {
      return UserBloc(userRepository: GetIt.I());
    });
  }
}
