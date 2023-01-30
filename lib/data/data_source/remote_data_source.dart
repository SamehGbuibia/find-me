import 'package:independet/data/network/app_api.dart';
import 'package:independet/data/responses/responses.dart';

abstract class RemoteDataSource {
  Future<DataResponse> getData();
  Future<DataResponse> setData(String msg);
  Future<DataResponse> upDatePosition();
  Future<bool> isIdExist(String id);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final AppServiceClient _appServiceClient;

  RemoteDataSourceImpl(this._appServiceClient);

  @override
  Future<DataResponse> getData() async {
    return await _appServiceClient.getData();
  }

  @override
  Future<DataResponse> setData(String msg) async {
    return await _appServiceClient.setData(msg);
  }

  @override
  Future<DataResponse> upDatePosition() async {
    return await _appServiceClient.upDatePosition();
  }

  @override
  Future<bool> isIdExist(String id) async {
    return await _appServiceClient.isIdExist(id);
  }
}
