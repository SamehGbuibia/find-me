part of 'is_id_exist_cubit.dart';

@immutable
abstract class IsIdExistState {}

class IsIdExistInitial extends IsIdExistState {}

class IdExist extends IsIdExistState {}

class IdNotExist extends IsIdExistState {}

class MaximumTriesExceededState extends IsIdExistState {}
