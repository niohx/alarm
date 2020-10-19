// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'alarm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$AlarmStateTearOff {
  const _$AlarmStateTearOff();

// ignore: unused_element
  _AlarmState call({int id, String time, bool mount}) {
    return _AlarmState(
      id: id,
      time: time,
      mount: mount,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $AlarmState = _$AlarmStateTearOff();

/// @nodoc
mixin _$AlarmState {
  int get id;
  String get time;
  bool get mount;

  $AlarmStateCopyWith<AlarmState> get copyWith;
}

/// @nodoc
abstract class $AlarmStateCopyWith<$Res> {
  factory $AlarmStateCopyWith(
          AlarmState value, $Res Function(AlarmState) then) =
      _$AlarmStateCopyWithImpl<$Res>;
  $Res call({int id, String time, bool mount});
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
    Object time = freezed,
    Object mount = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as int,
      time: time == freezed ? _value.time : time as String,
      mount: mount == freezed ? _value.mount : mount as bool,
    ));
  }
}

/// @nodoc
abstract class _$AlarmStateCopyWith<$Res> implements $AlarmStateCopyWith<$Res> {
  factory _$AlarmStateCopyWith(
          _AlarmState value, $Res Function(_AlarmState) then) =
      __$AlarmStateCopyWithImpl<$Res>;
  @override
  $Res call({int id, String time, bool mount});
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
    Object time = freezed,
    Object mount = freezed,
  }) {
    return _then(_AlarmState(
      id: id == freezed ? _value.id : id as int,
      time: time == freezed ? _value.time : time as String,
      mount: mount == freezed ? _value.mount : mount as bool,
    ));
  }
}

/// @nodoc
class _$_AlarmState with DiagnosticableTreeMixin implements _AlarmState {
  const _$_AlarmState({this.id, this.time, this.mount});

  @override
  final int id;
  @override
  final String time;
  @override
  final bool mount;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AlarmState(id: $id, time: $time, mount: $mount)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AlarmState'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('time', time))
      ..add(DiagnosticsProperty('mount', mount));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _AlarmState &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.time, time) ||
                const DeepCollectionEquality().equals(other.time, time)) &&
            (identical(other.mount, mount) ||
                const DeepCollectionEquality().equals(other.mount, mount)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(time) ^
      const DeepCollectionEquality().hash(mount);

  @override
  _$AlarmStateCopyWith<_AlarmState> get copyWith =>
      __$AlarmStateCopyWithImpl<_AlarmState>(this, _$identity);
}

abstract class _AlarmState implements AlarmState {
  const factory _AlarmState({int id, String time, bool mount}) = _$_AlarmState;

  @override
  int get id;
  @override
  String get time;
  @override
  bool get mount;
  @override
  _$AlarmStateCopyWith<_AlarmState> get copyWith;
}
