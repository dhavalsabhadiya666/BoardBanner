part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  final ResultStatus status;
  final String message;
  final bool isSoicalAuth;

  const AuthenticationState({
    this.status = ResultStatus.none,
    this.message = '',
    this.isSoicalAuth = false,
  });

  AuthenticationState update({
    ResultStatus? status,
    String? message,
    bool? isSoicalAuth,
  }) {
    return AuthenticationState(
      status: status ?? this.status,
      message: message ?? this.message,
      isSoicalAuth: isSoicalAuth ?? this.isSoicalAuth,
    );
  }

  @override
  List<Object> get props {
    return [status, message, isSoicalAuth];
  }
}
