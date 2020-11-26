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

int alarmId = 0;

//ここでAlarmのFunctionを定義する。クラス内ならStatic,クラス外ならTop-Levelではないといけない。

void alarmFunction(int id) async {
  if (Platform.isAndroid) {
    AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.VIEW',
        package: 'com.example.myalarm',
        componentName: 'com.example.myalarm.MainActivity',
        data: json.encode({"alarmId": id, "ringing": true}));

    await intent.launch().catchError((e) => print(e.toString()));
  }
}

void _clearAlarm() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.containsKey('state')) {
    var _json = json.decode(prefs.getString('state'));

    for (var i = 0; i < _json.length; i++) {
      AndroidAlarmManager.cancel(_json[i]['alarmId']);
    }

    prefs.setString('state', null);
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
    print('init starts');

    _initialize();
  }

//初期化
  void _initialize() async {
    //stateの読み込み
    _loadState().then((loadedState) => state = loadedState);
    //データを待ち受ける処理
    //ここから
    StreamSubscription _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      if (value != null) {
        var key = json.decode(value);
        state = [
          for (final alarm in state)
            if (alarm.uniqueId == key.uniqueId ?? false)
              AlarmState(
                  id: alarm.id, time: alarm.time, mount: true, ringing: true)
            else
              alarm
        ];
      }
    });

    ReceiveSharingIntent.getInitialText().then((String value) {
      if (value != null) {
        var key = json.decode(value);
        state = [
          for (final alarm in state)
            if (alarm.uniqueId == key.uniqueId)
              AlarmState(
                  id: alarm.id, time: alarm.time, mount: true, ringing: true)
            else
              alarm
        ];
      }
    });
    //ここまで
  }

  //アラームの追加
  void addAlarm(int id) async {
    state = [
      ...state,
      AlarmState(
          id: id,
          time: DateTime.now().toIso8601String(),
          mount: false,
          ringing: false,
          uniqueId: _uuid.v4())
    ];
    //永続化
    _save(state);
  }

  //アラームのセット
  void setAlarm(AlarmState target, String time) async {
    //AndroidAlarmManager.oneShotAt(DateTime.parse(time), _id, alarmFunction);
    state = [
      for (final alarm in state)
        if (alarm.uniqueId == target.uniqueId)
          AlarmState(
              id: target.id, mount: true, time: time, uniqueId: target.uniqueId)
        else
          alarm
    ];
    //永続化
    _save(state);
  }

  void _setAlarm(int id, String _time) async {
    AndroidAlarmManager.oneShotAt(DateTime.parse(_time), id, alarmFunction);
  }

  void releaseAlarm(AlarmState target) async {
    await AndroidAlarmManager.cancel(target.id);
  }

  void reservedClearAlarm() async {
    int clearalarmId = 10;
    DateTime _now = DateTime.now();
    DateTime _clearTime = DateTime(_now.year, _now.month, _now.day + 1, 10, 0);
    AndroidAlarmManager.oneShotAt(_clearTime, clearalarmId, _clearAlarm);
  }

  void toggleAlarm(AlarmState target) async {
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
    //永続化
    _save(state);
  }

  void removeAlarm(AlarmState target) async {
    state = state.where((alarm) => alarm.uniqueId != target.uniqueId).toList();
    //永続化
    _save(state);
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
  }
}
