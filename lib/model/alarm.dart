//import 'dart:html';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';

import 'package:android_intent/android_intent.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

part 'alarm.freezed.dart';
part 'alarm.g.dart';

var _uuid = Uuid();

int alarmId = 0;

//ここでAlarmのFunctionを定義する。クラス内ならStatic,クラス外ならTop-Levelではないといけない。

void alarmFunction() async {
  if (Platform.isAndroid) {
    AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        package: 'com.example.myalarm',
        componentName: 'com.example.myalarm.MainActivity');
    await intent.launch().catchError((e) => print(e.toString()));
  }
}

void _clearAlarm() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool('mount') ?? false) {
    //まずはアラームをキャンセルして
    // AndroidAlarmManager.cancel(alarmId);
  }
  //種々のキーを初期状態にする。
  prefs.setBool('mount', false);
  prefs.setBool('ringing', false);
  prefs.setString('time', null);
  prefs.setBool('used', false);
  prefs.setInt('id', alarmId);
  print('alarm was cleared!');
}

//1分以内ならTrueで大体同じならOKのやつ
bool compareTime(DateTime timeA) {
  DateTime now = DateTime.now();
  if (now.difference(timeA).inMinutes.abs() <= 1) {
    return true;
  } else {
    return false;
  }
}

@freezed
abstract class AlarmState with _$AlarmState {
  const factory AlarmState(
      {int id,
      String time,
      bool mount,
      bool ringing,
      String uniqueId}) = _AlarmState;
  factory AlarmState.fromJson(Map<String, dynamic> json) =>
      _$AlarmStateFromJson(json);
}

class AlarmList extends StateNotifier<List<AlarmState>> {
  SharedPreferences prefs;
  AlarmList([List<AlarmState> initialAlarms]) : super(initialAlarms ?? []) {
    //print('init starts');
  }

//初期化
  void addAlarm(int id) {
    state = [
      ...state,
      AlarmState(
          id: id,
          time: DateTime.now().toIso8601String(),
          mount: false,
          ringing: false,
          uniqueId: _uuid.v4())
    ];
  }

  void setAlarm(AlarmState target, String time) {
    //AndroidAlarmManager.oneShotAt(DateTime.parse(time), _id, alarmFunction);
    state = [
      for (final alarm in state)
        if (alarm.uniqueId == target.uniqueId)
          AlarmState(
              id: target.id, mount: true, time: time, uniqueId: target.uniqueId)
        else
          alarm
    ];
  }

  void _setAlarm(int id, String _time) async {
    AndroidAlarmManager.oneShotAt(DateTime.parse(_time), id, alarmFunction);
  }

  void dismissAlarm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('mount', false);
    AndroidAlarmManager.cancel(alarmId);
  }

  void reservedClearAlarm() async {
    int clearalarmId = 10;
    DateTime _now = DateTime.now();
    DateTime _clearTime = DateTime(_now.year, _now.month, _now.day + 1, 10, 0);
    AndroidAlarmManager.oneShotAt(_clearTime, clearalarmId, _clearAlarm);
  }

  void toggleAlarm(AlarmState target) {
    state = [
      for (final alarm in state)
        if (alarm.uniqueId == target.uniqueId)
          AlarmState(
              id: alarm.id,
              mount: !alarm.mount,
              time: alarm.time,
              uniqueId: alarm.uniqueId,
              ringing: false)
        else
          alarm,
    ];
  }

  void removeAlarm(AlarmState target) {
    state = state.where((alarm) => alarm.uniqueId != target.uniqueId).toList();
  }
  // void toggleAlarm(bool value) {
  //   print(value);
  //   state = state.copyWith(mount: value);
  //   print('State is ${state.mount}');
  // }
  // void setTrue() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool('mount', true);
  //   state = state.copyWith(mount: true);
  //   print('set true');
  // }

  // void canselAlarm() {
  //   AndroidAlarmManager.oneShot(Duration(seconds: 5), 10, clearAlarm);
  // }

  // Future<void> setAlarm(String _time) async {
  //   state = state.copyWith(time: _time, mount: true);
  //   AndroidAlarmManager.oneShot(Duration(seconds: 5), alarmId, alarmFunction);

  //   // AndroidAlarmManager.oneShotAt(
  //   //     DateTime.parse(_time), alarmId, alarmFunction);
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString("time", _time);
  //   prefs.setInt('id', alarmId);
  //   print("set alarm with some kind of key");
  // }

  // Future<void> dismissAlarm() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int id = await prefs.getInt('id');

  //   AndroidAlarmManager.cancel(id);
  //   print('alarm canceled!');
  //   state = state.copyWith(mount: false);
  // }

  // Future<void> stopAlarm() async {
  //   AndroidAlarmManager.cancel(alarmId);
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool('ringing', false);
  // }

  // Future<void> toggleAlarm(bool value) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String _time = await prefs.getString('time'); //?? 'no record!';
  //   print(_time);

  //   state = state.copyWith(mount: !state.mount, time: _time);
  //   print('toggle done');
  // }
}
