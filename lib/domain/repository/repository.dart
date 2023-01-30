import 'package:dartz/dartz.dart';
import 'package:independet/data/network/failure.dart';
import 'package:independet/domain/models/models.dart';

abstract class Repository {
  Future<Either<Failure, DataObject>> getData();
  Future<Either<Failure, DataObject>> setData(String msg);
  Future<Either<Failure, DataObject>> upDatePosition();
  Future<Either<Failure, MainData>> getAppReady();
  Future<bool> isIdExist(String id);
  void saveCache(MainData mainData);
  double getDistance(
    double latitude1,
    double longitude1,
    double latitude2,
    double longitude2,
  );
  double getOffsetFromNorth(
    double latitude1,
    double longitude1,
    double latitude2,
    double longitude2,
  );
}
