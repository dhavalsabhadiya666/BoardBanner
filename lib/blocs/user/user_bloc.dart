import 'dart:io';

import 'package:adscope/core/enums/enums.dart';
import 'package:adscope/models/models.dart';
import 'package:adscope/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_state.dart';

class UserBloc extends Cubit<UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(const UserState());

  void initBloc(UserData? user) {
    emit(state.update(user: user));
  }

  void nameChanged(String? name) {
    if (name != null) {
      state.user?.name = name;
      emit(state.update(user: state.user));
    }
  }

  void nickNameChanged(String? nickName) {
    if (nickName != null) {
      state.user?.nickName = nickName;
      emit(state.update(user: state.user));
    }
  }

  void stateChanged(String? s) {
    if (s != null) {
      state.user?.state = s;
      emit(state.update(user: state.user));
    }
  }

  void cityChanged(String? city) {
    if (city != null) {
      state.user?.city = city;
      emit(state.update(user: state.user));
    }
  }

  Future<void> saveUser(File? file) async {
    try {
      if (state.user != null) {
        emit(state.update(status: ResultStatus.loading));

        if (file != null) {
          String? photoUrl = await userRepository.uploadPhoto(file);
          state.user?.photoUrl = photoUrl;
        }

        await userRepository.updateUser(state.user!);
        emit(state.update(status: ResultStatus.success));
      } else {
        emit(
          state.update(
            status: ResultStatus.failure,
            message: 'Something went wrong, please try again later.',
          ),
        );
      }
    } catch (e) {
      emit(
        state.update(status: ResultStatus.failure, message: e.toString()),
      );
    }
  }
}
