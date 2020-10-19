import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'dart:math';
import 'package:android_intent/android_intent.dart';
import 'dart:io';

import 'package:myalarm/widget/ringing.dart';

part 'alarm.freezed.dart';

@freezed
abstract class AlarmState with _$AlarmState {
  const factory AlarmState({int id, String time, bool mount}) = _AlarmState;
}

//ここでAlarmのFunctionを定義する。
void alarmFunction() async {
  if (Platform.isAndroid) {
    AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        package: 'com.example.myalarm',
        componentName: 'com.example.myalarm.MainActivity');
    await intent.launch().catchError((e) => print(e.toString()));
  }
}

class AlarmController extends StateNotifier<AlarmState> {
  SharedPreferences prefs;
  AlarmController()
      : super(AlarmState(
          time: DateTime.now().toIso8601String(),
          mount: false,
        )) {
    //print('init starts');
    _initialize();
  }

  Future<void> _initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String initialTime = DateTime.now().toIso8601String();
    int initialid = 0;
    bool initialmount = false;
    if (prefs.containsKey('time')) {
      initialTime = prefs.getString('time');
    } else {
      prefs.setString('time', DateTime.now().toIso8601String());
    }
    if (prefs.containsKey('mount')) {
      initialmount = prefs.getBool('mount');
    } else {
      prefs.setBool('mount', false);
    }

    if (prefs.containsKey('id')) {
      initialid = prefs.getInt('id');
    } else {
      prefs.setInt("id", 0);
    }
    state =
        state.copyWith(time: initialTime, mount: initialmount, id: initialid);

    //print('init done');
  }

  void setTrue() {
    state = state.copyWith(mount: true);
  }

  void testAlarm() {
    AndroidAlarmManager.oneShot(
        Duration(seconds: 5), Random().nextInt(pow(2, 31)), alarmFunction);
  }

  Future<void> setAlarm(String _time) async {
    state = state.copyWith(time: _time, mount: true);
    //AndroidAlarmManager.oneShot(Duration(seconds:5), Random().nextInt(pow(2, 31)), callback)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("time", _time);
    prefs.setBool("started", true);
    print('alarm is set to $_time');
    print("set alarm with some kind of key");
  }

  Future<void> dismissAlarm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int id = await prefs.getInt('id');
    AndroidAlarmManager.cancel(id);
    state = state.copyWith(mount: false);
  }

  Future<void> toggleAlarm(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _time = await prefs.getString('time'); //?? 'no record!';

    state = state.copyWith(
        mount: !state.mount, time: DateTime.now().toIso8601String());
    print('toggle done');
  }
}
