import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:independet/app/my_app.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:independet/presentation/resources/langauge_manager.dart';
import 'app/background_service.dart';
import 'app/di.dart';
import 'firebase_options.dart';

import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initAppModule();
  await EasyLocalization.ensureInitialized();
  await initializeService();
  runApp(EasyLocalization(
      supportedLocales: const [ARABIC_LOCAL, ENGLISH_LOCAL],
      path: ASSET_PATH_LOCALISATIONS,
      child: Phoenix(child: MyApp())));
}
