import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod/riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
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

  Future<void> setAlarm(String _time) async {
    state = state.copyWith(time: _time, mount: true);
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
