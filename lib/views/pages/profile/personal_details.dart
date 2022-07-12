import 'dart:io';

import 'package:adscope/blocs/user/user_bloc.dart';
import 'package:adscope/core/constants/constants.dart';
import 'package:adscope/core/enums/enums.dart';
import 'package:adscope/core/helpers/helpers.dart';
import 'package:adscope/core/utils/utils.dart';
import 'package:adscope/models/models.dart';
import 'package:adscope/providers/providers.dart';
import 'package:adscope/services/services.dart';
import 'package:adscope/views/dialogs/app_dialogs.dart';
import 'package:adscope/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class PersonalDetailPage extends StatefulWidget {
  const PersonalDetailPage({Key? key}) : super(key: key);

  @override
  State<PersonalDetailPage> createState() => _PersonalDetailPageState();
}

class _PersonalDetailPageState extends State<PersonalDetailPage>
    with ValidationMixin {
  //
  final UserBloc _userBloc = GetIt.I<UserBloc>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _nickName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _state = TextEditingController();

  File? _file;

  @override
  void initState() {
    super.initState();
    _setPeronalDetails();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var appProvider = context.read<AppProvider>();
      appProvider.getStates();
    });
  }

  void _setPeronalDetails() {
    var user = context.read<UserProvider>().user;

    if (user?.hasData ?? false) {
      _name.text = user?.name ?? '';
      _nickName.text = user?.nickName ?? '';
      _email.text = user?.email ?? '';
      _city.text = user?.city ?? '';
      _state.text = user?.state ?? '';
    }
    _userBloc.initBloc(user);
  }

  Future<void> _savePersonalDetailsHanlder() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (await ConnectivityService.isConnected) {
        _userBloc.saveUser(_file);
      } else {
        SnackUtils(context).showSnakBar(noConnectionMessage);
      }
    }
  }

  void _pickImageHandler() async {
    File? file = await AppDialogs.showImageSourceSheet(context);
    if (file != null) {
      setState(() {
        _file = file;
      });
    }
  }

  @override
  void dispose() {
    _userBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Scaffold(
          appBar: AppBars.backAppBar(context, title: 'Personal Details'),
          body: BlocListener<UserBloc, UserState>(
            bloc: _userBloc,
            listener: (context, state) {
              switch (state.status) {
                case ResultStatus.loading:
                  Loader.show(context);
                  break;
                case ResultStatus.success:
                  Loader.dismiss(context);
                  SnackUtils(context).showSnakBar('Saved');
                  _file = null;
                  break;
                case ResultStatus.failure:
                  Loader.dismiss(context);
                  SnackUtils(context).showSnakBar(state.message);
                  break;
                default:
              }
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.all(kPadding),
              child: Column(
                children: [
                  _buildProfilePic(userProvider.user?.photoUrl),
                  SizedBox(height: Sizes.s30.h),
                  _buildProfileDetailsForm()
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfilePic(String? imageUrl) {
    return SizedBox(
      height: ScreenUtil().setHeight(140),
      width: ScreenUtil().setHeight(140),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: WidgetDelegate(
              shouldShowPrimary: _file != null,
              primaryWidget: () {
                return Container(
                  height: Sizes.s130.h,
                  width: Sizes.s130.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.secondary.withOpacity(0.05),
                    image: DecorationImage(image: FileImage(_file!)),
                  ),
                );
              },
              alternateWidget: () {
                return WidgetDelegate(
                  shouldShowPrimary: imageUrl != null,
                  primaryWidget: () {
                    return ImageView(
                      imageUrl: imageUrl ?? '',
                      height: Sizes.s130.h,
                      width: Sizes.s130.h,
                      radius: Sizes.s130.h / 2,
                    );
                  },
                  alternateWidget: () {
                    return Container(
                      height: Sizes.s130.h,
                      width: Sizes.s130.h,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.secondary.withOpacity(0.05),
                      ),
                      child: Icon(
                        Icons.person,
                        size: Sizes.s30.h,
                        color: AppColors.secondary,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: _pickImageHandler,
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.border_color_outlined,
                  size: Sizes.s18.h,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetailsForm() {
    var appProvider = context.read<AppProvider>();

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrimaryTextField(
            labelText: 'Name',
            controller: _name,
            validator: nameValidation,
            onChanged: (value) {
              _userBloc.nameChanged(value);
            },
          ),
          SizedBox(height: Sizes.s20.h),
          PrimaryTextField(
            labelText: 'Nick Name',
            controller: _nickName,
            onChanged: (value) {
              _userBloc.nickNameChanged(value);
            },
          ),
          SizedBox(height: Sizes.s20.h),
          PrimaryTextField(
            labelText: 'Email',
            controller: _email,
            readOnly: true,
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
                _userBloc.stateChanged(land.stateName);
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
                _userBloc.cityChanged(city.cityName);
              }
            },
          ),
          SizedBox(height: Sizes.s40.h),
          PrimaryButton(
            label: 'Submit',
            onPressed: _savePersonalDetailsHanlder,
          ),
        ],
      ),
    );
  }
}
