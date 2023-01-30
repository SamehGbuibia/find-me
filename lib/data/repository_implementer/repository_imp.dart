import 'package:geolocator/geolocator.dart';
import 'package:independet/app/app_prefs.dart';
import 'package:independet/data/data_source/remote_data_source.dart';
import 'package:independet/data/mapper/mapper.dart';
import 'package:independet/data/network/error_handler.dart';
import 'package:independet/data/network/network_info.dart';
import 'package:independet/domain/models/models.dart';
import 'package:independet/data/network/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:independet/domain/repository/repository.dart';

// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math.dart' show radians, degrees;
import 'dart:math' show atan, cos, sin, tan;

class RepositoryImplementer extends Repository {
  final RemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;
  final AppPreferences _appPreferences;
  RepositoryImplementer(
    this._remoteDataSource,
    this._networkInfo,
    this._appPreferences,
  );
  @override
  Future<Either<Failure, DataObject>> getData() async {
    return await _checkInternetConnection<DataObject>(() async {
      final response = await _remoteDataSource.getData();
      if ((response.latitude == null ||
          response.longitude == null ||
          response.msg == null)) {
        return Left(DataSource.NO_CONTENT.getFailure());
      } else {
        return Right(response.toDomain());
      }
    });
  }

  @override
  Future<Either<Failure, MainData>> getAppReady() async {
    late final MainData cacheData;
    try {
      PhoneID.partnerID = _appPreferences.getPartnerId();
      cacheData = _appPreferences.getData();
    } catch (e) {
      if (e is ErrorHandler && e.failure.code == ResponseCode.NO_CONTENT) {
        return Left(e.failure);
      }
    }
    if (await _isLocationServiceEnabled()) {
      if (await _isLocationPermissionsEnabled()) {
        if (await _networkInfo.isConnected) {
          final result = await (await upDatePosition())
              .fold<Future<MainData?>>((l) async => null, (localRes) async {
            final partnerRes =
                (await getData()).fold<DataObject?>((_) => null, (r) => r);
            if (partnerRes != null) {
              final double distance = getDistance(
                  localRes.latitude,
                  localRes.longitude,
                  partnerRes.latitude,
                  partnerRes.longitude);
              final double angel = getOffsetFromNorth(
                  localRes.latitude,
                  localRes.longitude,
                  partnerRes.latitude,
                  partnerRes.longitude);
              return MainData(
                  latitude: partnerRes.latitude,
                  longitude: partnerRes.longitude,
                  angle: angel,
                  distance: distance,
                  partnerMsg: partnerRes.msg,
                  localMsg: localRes.msg);
            } else {
              return null;
            }
          });
          if (result != null) {
            result.localMsg = cacheData.localMsg;
            return Right(result);
          }
        }
        return Right(cacheData);
      }
    }
    return Left(DataSource.UNAUTORISED.getFailure());
  }

  @override
  Future<Either<Failure, DataObject>> setData(String msg) async {
    return await _checkInternetConnection<DataObject>(() async {
      try {
        final response = await _remoteDataSource.setData(msg);

        return Right(response.toDomain());
      } catch (e) {
        return Left(DataSource.CONNECT_TIMEOUT.getFailure());
      }
    });
  }

  @override
  Future<Either<Failure, DataObject>> upDatePosition() async {
    return await _checkInternetConnection<DataObject>(() async {
      try {
        final response = await _remoteDataSource.upDatePosition();
        return Right(response.toDomain());
      } catch (e) {
        return Left(DataSource.CONNECT_TIMEOUT.getFailure());
      }
    });
  }

  @override
  Future<bool> isIdExist(String id) async {
    final result = await _remoteDataSource.isIdExist(id);
    if (result) _appPreferences.setPartnerId(id);
    return result;
  }

  @override
  double getDistance(
    latitude1,
    longitude1,
    latitude2,
    longitude2,
  ) =>
      Geolocator.distanceBetween(
        latitude1,
        longitude1,
        latitude2,
        longitude2,
      );

  @override
  double getOffsetFromNorth(double latitude1, double longitude1,
      double latitude2, double longitude2) {
    if (latitude1 == latitude2 && longitude1 == longitude2) {
      return 0;
    }
    // ignore: no_leading_underscores_for_local_identifiers
    final _deLa = radians(latitude2);
    // ignore: no_leading_underscores_for_local_identifiers
    final _deLo = radians(longitude2);
    var laRad = radians(latitude1);
    var loRad = radians(longitude1);

    var toDegrees = degrees(atan(sin(_deLo - loRad) /
        ((cos(laRad) * tan(_deLa)) - (sin(laRad) * cos(_deLo - loRad)))));
    if (laRad > _deLa) {
      if ((loRad > _deLo || loRad < radians(-180.0) + _deLo) &&
          toDegrees > 0.0 &&
          toDegrees <= 90.0) {
        toDegrees += 180.0;
      } else if (loRad <= _deLo &&
          loRad >= radians(-180.0) + _deLo &&
          toDegrees > -90.0 &&
          toDegrees < 0.0) {
        toDegrees += 180.0;
      }
    }
    if (laRad < _deLa) {
      if ((loRad > _deLo || loRad < radians(-180.0) + _deLo) &&
          toDegrees > 0.0 &&
          toDegrees < 90.0) {
        toDegrees += 180.0;
      }
      if (loRad <= _deLo &&
          loRad >= radians(-180.0) + _deLo &&
          toDegrees > -90.0 &&
          toDegrees <= 0.0) {
        toDegrees += 180.0;
      }
    }
    return -radians(toDegrees);
  }

  //private functions

  Future<Either<Failure, Obj>> _checkInternetConnection<Obj>(
      Future<Either<Failure, Obj>> Function() function) async {
    if (await _networkInfo.isConnected) {
      return await function();
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  Future<bool> _isLocationServiceEnabled() async {
    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    return isServiceEnabled;
  }

  Future<bool> _isLocationPermissionsEnabled() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void saveCache(MainData mainData) {
    _appPreferences.setData(mainData);
  }
}
