import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alarm/model/alarm_model.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'dart:async';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';

final _uuid = Uuid();

final alarmProvider =
    StateNotifierProvider<AlarmList, List<AlarmState>>((ref) => AlarmList());

class AlarmList extends StateNotifier<List<AlarmState>> {
  AlarmList() : super(const []) {
    _initialize();
  }

  late StreamSubscription _intentDataStreamSubscription;

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  //初期化
  void _initialize() async {
    // ローカルに保存してあるアラームリストがあれば、取得してStateに入れる
    state = await _loadState();
    print('init starts');
    print(state);
    //データを待ち受ける処理
    //ここから
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String? value) {
      if (value != null) {
        checkId(int.parse(value));
        print(value);
        print(state);
      }
    });

    ReceiveSharingIntent.getInitialText().then((String? value) {
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
        uniqueId: _uuid.v4(),
      )
    ];

    print(state);
    //永続化
    _save(state);
  }

  void releaseAllAlarmsAt(DateTime resetTime) async {
    int releaseAlarmId = 100000;
    DateTime _now = DateTime.now();
    Timer.periodic(resetTime.difference(_now), (t) {
      print('ok');
      state.forEach((alarm) => AndroidAlarmManager.cancel(alarm.id));
      state = [];
      t.cancel();
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('resetTime', resetTime.toIso8601String());
    AndroidAlarmManager.periodic(
        Duration(days: 1), releaseAlarmId, releaseAllAlarms,
        startAt: resetTime);
  }

  static void alarmFunction(int id) async {
    if (Platform.isAndroid) {
      AndroidIntent intent = AndroidIntent(
          action: 'android.intent.action.VIEW',
          package: 'com.iseya.alarm',
          componentName: 'com.iseya.alarm.MainActivity',
          data: id.toString());

      await intent.launch().catchError((e) => print(e.toString()));
    }
  }

  static void releaseAllAlarms() async {
    List<AlarmState> state = await _loadState();
    state.forEach((alarm) {
      AndroidAlarmManager.cancel(alarm.alarmId);
      print('stopped');
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    print('clear all prefs!!');
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
      DateTime.parse(time),
      target.alarmId,
      alarmFunction,
      wakeup: true,
    );
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
      print('alarm canseled');
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
    List<AlarmState> mountedAlarms =
        state.where((alarm) => alarm.mount == true).toList();
    mountedAlarms.map((AlarmState alarm) {
      AndroidAlarmManager.cancel(alarm.alarmId);
    });
    await prefs.clear();
    state = [];
  }

  void removeAlarm(AlarmState target) async {
    AndroidAlarmManager.cancel(target.alarmId);
    state = state.where((alarm) => alarm.uniqueId != target.uniqueId).toList();
    //永続化
    _save(state);
  }

  /// retreive alarm number
  /// 連番を使うための処理？
  static Future<int> retreiveAlarmId() async {
    int alarmId;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('alarmId')) {
      alarmId = prefs.getInt('alarmId')!;
      prefs.setInt('alarmId', alarmId + 1);
      return alarmId;
    } else {
      prefs.setInt('alarmId', 0);
      alarmId = 0;
      return alarmId;
    }
  }

  /// アラームリストをローカルに保存
  void _save(List<AlarmState> alarms) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        "state", alarms.map((alarm) => json.encode(alarm.toJson())).toList());
  }

  /// ローカルに保存してあるアラームリストを取得して返す
  /// 存在しなかった場合は空のリストを返す
  static Future<List<AlarmState>> _loadState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('state')) {
      List<String> alarmlist = prefs.getStringList("state")!;
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
          alarm.copyWith(
            mount: true,
            ringing: true,
          )
        else
          alarm.copyWith(
            ringing: false,
          )
    ];
  }
}
