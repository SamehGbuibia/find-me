// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:independet/data/network/error_handler.dart';
import 'package:independet/domain/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../presentation/resources/langauge_manager.dart';

const String PREFS_KEY_LANG = "PREFS_KEY_LANG";
const String PREFS_KEY_LOCAL_MSG = "PREFS_KEY_LOCAL_MSG";
const String PREFS_KEY_PARTNER_MSG = "PREFS_KEY_PARTNER_MSG";
const String PREFS_KEY_PARTNER_ID = "PREFS_KEY_PARTNER_ID";
const String PREFS_KEY_ANGLE = "PREFS_KEY_ANGLE";
const String PREFS_KEY_DISTANCE = "PREFS_KEY_DISTANCE";
const String PREFS_KEY_LATITUDE = "PREFS_KEY_LATITUDE";
const String PREFS_KEY_LONGITUDE = "PREFS_KEY_LONGITUDE";
const String PREFS_KEY_BACKGROUND_SERVICE = "PREFS_KEY_BACKGROUND_SERVICE";

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  //language
  Future<String> getAppLanguage() async {
    String? language = _sharedPreferences.getString(PREFS_KEY_LANG);
    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      return LanguageType.ENGLISH.getValue();
    }
  }

  Future<void> changeAppLanguage(LanguageType languageType) async {
    _sharedPreferences.setString(PREFS_KEY_LANG, languageType.getValue());
  }

  Future<Locale> getLocale() async {
    String language = await getAppLanguage();
    if (language == LanguageType.ARABIC.getValue()) {
      return ARABIC_LOCAL;
    } else {
      return ENGLISH_LOCAL;
    }
  }

  //mainData
  MainData getData() {
    late final String localMsg;
    if (_sharedPreferences.containsKey(PREFS_KEY_LOCAL_MSG)) {
      localMsg = _sharedPreferences.get(PREFS_KEY_LOCAL_MSG) as String;
    } else {
      localMsg = "";
    }
    if (_sharedPreferences.containsKey(PREFS_KEY_ANGLE)) {
      final latitude = _sharedPreferences.get(PREFS_KEY_LATITUDE) as double;
      final longitude = _sharedPreferences.get(PREFS_KEY_LONGITUDE) as double;
      final angle = _sharedPreferences.get(PREFS_KEY_ANGLE) as double;
      final distance = _sharedPreferences.get(PREFS_KEY_DISTANCE) as double;
      final partnerMsg =
          _sharedPreferences.get(PREFS_KEY_PARTNER_MSG) as String;
      return MainData(
          latitude: latitude,
          longitude: longitude,
          distance: distance,
          angle: angle,
          partnerMsg: partnerMsg,
          localMsg: localMsg);
    } else {
      return MainData(
          latitude: 0,
          longitude: 0,
          distance: 0,
          angle: 0,
          partnerMsg: "",
          localMsg: localMsg);
    }
  }

  Future<void> setData(MainData mainData) async {
    await _sharedPreferences.setDouble(PREFS_KEY_LATITUDE, mainData.latitude);
    await _sharedPreferences.setDouble(PREFS_KEY_LONGITUDE, mainData.longitude);
    await _sharedPreferences.setDouble(PREFS_KEY_ANGLE, mainData.angle);
    await _sharedPreferences.setDouble(PREFS_KEY_DISTANCE, mainData.distance);
    await _sharedPreferences.setString(PREFS_KEY_LOCAL_MSG, mainData.localMsg);
    await _sharedPreferences.setString(
        PREFS_KEY_PARTNER_MSG, mainData.partnerMsg);
  }

  //partnerId
  String getPartnerId() {
    if (_sharedPreferences.containsKey(PREFS_KEY_PARTNER_ID)) {
      return _sharedPreferences.get(PREFS_KEY_PARTNER_ID) as String;
    } else {
      throw ErrorHandler.handle(DataSource.NO_CONTENT);
    }
  }

  void setPartnerId(String id) async =>
      await _sharedPreferences.setString(PREFS_KEY_PARTNER_ID, id);
  //Background service
  bool getBackgroundServiceState() {
    if (_sharedPreferences.containsKey(PREFS_KEY_BACKGROUND_SERVICE)) {
      return _sharedPreferences.get(PREFS_KEY_BACKGROUND_SERVICE) as bool;
    } else {
      setBackgroundServiceState(false);
      return false;
    }
  }

  void setBackgroundServiceState(bool isEnabled) async =>
      await _sharedPreferences.setBool(PREFS_KEY_BACKGROUND_SERVICE, isEnabled);
}
