part of 'is_service_started_cubit.dart';

abstract class IsServiceStartedState {}

class IsServiceStartedInitial extends IsServiceStartedState {}

class ServiceStarted extends IsServiceStartedState {
  final MainData mainData;

  ServiceStarted(this.mainData);
}

class ServiceStartedWithNewUser extends IsServiceStartedState {}
