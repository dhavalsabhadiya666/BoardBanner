import 'package:adscope/blocs/authentication/authentication_bloc.dart';
import 'package:adscope/core/constants/constants.dart';
import 'package:adscope/core/enums/enums.dart';
import 'package:adscope/core/helpers/helpers.dart';
import 'package:adscope/core/utils/utils.dart';
import 'package:adscope/services/services.dart';
import 'package:adscope/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ForogotPasswordPage extends StatefulWidget {
  const ForogotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForogotPasswordPage> createState() => _ForogotPasswordPageState();
}

class _ForogotPasswordPageState extends State<ForogotPasswordPage>
    with ValidationMixin {
  //
  final AuthenticationBloc _authenticationBloc = GetIt.I<AuthenticationBloc>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();

  Future<void> _resetPasswordHandler() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (await ConnectivityService.isConnected) {
        _authenticationBloc.resetPassword(_email.text.trim());
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
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
            child: Column(
              children: [
                const LogoHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(kPadding),
                    child: Column(
                      children: [
                        Text(
                          'Reset Password',
                          style: TextStyle(
                            fontSize: Sizes.s24.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: Sizes.s20.h),
                        Text(
                          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: Sizes.s14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.darkGrey,
                          ),
                        ),
                        SizedBox(height: Sizes.s20.h),
                        _buildForgotPasswordForm(),
                        SizedBox(height: Sizes.s20.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordForm() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(Sizes.s20.h),
          decoration: BoxDecoration(
              color: const Color(0xffF7F7F7),
              borderRadius: BorderRadius.circular(Sizes.s24.h)),
          child: Column(
            children: [
              PrimaryTextField(
                controller: _email,
                labelText: 'Email',
                icon: Icons.email_outlined,
              ),
              SizedBox(height: Sizes.s30.h),
              PrimaryButton(
                label: 'Send Link',
                onPressed: _resetPasswordHandler,
              ),
              SizedBox(height: Sizes.s10.h),
            ],
          ),
        ),
        SizedBox(height: Sizes.s10.h),
        PrimaryTextButton(
          label: 'Back to Sign In',
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
