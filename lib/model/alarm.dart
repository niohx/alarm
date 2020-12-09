//import 'dart:html';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:android_intent/android_intent.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:uuid/uuid.dart';

part 'alarm.freezed.dart';
part 'alarm.g.dart';

var _uuid = Uuid();

//ここでAlarmのFunctionを定義する。クラス内ならStatic,クラス外ならTop-Levelではないといけない。

Future<List<AlarmState>> loadState() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('state')) {
    List<String> alarmlist = prefs.getStringList("state");
    return alarmlist
        .map((alarm) => AlarmState.fromJson(json.decode(alarm)))
        .toList();
  }
  return [];
}

void alarmFunction(int id) async {
  if (Platform.isAndroid) {
    AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.VIEW',
        package: 'com.example.myalarm',
        componentName: 'com.example.myalarm.MainActivity',
        data: id.toString());

    await intent.launch().catchError((e) => print(e.toString()));
  }
}

void releaseAllAlarms() async {
  List<AlarmState> state = await loadState();
  state.forEach((alarm) {
    AndroidAlarmManager.cancel(alarm.alarmId);
  });
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
  print('clear all prefs!@!');
}

@freezed
abstract class AlarmState with _$AlarmState {
  const factory AlarmState(
      {int id,
      int alarmId,
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
    print('init starts');

    _initialize();
  }

//初期化
  void _initialize() async {
    //stateの読み込み
    state = await _loadState();
    //データを待ち受ける処理
    //ここから
    StreamSubscription _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      if (value != null) {
        checkId(int.parse(value));
        print(state);
      }
    });

    ReceiveSharingIntent.getInitialText().then((String value) {
      if (value != null) {
        checkId(int.parse(value));
      }
    });
    //ここまで
    //最後にアラームを全部キャンセルするように予約する
    //AndroidAlarmManager.oneShot(Duration(seconds: 30), 10000, releaseAllAlarms);
  }

  //アラームの追加
  void addAlarm(int id) async {
    int alarmId = await retreiveAlarmId();
    state = [
      ...state,
      AlarmState(
          id: id,
          alarmId: alarmId,
          time: DateTime.now().toIso8601String(),
          mount: false,
          ringing: false,
          uniqueId: _uuid.v4())
    ];
    print(state);
    //永続化
    _save(state);
  }

  void reserveReleaseAllAlarms(DateTime resetTime) {
    int releaseAlarmId = 100000;
    AndroidAlarmManager.periodic(
        Duration(days: 1), releaseAlarmId, releaseAllAlarms,
        startAt: resetTime);
  }

  void testSetAlarm(String uniqueId, String time) async {
    AlarmState target =
        state.where((target) => target.uniqueId == uniqueId).toList()[0];
    AndroidAlarmManager.oneShot(
        Duration(seconds: 50), target.alarmId, alarmFunction);
  }

  void toggleAlarm(AlarmState target) async {
    if (target.mount == false) {
      setAlarm(target, target.time);
    } else {
      canselAlarm(target);
    }
    // 永続化
    _save(state);
  }

  //アラームのセット
  void setAlarm(AlarmState target, String time) async {
    print("alarm set");
    AndroidAlarmManager.oneShotAt(
        DateTime.parse(time), target.alarmId, alarmFunction);
    state = [
      for (final alarm in state)
        if (alarm.uniqueId == target.uniqueId)
          AlarmState(
              id: alarm.id,
              alarmId: alarm.alarmId,
              mount: true,
              time: time,
              uniqueId: alarm.uniqueId)
        else
          alarm
    ];
    //永続化
    _save(state);
  }

  //アラームのキャンセル
  void canselAlarm(AlarmState target) {
    try {
      AndroidAlarmManager.cancel(target.alarmId);
    } catch (e) {
      print(e);
    }
    ;
    state = [
      for (final alarm in state)
        if (alarm.uniqueId == target.uniqueId)
          AlarmState(
              id: alarm.id,
              alarmId: alarm.alarmId,
              mount: false,
              time: alarm.time,
              uniqueId: alarm.uniqueId)
        else
          alarm
    ];
    _save(state);
  }

  void clearAllAlarm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    state = [];
  }

  void removeAlarm(AlarmState target) async {
    state = state.where((alarm) => alarm.uniqueId != target.uniqueId).toList();
    //永続化
    _save(state);
  }

  //retreive alarm number
  Future<int> retreiveAlarmId() async {
    int alarmId;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('alarmId')) {
      alarmId = prefs.getInt('alarmId');
      prefs.setInt('alarmId', alarmId + 1);
      return alarmId;
    } else {
      prefs.setInt('alarmId', 0);
      alarmId = 0;
      return alarmId;
    }
  }

  //stateのセーブとロード
  void _save(List<AlarmState> alarms) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        "state", alarms.map((alarm) => json.encode(alarm.toJson())).toList());
  }

  Future<List<AlarmState>> _loadState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('state')) {
      List<String> alarmlist = prefs.getStringList("state");
      return alarmlist
          .map((alarm) => AlarmState.fromJson(json.decode(alarm)))
          .toList();
    }
    return [];
  }

  //Streamから来たIDのチェック　IDがかぶればRingingにする。その他のRingingはFalseにする。
  void checkId(int id) {
    print('fired!!!!!');
    state = [
      for (final alarm in state)
        if (alarm.alarmId == id)
          AlarmState(
              id: alarm.id,
              alarmId: alarm.alarmId,
              time: alarm.time,
              mount: true,
              ringing: true)
        else
          AlarmState(
              id: alarm.id,
              alarmId: alarm.alarmId,
              time: alarm.time,
              mount: alarm.mount,
              ringing: false)
    ];
  }
}
