import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting.g.dart';
part 'setting.freezed.dadrt';

@freezed
class Settings extends _$Settings {
  const factory({})=_$Settings

}

class AlarmSetting {
  AlarmSetting() {
    _initSettings();
  }
  void _initSettings() async {}
}
