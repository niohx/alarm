//import 'dart:html';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'alarm_model.g.dart';
part 'alarm_model.freezed.dart';

@freezed
abstract class AlarmState with _$AlarmState {
  const factory AlarmState({
    int id,
    int alarmId,
    String time,
    bool mount,
    bool ringing,
    String uniqueId,
  }) = _AlarmState;

  factory AlarmState.fromJson(Map<String, dynamic> json) =>
      _$AlarmStateFromJson(json);
}
