import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:independet/app/app_prefs.dart';
import 'package:independet/data/data_source/remote_data_source.dart';
import 'package:independet/data/network/app_api.dart';
import 'package:independet/data/network/network_info.dart';
import 'package:independet/data/repository_implementer/repository_imp.dart';
import 'package:independet/domain/models/models.dart';
import 'package:independet/domain/repository/repository.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  // app module, its a module where we put all generic dependencies

  // shared prefs instance
  final sharedPrefs = await SharedPreferences.getInstance();

  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  //Phone ID instance
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  String id = androidInfo.id;
  final PhoneID phoneID = PhoneID(id);

  instance.registerLazySingleton<PhoneID>(() => phoneID);

  // app prefs instance
  instance
      .registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));

  //appServiceClient instance
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient());

  //RemoteDataSource instance
  instance.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(instance()));

  //NetworkInfo instance
  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnectionChecker()));

  //repository instance
  instance.registerLazySingleton<Repository>(
      () => RepositoryImplementer(instance(), instance(), instance()));
}
