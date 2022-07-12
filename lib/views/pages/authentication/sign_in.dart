import 'dart:io';

import 'package:adscope/blocs/authentication/authentication_bloc.dart';
import 'package:adscope/core/constants/constants.dart';
import 'package:adscope/core/enums/enums.dart';
import 'package:adscope/core/helpers/helpers.dart';
import 'package:adscope/core/routes/app_routes.dart';
import 'package:adscope/core/utils/utils.dart';
import 'package:adscope/services/services.dart';
import 'package:adscope/views/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with ValidationMixin {
  //
  final AuthenticationBloc _authenticationBloc = GetIt.I<AuthenticationBloc>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _passwordVisible = true;

  Future<void> _signInHandler() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (await ConnectivityService.isConnected) {
        _authenticationBloc.signInWithEmailAndPassword(
          email: _email.text.trim(),
          password: _password.text.trim(),
        );
      } else {
        SnackUtils(context).showSnakBar(noConnectionMessage);
      }
    }
  }

  Future<void> _socialAuthHandler(AuthType type) async {
    if (await ConnectivityService.isConnected) {
      _authenticationBloc.socialAuth(type);
    } else {
      SnackUtils(context).showSnakBar(noConnectionMessage);
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
                  Navigator.pushReplacementNamed(context, Routes.mainHome);
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
                          'Sign In',
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
                        _buildSignInForm(),
                      ],
                    ),
                  ),
                ),
                BottomFooter(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: Sizes.s20.h),
                      Text.rich(
                        TextSpan(
                          text: 'Don\'t have an account?',
                          style: TextStyle(
                            fontSize: Sizes.s14.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                          children: [
                            WidgetSpan(child: SizedBox(width: Sizes.s10.w)),
                            TextSpan(
                              text: 'Sign Up',
                              style: TextStyle(
                                fontSize: Sizes.s14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(context, Routes.signUp);
                                },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Sizes.s10.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInForm() {
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
                validator: emailAddressValidation,
              ),
              SizedBox(height: Sizes.s20.h),
              PrimaryTextField(
                controller: _password,
                labelText: 'Password',
                icon: Icons.lock_outline,
                obscureText: _passwordVisible,
                validator: passwordValidation,
                suffix: InkWell(
                  child: Icon(
                    _passwordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: Sizes.s20.sp,
                    color: Colors.black,
                  ),
                  onTap: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  child: const Text('Forgot Password'),
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(
                      fontSize: Sizes.s12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.forgotPassword);
                  },
                ),
              ),
              SizedBox(height: Sizes.s20.h),
              PrimaryButton(label: 'Sign In', onPressed: _signInHandler),
              SizedBox(height: Sizes.s20.h),
            ],
          ),
        ),
        SizedBox(height: Sizes.s20.h),
        Row(
          children: [
            const Expanded(
              child: Divider(
                height: 0,
                indent: 30,
                color: AppColors.darkGrey,
              ),
            ),
            SizedBox(width: Sizes.s10.h),
            Text(
              'Continue With',
              style: TextStyle(
                fontSize: Sizes.s12.sp,
                fontWeight: FontWeight.normal,
                color: const Color(0xffBDBDBD),
              ),
            ),
            SizedBox(width: Sizes.s10.h),
            const Expanded(
              child: Divider(
                height: 0,
                endIndent: 30,
                color: AppColors.darkGrey,
              ),
            ),
          ],
        ),
        SizedBox(height: Sizes.s20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (Platform.isIOS)
              SoicalAuthButton(
                imagePath: AppAssets.apple,
                onPressed: () {
                  _socialAuthHandler(AuthType.apple);
                },
              ),
            if (Platform.isIOS) SizedBox(width: Sizes.s20.h),
            SoicalAuthButton(
              imagePath: AppAssets.google,
              onPressed: () {
                _socialAuthHandler(AuthType.google);
              },
            ),
            SizedBox(width: Sizes.s20.h),
            SoicalAuthButton(
              imagePath: AppAssets.facebook,
              onPressed: () {
                _socialAuthHandler(AuthType.facebook);
              },
            ),
          ],
        ),
        SizedBox(height: Sizes.s20.h),
      ],
    );
  }
}
