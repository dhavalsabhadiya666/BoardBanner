import 'package:adscope/blocs/authentication/authentication_bloc.dart';
import 'package:adscope/core/constants/constants.dart';
import 'package:adscope/core/enums/enums.dart';
import 'package:adscope/core/helpers/helpers.dart';
import 'package:adscope/core/utils/utils.dart';
import 'package:adscope/services/services.dart';
import 'package:adscope/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage>
    with ValidationMixin {
  //
  final AuthenticationBloc _authenticationBloc = GetIt.I<AuthenticationBloc>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool _oldPasswordVisible = true;
  bool _newPasswordVisible = true;
  bool _confirmPasswordVisible = true;

  Future<void> _changePasswordHandler() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (await ConnectivityService.isConnected) {
        _authenticationBloc.changePassword(
          oldPassword: _oldPassword.text.trim(),
          newPassword: _newPassword.text.trim(),
        );
      } else {
        SnackUtils(context).showSnakBar(noConnectionMessage);
      }
    }
  }

  @override
  void dispose() {
    _authenticationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.backAppBar(context, title: 'Change Password'),
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        bloc: _authenticationBloc,
        listener: (context, state) {
          switch (state.status) {
            case ResultStatus.loading:
              Loader.show(context);
              break;
            case ResultStatus.success:
              Loader.dismiss(context);
              SnackUtils(context).showSnakBar(state.message);
              Future.delayed(const Duration(milliseconds: 500), () {
                Navigator.pop(context);
              });
              break;
            case ResultStatus.failure:
              Loader.dismiss(context);
              SnackUtils(context).showSnakBar(state.message);
              break;
            default:
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: kPadding),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                SizedBox(height: Sizes.s26.h),
                PrimaryTextField(
                  icon: Icons.lock,
                  labelText: 'Old Password',
                  controller: _oldPassword,
                  obscureText: _oldPasswordVisible,
                  validator: passwordValidation,
                  suffix: InkWell(
                    child: Icon(
                      _oldPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: Sizes.s20.sp,
                      color: Colors.black,
                    ),
                    onTap: () {
                      setState(() {
                        _oldPasswordVisible = !_oldPasswordVisible;
                      });
                    },
                  ),
                ),
                SizedBox(height: Sizes.s26.h),
                PrimaryTextField(
                  icon: Icons.lock,
                  labelText: 'New Password',
                  controller: _newPassword,
                  obscureText: _newPasswordVisible,
                  validator: (value) {
                    return newPasswordValidation(
                        value, _oldPassword.text.trim());
                  },
                  suffix: InkWell(
                    child: Icon(
                      _newPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: Sizes.s20.sp,
                      color: Colors.black,
                    ),
                    onTap: () {
                      setState(() {
                        _newPasswordVisible = !_newPasswordVisible;
                      });
                    },
                  ),
                ),
                SizedBox(height: Sizes.s26.h),
                PrimaryTextField(
                  icon: Icons.lock,
                  labelText: 'Confirm Password',
                  controller: _confirmPassword,
                  obscureText: _confirmPasswordVisible,
                  validator: (value) {
                    return confirmPasswordValidation(
                        value, _newPassword.text.trim());
                  },
                  suffix: InkWell(
                    child: Icon(
                      _confirmPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: Sizes.s20.sp,
                      color: Colors.black,
                    ),
                    onTap: () {
                      setState(() {
                        _confirmPasswordVisible = !_confirmPasswordVisible;
                      });
                    },
                  ),
                ),
                SizedBox(height: Sizes.s40.h),
                PrimaryButton(
                  label: 'Submit',
                  onPressed: _changePasswordHandler,
                ),
                SizedBox(height: Sizes.s10.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
