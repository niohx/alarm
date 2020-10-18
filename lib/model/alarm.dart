import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod/riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'dart:math';
import 'package:android_intent/android_intent.dart';
import 'dart:io';

import 'package:myalarm/widget/ringing.dart';

part 'alarm.freezed.dart';

var _uuid = Uuid();

@freezed
abstract class AlarmState with _$AlarmState {
  const factory AlarmState({String time, bool mount, bool loaded}) =
      _AlarmState;
}

// class AlarmState {
//   AlarmState({this.mount, this.time, String id, this.loaded})
//       : id = id ?? _uuid.v4();
//   String id;
//   String time;
//   bool mount;
//   bool loaded;
//   @override
//   String toString() {
//     return 'Todo(Time: $time, mount: $mount)';
//   }
// }
void printHello() {
  print('fired!');
  //return Ringing(time: DateTime.now().toIso8601String());
}

// void printHello2() {
//   Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: (context) => Ringing(
//                 time: DateTime.now().toIso8601String(),
//               )));
// }

void printHello3() async {
  print('um');
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
            loaded: false)) {
    print('init starts');
    _initialize();
  }

  Future<void> _initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String initialTime = DateTime.now().toIso8601String();
    bool initialLoaded = false;
    bool initialmount = false;
    if (prefs.containsKey('time')) {
      initialTime = prefs.getString('time');
    }
    if (prefs.containsKey('started')) {
      initialmount = prefs.getBool('started');
    }
    state =
        state.copyWith(time: initialTime, mount: initialmount, loaded: true);
    print('init done');
  }

  void setTrue() {
    state = state.copyWith(mount: true);
  }

  void testAlarm() {
    AndroidAlarmManager.oneShot(
        Duration(seconds: 5), Random().nextInt(pow(2, 31)), printHello3);
  }

  static void printHello1() {
    print('yes, secceed');
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

  Future<void> disAlarm(AlarmState alarmState) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    state = state.copyWith(mount: false);
    prefs.setBool("started", false);
    print('disalarm');
  }

  Future<void> toggleAlarm(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _time = await prefs.getString('time'); //?? 'no record!';

    state = state.copyWith(
        mount: !state.mount, time: DateTime.now().toIso8601String());
    print('toggle done');
  }
}
