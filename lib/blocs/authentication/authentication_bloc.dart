import 'package:adscope/core/enums/enums.dart';
import 'package:adscope/core/helpers/helpers.dart';
import 'package:adscope/models/models.dart';
import 'package:adscope/repositories/authentication_repository.dart';
import 'package:adscope/repositories/social_auth_repository.dart';
import 'package:adscope/repositories/user_repository.dart';
import 'package:adscope/services/services.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'authentication_state.dart';

class AuthenticationBloc extends Cubit<AuthenticationState> {
  final AuthenticationRepository authenticationRepository;
  final SocialAuthRepository socialAuthRepository;
  final UserRepository userRepository;

  AuthenticationBloc({
    required this.authenticationRepository,
    required this.userRepository,
    required this.socialAuthRepository,
  }) : super(const AuthenticationState());

  Future<void> signUpWithEmailAndPassword(UserData user) async {
    emit(state.update(status: ResultStatus.loading));
    AuthResult result =
        await authenticationRepository.createUserWithEmailAndPassword(
      email: user.email ?? '',
      password: user.password ?? '',
    );

    if (result.status) {
      if (result.user != null) {
        user.userId = result.user?.uid;
        user.createdAt = DateTime.now();
        user.updatedAt = DateTime.now();
        await userRepository.createUser(user);
        await _clearAuth();
        emit(state.update(
          status: ResultStatus.success,
          message: 'Registration successful...',
        ));
      } else {
        _authFailedResult();
      }
    } else {
      emit(state.update(status: ResultStatus.failure, message: result.message));
    }
  }

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    emit(state.update(status: ResultStatus.loading));

    AuthResult result = await authenticationRepository
        .signInWithEmailAndPassword(email: email, password: password);

    if (result.status) {
      String? deviceToken = await MessagingService.getToken();
      userRepository.updateUserField(FirestoreFields.password, password);
      userRepository.updateUserField(FirestoreFields.deviceToken, deviceToken);
      emit(state.update(status: ResultStatus.success, message: 'Logged in...'));
    } else {
      emit(state.update(status: ResultStatus.failure, message: result.message));
    }
  }

  Future<void> resetPassword(String email) async {
    emit(state.update(status: ResultStatus.loading));

    AuthResult result = await authenticationRepository.resetPassword(email);

    if (result.status) {
      emit(state.update(status: ResultStatus.success, message: result.message));
    } else {
      emit(state.update(status: ResultStatus.failure, message: result.message));
    }
  }

  Future<void> changePassword(
      {required String oldPassword, required String newPassword}) async {
    emit(state.update(status: ResultStatus.loading));

    AuthResult result = await authenticationRepository.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );

    if (result.status) {
      userRepository.updateUserField(FirestoreFields.password, newPassword);
      emit(state.update(
          status: ResultStatus.success, message: 'Password Changed.'));
    } else {
      emit(state.update(status: ResultStatus.failure, message: result.message));
    }
  }

  Future<void> socialAuth(AuthType type) async {
    emit(state.update(status: ResultStatus.loading));
    AuthResult? result;

    try {
      switch (type) {
        case AuthType.google:
          result = await socialAuthRepository.signInWithGoogle();
          break;
        case AuthType.apple:
          result = await socialAuthRepository.signInWithApple();
          break;
        case AuthType.facebook:
          result = await socialAuthRepository.signInWithFacebook();
          break;
        default:
      }

      if (result != null) {
        if (result.status) {
          if (result.user != null) {
            String? deviceToken = await MessagingService.getToken();

            if (!(await userRepository.checkUserExisting(result.user?.email))) {
              UserData user = UserData(authType: type);
              user.userId = result.user?.uid;
              user.email = result.user?.email;
              user.name = result.user?.displayName;
              user.photoUrl = result.user?.photoURL;
              user.deviceToken = deviceToken;
              user.createdAt = DateTime.now();
              user.updatedAt = DateTime.now();

              await userRepository.createUser(user);
            }
            emit(state.update(
              status: ResultStatus.success,
              message: 'Logged in...',
              isSoicalAuth: true,
            ));
          } else {
            _authFailedResult();
          }
        } else {
          emit(state.update(
              status: ResultStatus.failure, message: result.message));
        }
      } else {
        _authFailedResult();
      }
    } catch (e) {
      _authFailedResult();
    }
  }

  void _authFailedResult() {
    emit(
      state.update(
          status: ResultStatus.failure, message: 'Authentication failed'),
    );
  }

  Future<void> _clearAuth() async {
    await authenticationRepository.signOut();
  }
}
