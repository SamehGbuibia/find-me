import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:independet/logic/cubit/is_service_started_cubit.dart';
import 'package:independet/presentation/resources/assets_manager.dart';
import 'package:independet/presentation/resources/colors_manager.dart';
import 'package:independet/presentation/resources/routes_manager.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.white,
      body: BlocProvider(
        create: (context) => IsServiceStartedCubit(),
        child: BlocListener<IsServiceStartedCubit, IsServiceStartedState>(
          listener: (context, state) {
            if (state is ServiceStarted) {
              Navigator.of(context).pushReplacementNamed(Routes.mainRoute,
                  arguments: state.mainData);
            } else if (state is ServiceStartedWithNewUser) {
              Navigator.of(context).pushReplacementNamed(Routes.settingRoute,
                  arguments: SettingViewArguments("", null));
            }
          },
          child: Center(
            child: Image.asset(ImageAssets.loading),
          ),
        ),
      ),
    );
  }
}
