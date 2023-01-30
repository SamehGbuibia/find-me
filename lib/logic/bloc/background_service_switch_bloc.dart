// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:independet/app/app_prefs.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../app/di.dart';
import '../../presentation/resources/string_manager.dart';

part 'background_service_switch_event.dart';
part 'background_service_switch_state.dart';

class BackgroundServiceSwitchBloc
    extends Bloc<BackgroundServiceSwitchEvent, BackgroundServiceSwitchState> {
  final _appPrefs = instance<AppPreferences>();
  final service = FlutterBackgroundService();
  BackgroundServiceSwitchBloc() : super(BackgroundServiceSwitchInitial()) {
    checkIsServiceRunning();
    on<BackgroundServiceSwitchOnEvent>((event, emit) async {
      try {
        await Permission.location.request();
        await Permission.locationWhenInUse.request();
        await Permission.locationAlways.request();
        service.startService();
        _appPrefs.setBackgroundServiceState(true);
        emit(BackgroundServiceSwitchedOnState());
      } catch (_) {}
    });
    on<BackgroundServiceSwitchOffEvent>((event, emit) {
      try {
        service.invoke("stopService");
        _appPrefs.setBackgroundServiceState(false);
        emit(BackgroundServiceSwitchedOffState());
      } catch (_) {}
    });
  }

  checkIsServiceRunning() async {
    final isRunning = await service.isRunning();
    if (isRunning) {
      emit(BackgroundServiceSwitchedOnState());
    } else {
      emit(BackgroundServiceSwitchedOffState());
    }
  }
}
