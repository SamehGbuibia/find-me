part of 'background_service_switch_bloc.dart';

@immutable
abstract class BackgroundServiceSwitchEvent {}

class BackgroundServiceSwitchOnEvent extends BackgroundServiceSwitchEvent {}

class BackgroundServiceSwitchOffEvent extends BackgroundServiceSwitchEvent {}
