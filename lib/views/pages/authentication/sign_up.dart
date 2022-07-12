import 'dart:io';

import 'package:adscope/blocs/authentication/authentication_bloc.dart';
import 'package:adscope/core/constants/constants.dart';
import 'package:adscope/core/enums/enums.dart';
import 'package:adscope/core/helpers/helpers.dart';
import 'package:adscope/core/routes/app_routes.dart';
import 'package:adscope/core/utils/utils.dart';
import 'package:adscope/models/models.dart';
import 'package:adscope/providers/providers.dart';
import 'package:adscope/services/services.dart';
import 'package:adscope/views/dialogs/app_dialogs.dart';
import 'package:adscope/views/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with ValidationMixin {
  //
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _state = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool _passwordVisible = true;
  bool _confirmPasswordVisible = true;

  bool _isAccepted = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AuthenticationBloc _authenticationBloc = GetIt.I<AuthenticationBloc>();

  Future<void> _signUpHandler() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_isAccepted) {
        if (await ConnectivityService.isConnected) {
          UserData _user = UserData(
            name: _name.text.trim(),
            email: _email.text.trim(),
            password: _password.text.trim(),
            authType: AuthType.email,
            city: _city.text.trim(),
            isEnable: true,
            state: _state.text.trim(),
          );
          _authenticationBloc.signUpWithEmailAndPassword(_user);
        } else {
          SnackUtils(context).showSnakBar(noConnectionMessage);
        }
      } else {
        SnackUtils(context).showSnakBar('Please accept the Terms & Conditions');
      }
    }
  }

  Future<void> _socialAuthHandler(AuthType type) async {
    if (await ConnectivityService.isConnected) {
      if (_isAccepted) {
        _authenticationBloc.socialAuth(type);
      } else {}
      SnackUtils(context).showSnakBar('Please accept the Terms & Conditions');
    } else {
      SnackUtils(context).showSnakBar(noConnectionMessage);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var appProvider = context.read<AppProvider>();
      appProvider.getStates();
    });
  }

  @override
  void dispose() {
    _authenticationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
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
                    Future.delayed(
                      const Duration(milliseconds: 500),
                      () {
                        if (state.isSoicalAuth) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.mainHome,
                            (route) => false,
                          );
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    );
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
                              'Sign Up',
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
                            _buildSignUpForm(),
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
                              text: 'Already have an account?',
                              style: TextStyle(
                                fontSize: Sizes.s14.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                              children: [
                                WidgetSpan(child: SizedBox(width: Sizes.s10.w)),
                                TextSpan(
                                  text: 'Sign In',
                                  style: TextStyle(
                                    fontSize: Sizes.s14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primary,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pop(context);
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
      },
    );
  }

  Widget _buildSignUpForm() {
    var appProvider = context.read<AppProvider>();

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
                controller: _name,
                labelText: 'Name',
                icon: Icons.person_outline,
                validator: nameValidation,
              ),
              SizedBox(height: Sizes.s20.h),
              PrimaryTextField(
                controller: _email,
                labelText: 'Email',
                icon: Icons.email_outlined,
                validator: emailAddressValidation,
              ),
              SizedBox(height: Sizes.s20.h),
              PrimaryTextField(
                controller: _state,
                labelText: 'State',
                readOnly: true,
                hintText: 'Select State',
                suffix: Icon(
                  Icons.keyboard_arrow_down,
                  size: Sizes.s20.sp,
                  color: Colors.black,
                ),
                validator: stateValidation,
                onTap: () async {
                  Land? land = await AppDialogs.showStatePicker(
                    context,
                    states: appProvider.states,
                  );

                  if (land != null) {
                    _state.text = land.stateName ?? '';
                    _city.clear();
                    appProvider.getCities(land.stateId);
                  }
                },
              ),
              SizedBox(height: Sizes.s20.h),
              PrimaryTextField(
                controller: _city,
                labelText: 'City',
                hintText: 'Select City',
                readOnly: true,
                suffix: Icon(
                  Icons.keyboard_arrow_down,
                  size: Sizes.s20.sp,
                  color: Colors.black,
                ),
                validator: cityValidation,
                onTap: () async {
                  City? city = await AppDialogs.showCityPicker(
                    context,
                    cities: appProvider.cities,
                  );

                  if (city != null) {
                    _city.text = city.cityName ?? '';
                  }
                },
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
              SizedBox(height: Sizes.s20.h),
              PrimaryTextField(
                controller: _confirmPassword,
                labelText: 'Confirm Password',
                icon: Icons.lock_outline,
                obscureText: _confirmPasswordVisible,
                validator: (value) {
                  return confirmPasswordValidation(
                      value, _password.text.trim());
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
              SizedBox(height: Sizes.s30.h),
              PrimaryButton(label: 'Sign Up', onPressed: _signUpHandler),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              value: _isAccepted,
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() {
                  _isAccepted = value ?? false;
                });
              },
            ),
            Text.rich(
              TextSpan(
                text: 'Accept the',
                style: TextStyle(
                  fontSize: Sizes.s14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGrey,
                ),
                children: [
                  WidgetSpan(child: SizedBox(width: Sizes.s10.w)),
                  TextSpan(
                    text: 'Terms & Conditions',
                    style: TextStyle(
                      fontSize: Sizes.s14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed<bool>(
                                context, Routes.termsAndConditions)
                            .then((bool? value) {
                          setState(() {
                            _isAccepted = value ?? false;
                          });
                        });
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: Sizes.s10.h),
      ],
    );
  }
}
