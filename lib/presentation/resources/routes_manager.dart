import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:independet/domain/models/models.dart';
import 'package:independet/presentation/main_screen/main_view.dart';
import 'package:independet/presentation/resources/string_manager.dart';
import 'package:independet/presentation/setting_screen/setting_view.dart';
import 'package:independet/presentation/splash_screen/splash_view.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../logic/cubit/home_data_cubit.dart';

class Routes {
  static const String splashRoute = "/";
  static const String mainRoute = "/main";
  static const String settingRoute = "/setting";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case Routes.mainRoute:
        final MainData mainData = settings.arguments as MainData;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
              create: (context) => HomeDataCubit(mainData)..start(),
              child: MainView(
                initialData: mainData,
              )),
        );
      case Routes.settingRoute:
        final SettingViewArguments settingViewArguments =
            settings.arguments as SettingViewArguments;
        return MaterialPageRoute(
          builder: (_) => SettingView(
            msg: settingViewArguments.msg,
            ctx: settingViewArguments.ctx,
          ),
        );
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: Text(StringsManager.noRouteFound.tr()),
              ),
              body: Center(child: Text(StringsManager.noRouteFound.tr())),
            ));
  }
}

class SettingViewArguments {
  final String msg;
  final BuildContext? ctx;

  SettingViewArguments(this.msg, this.ctx);
}
