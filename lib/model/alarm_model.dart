//import 'dart:html';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:uuid/uuid.dart';

part 'alarm_model.g.dart';
part 'alarm_model.freezed.dart';

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
