part of 'background_service_switch_bloc.dart';

@immutable
abstract class BackgroundServiceSwitchState {
  final text = "";
}

class BackgroundServiceSwitchInitial extends BackgroundServiceSwitchState {
  @override
  get text => "";
}

class BackgroundServiceSwitchedOnState extends BackgroundServiceSwitchState {
  @override
  String get text => StringsManager.stopService;
}

class BackgroundServiceSwitchedOffState extends BackgroundServiceSwitchState {
  @override
  get text => StringsManager.startService;
}
