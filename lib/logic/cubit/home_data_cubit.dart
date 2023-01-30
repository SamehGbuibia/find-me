import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:independet/app/di.dart';
import 'package:independet/domain/repository/repository.dart';
import '../../domain/models/models.dart';

part 'home_data_state.dart';

class HomeDataCubit extends Cubit<HomeDataState> {
  Repository repository = instance<Repository>();
  late Stream<Future<void>> positionStream;
  late StreamSubscription<Future<void>> positionStreamSubscription;
  DataObject? _localDataObject;
  DataObject? _partnerDataObject;
  // ignore: prefer_final_fields
  MainData _mainData;
  late String newMsg;
  HomeDataCubit(this._mainData) : super(HomeDataInitial(_mainData)) {
    newMsg = _mainData.localMsg;
  }
  @override
  close() async {
    await positionStreamSubscription.cancel();
    super.close();
  }

  start() {
    positionStream = Stream<Future<void>>.periodic(
      const Duration(seconds: 7),
      (computationCount) async {},
    );
    positionStreamSubscription =
        positionStream.listen((Future<void> streamValue) async {
      (_localDataObject?.msg != newMsg
              ? await repository.setData(newMsg)
              : await repository.upDatePosition())
          .fold((l) {}, (r) => _localDataObject = r);
      (await repository.getData()).fold((l) {
        emit(HomeDataFetched(_mainData));
      }, (r) {
        _partnerDataObject = r;
        if (_localDataObject != null) {
          final distance = repository.getDistance(
            _localDataObject!.latitude,
            _localDataObject!.longitude,
            _partnerDataObject!.latitude,
            _partnerDataObject!.longitude,
          );
          final double angel = repository.getOffsetFromNorth(
            _localDataObject!.latitude,
            _localDataObject!.longitude,
            _partnerDataObject!.latitude,
            _partnerDataObject!.longitude,
          );
          _mainData = MainData(
              latitude: r.latitude,
              longitude: r.longitude,
              angle: angel,
              distance: distance,
              partnerMsg: r.msg,
              localMsg: newMsg);
        }
        repository.saveCache(_mainData);
        emit(HomeDataFetched(_mainData));
      });
    });
  }

  setMsg(String msg) => newMsg = msg;
}
