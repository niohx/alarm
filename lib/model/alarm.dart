import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'dart:math';
import 'package:android_intent/android_intent.dart';
import 'dart:io';
import 'dart:async';

part 'alarm.freezed.dart';

@freezed
abstract class AlarmState with _$AlarmState {
  const factory AlarmState(
      {int id, String time, bool mount, bool ringing, bool used}) = _AlarmState;
}

final int alarmId = 1; //とりあえずグローバルで宣言。どうせ１つしかつかわない。

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

void clearAlarm() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool('mount') ?? false) {
    //まずはアラームをキャンセルして
    AndroidAlarmManager.cancel(alarmId);
  }
  //種々のキーを初期状態にする。
  prefs.setBool('mount', false);
  prefs.setBool('ringing', false);
  prefs.setString('time', null);
  prefs.setBool('used', false);
  prefs.setInt('id', alarmId);
  print('alarm canseled');
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

class AlarmController extends StateNotifier<AlarmState> {
  SharedPreferences prefs;
  AlarmController()
      : super(AlarmState(
            time: DateTime.now().toIso8601String(),
            mount: false,
            ringing: false)) {
    //print('init starts');
    _initialize();
  }

//初期化
  Future<void> _initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String initialTime;
    int initialid;
    bool initialmount;
    bool initialringing;
    if (prefs.containsKey('time')) {
      DateTime _now = DateTime.now();
      DateTime _time = DateTime.parse(prefs.getString('time') ?? _now);
      initialTime =
          DateTime(_now.year, _now.month, _now.day, _time.hour, _time.minute, 0)
              .toIso8601String();
      prefs.setString('time', initialTime);
    } else {
      DateTime _time = DateTime.now();
      prefs.setString('time', _time.toIso8601String());
      initialTime = _time.toIso8601String();
    }
    if (prefs.containsKey('mount')) {
      initialmount = prefs.getBool('mount');
    } else {
      bool _mount = false;
      prefs.setBool('mount', _mount);
      initialmount = _mount;
    }

    if (prefs.containsKey('id')) {
      initialid = prefs.getInt('id');
    } else {
      int _id = 0;
      prefs.setInt("id", _id);
      initialid = _id;
    }

    if (prefs.containsKey('ringing')) {
      initialringing = prefs.getBool('ringing');
    } else {
      bool _ringing = false;
      prefs.setBool("ringing", _ringing);
      initialringing = _ringing;
    }

    if (DateTime.now()
            .difference(DateTime.parse(initialTime))
            .inMinutes
            .abs() <=
        1) {
      initialringing = true;
      print('fire!');
    }

    state = state.copyWith(
        time: initialTime,
        mount: initialmount,
        id: initialid,
        ringing: initialringing,
        used: true);
  }

  //1分ごとにチェックする
  void checkAlarm() async {
    print('checking initiate');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime _time = DateTime.parse(prefs.getString('time'));
    print(_time.toIso8601String());
    // Timer.periodic(const Duration(minutes: 1), (timer) {
    //   print('checking...');
    //   if (DateTime.now().difference(_time).inMinutes.abs() <= 1) {
    //     print('fire now');
    //     state.copyWith(ringing: true);
    //   } else {
    //     print('not fired..');
    //   }
    // });
  }

  void setTrue() {
    state = state.copyWith(mount: true);
    print('set true');
  }

  void testAlarm() {
    AndroidAlarmManager.oneShot(
        Duration(seconds: 5), Random().nextInt(pow(2, 31)), alarmFunction);
  }

  Future<void> setAlarm(String _time) async {
    state = state.copyWith(time: _time, mount: true);
    AndroidAlarmManager.oneShot(Duration(seconds: 5), alarmId, alarmFunction);
    // AndroidAlarmManager.oneShotAt(
    //     DateTime.parse(_time), alarmId, alarmFunction);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("time", _time);
    prefs.setInt('id', alarmId);
    print("set alarm with some kind of key");
  }

  Future<void> dismissAlarm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int id = await prefs.getInt('id');

    AndroidAlarmManager.cancel(id);
    print('alarm canceled!');
    state = state.copyWith(mount: false);
  }

  Future<void> releaseAlarm() async {
    AndroidAlarmManager.cancel(alarmId);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('ringing', false);
  }

  void canselAlarm() async {
    state.copyWith(ringing: false);
    //AndroidAlarmManager.oneShot(Duration(seconds: 10), alarmId, clearAlarm);
  }

  Future<void> toggleAlarm(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _time = await prefs.getString('time'); //?? 'no record!';
    print(_time);

    state = state.copyWith(mount: !state.mount, time: _time);
    print('toggle done');
  }
}
