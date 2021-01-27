// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'alarm_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
AlarmState _$AlarmStateFromJson(Map<String, dynamic> json) {
  return _AlarmState.fromJson(json);
}

/// @nodoc
class _$AlarmStateTearOff {
  const _$AlarmStateTearOff();

// ignore: unused_element
  _AlarmState call(
      {int id,
      int alarmId,
      String time,
      bool mount,
      bool ringing,
      String uniqueId}) {
    return _AlarmState(
      id: id,
      alarmId: alarmId,
      time: time,
      mount: mount,
      ringing: ringing,
      uniqueId: uniqueId,
    );
  }

// ignore: unused_element
  AlarmState fromJson(Map<String, Object> json) {
    return AlarmState.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $AlarmState = _$AlarmStateTearOff();

/// @nodoc
mixin _$AlarmState {
  int get id;
  int get alarmId;
  String get time;
  bool get mount;
  bool get ringing;
  String get uniqueId;

  Map<String, dynamic> toJson();
  $AlarmStateCopyWith<AlarmState> get copyWith;
}

/// @nodoc
abstract class $AlarmStateCopyWith<$Res> {
  factory $AlarmStateCopyWith(
          AlarmState value, $Res Function(AlarmState) then) =
      _$AlarmStateCopyWithImpl<$Res>;
  $Res call(
      {int id,
      int alarmId,
      String time,
      bool mount,
      bool ringing,
      String uniqueId});
}

/// @nodoc
class _$AlarmStateCopyWithImpl<$Res> implements $AlarmStateCopyWith<$Res> {
  _$AlarmStateCopyWithImpl(this._value, this._then);

  final AlarmState _value;
  // ignore: unused_field
  final $Res Function(AlarmState) _then;

  @override
  $Res call({
    Object id = freezed,
    Object alarmId = freezed,
    Object time = freezed,
    Object mount = freezed,
    Object ringing = freezed,
    Object uniqueId = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as int,
      alarmId: alarmId == freezed ? _value.alarmId : alarmId as int,
      time: time == freezed ? _value.time : time as String,
      mount: mount == freezed ? _value.mount : mount as bool,
      ringing: ringing == freezed ? _value.ringing : ringing as bool,
      uniqueId: uniqueId == freezed ? _value.uniqueId : uniqueId as String,
    ));
  }
}

/// @nodoc
abstract class _$AlarmStateCopyWith<$Res> implements $AlarmStateCopyWith<$Res> {
  factory _$AlarmStateCopyWith(
          _AlarmState value, $Res Function(_AlarmState) then) =
      __$AlarmStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {int id,
      int alarmId,
      String time,
      bool mount,
      bool ringing,
      String uniqueId});
}

/// @nodoc
class __$AlarmStateCopyWithImpl<$Res> extends _$AlarmStateCopyWithImpl<$Res>
    implements _$AlarmStateCopyWith<$Res> {
  __$AlarmStateCopyWithImpl(
      _AlarmState _value, $Res Function(_AlarmState) _then)
      : super(_value, (v) => _then(v as _AlarmState));

  @override
  _AlarmState get _value => super._value as _AlarmState;

  @override
  $Res call({
    Object id = freezed,
    Object alarmId = freezed,
    Object time = freezed,
    Object mount = freezed,
    Object ringing = freezed,
    Object uniqueId = freezed,
  }) {
    return _then(_AlarmState(
      id: id == freezed ? _value.id : id as int,
      alarmId: alarmId == freezed ? _value.alarmId : alarmId as int,
      time: time == freezed ? _value.time : time as String,
      mount: mount == freezed ? _value.mount : mount as bool,
      ringing: ringing == freezed ? _value.ringing : ringing as bool,
      uniqueId: uniqueId == freezed ? _value.uniqueId : uniqueId as String,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_AlarmState with DiagnosticableTreeMixin implements _AlarmState {
  const _$_AlarmState(
      {this.id,
      this.alarmId,
      this.time,
      this.mount,
      this.ringing,
      this.uniqueId});

  factory _$_AlarmState.fromJson(Map<String, dynamic> json) =>
      _$_$_AlarmStateFromJson(json);

  @override
  final int id;
  @override
  final int alarmId;
  @override
  final String time;
  @override
  final bool mount;
  @override
  final bool ringing;
  @override
  final String uniqueId;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AlarmState(id: $id, alarmId: $alarmId, time: $time, mount: $mount, ringing: $ringing, uniqueId: $uniqueId)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AlarmState'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('alarmId', alarmId))
      ..add(DiagnosticsProperty('time', time))
      ..add(DiagnosticsProperty('mount', mount))
      ..add(DiagnosticsProperty('ringing', ringing))
      ..add(DiagnosticsProperty('uniqueId', uniqueId));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _AlarmState &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.alarmId, alarmId) ||
                const DeepCollectionEquality()
                    .equals(other.alarmId, alarmId)) &&
            (identical(other.time, time) ||
                const DeepCollectionEquality().equals(other.time, time)) &&
            (identical(other.mount, mount) ||
                const DeepCollectionEquality().equals(other.mount, mount)) &&
            (identical(other.ringing, ringing) ||
                const DeepCollectionEquality()
                    .equals(other.ringing, ringing)) &&
            (identical(other.uniqueId, uniqueId) ||
                const DeepCollectionEquality()
                    .equals(other.uniqueId, uniqueId)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(alarmId) ^
      const DeepCollectionEquality().hash(time) ^
      const DeepCollectionEquality().hash(mount) ^
      const DeepCollectionEquality().hash(ringing) ^
      const DeepCollectionEquality().hash(uniqueId);

  @override
  _$AlarmStateCopyWith<_AlarmState> get copyWith =>
      __$AlarmStateCopyWithImpl<_AlarmState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_AlarmStateToJson(this);
  }
}

abstract class _AlarmState implements AlarmState {
  const factory _AlarmState(
      {int id,
      int alarmId,
      String time,
      bool mount,
      bool ringing,
      String uniqueId}) = _$_AlarmState;

  factory _AlarmState.fromJson(Map<String, dynamic> json) =
      _$_AlarmState.fromJson;

  @override
  int get id;
  @override
  int get alarmId;
  @override
  String get time;
  @override
  bool get mount;
  @override
  bool get ringing;
  @override
  String get uniqueId;
  @override
  _$AlarmStateCopyWith<_AlarmState> get copyWith;
}
