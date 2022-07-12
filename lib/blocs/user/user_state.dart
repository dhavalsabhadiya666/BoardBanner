part of 'user_bloc.dart';

class UserState extends Equatable {
  final ResultStatus status;
  final UserData? user;
  final String message;

  const UserState({
    this.status = ResultStatus.none,
    this.user,
    this.message = '',
  });

  UserState update({
    ResultStatus? status,
    UserData? user,
    String? message,
  }) {
    return UserState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [status, user ?? UserData.empty(), message];
}
