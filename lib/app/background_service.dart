import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:independet/app/app_prefs.dart';
import 'package:independet/app/constants_manager.dart';

import '../firebase_options.dart';
import 'di.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  final AppPreferences appPreferences = instance<AppPreferences>();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      // auto start service
      autoStart: appPreferences.getBackgroundServiceState(),
      isForegroundMode: false,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: appPreferences.getBackgroundServiceState(),
      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,
      // you have to enable background fetch capability on xcode project
      onBackground: (_) {
        WidgetsFlutterBinding.ensureInitialized();
        return true;
      },
    ),
  );
}

void onStart(ServiceInstance serviceInstance) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  String? id = androidInfo.id;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final collection = db.collection('start');
  final doc = collection.doc(id);
  serviceInstance.on("stopService").listen((event) {
    serviceInstance.stopSelf();
  });
  Timer.periodic(
      const Duration(seconds: ConstantsManager.periodeBetweenBackgroundUpdates),
      (_) async {
    Position position = await Geolocator.getCurrentPosition();
    Map<String, dynamic>? map = {
      "latitude": position.latitude,
      "longitude": position.longitude,
    };
    try {
      await doc.update(map);
    } catch (_) {}
  });
}
