import 'package:alarm/model/alarm_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:android_intent/android_intent.dart';

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
        package: 'com.example.alarm',
        componentName: 'com.example.alarm.MainActivity',
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
  print('clear all prefs!!');
}
