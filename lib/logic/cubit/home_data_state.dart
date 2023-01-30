part of '../cubit/home_data_cubit.dart';

@immutable
abstract class HomeDataState {}

class HomeDataInitial extends HomeDataFetched {
  HomeDataInitial(MainData dataObject) : super(dataObject);
}

class HomeDataFetched extends HomeDataState {
  final MainData dataObject;

  HomeDataFetched(this.dataObject);
}

class HomeDataFail extends HomeDataState {}
