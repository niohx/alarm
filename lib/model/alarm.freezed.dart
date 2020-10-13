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
  _AlarmState call({String time, bool mount, bool loaded}) {
    return _AlarmState(
      time: time,
      mount: mount,
      loaded: loaded,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $AlarmState = _$AlarmStateTearOff();

/// @nodoc
mixin _$AlarmState {
  String get time;
  bool get mount;
  bool get loaded;

  $AlarmStateCopyWith<AlarmState> get copyWith;
}

/// @nodoc
abstract class $AlarmStateCopyWith<$Res> {
  factory $AlarmStateCopyWith(
          AlarmState value, $Res Function(AlarmState) then) =
      _$AlarmStateCopyWithImpl<$Res>;
  $Res call({String time, bool mount, bool loaded});
}

/// @nodoc
class _$AlarmStateCopyWithImpl<$Res> implements $AlarmStateCopyWith<$Res> {
  _$AlarmStateCopyWithImpl(this._value, this._then);

  final AlarmState _value;
  // ignore: unused_field
  final $Res Function(AlarmState) _then;

  @override
  $Res call({
    Object time = freezed,
    Object mount = freezed,
    Object loaded = freezed,
  }) {
    return _then(_value.copyWith(
      time: time == freezed ? _value.time : time as String,
      mount: mount == freezed ? _value.mount : mount as bool,
      loaded: loaded == freezed ? _value.loaded : loaded as bool,
    ));
  }
}

/// @nodoc
abstract class _$AlarmStateCopyWith<$Res> implements $AlarmStateCopyWith<$Res> {
  factory _$AlarmStateCopyWith(
          _AlarmState value, $Res Function(_AlarmState) then) =
      __$AlarmStateCopyWithImpl<$Res>;
  @override
  $Res call({String time, bool mount, bool loaded});
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
    Object time = freezed,
    Object mount = freezed,
    Object loaded = freezed,
  }) {
    return _then(_AlarmState(
      time: time == freezed ? _value.time : time as String,
      mount: mount == freezed ? _value.mount : mount as bool,
      loaded: loaded == freezed ? _value.loaded : loaded as bool,
    ));
  }
}

/// @nodoc
class _$_AlarmState with DiagnosticableTreeMixin implements _AlarmState {
  const _$_AlarmState({this.time, this.mount, this.loaded});

  @override
  final String time;
  @override
  final bool mount;
  @override
  final bool loaded;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AlarmState(time: $time, mount: $mount, loaded: $loaded)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AlarmState'))
      ..add(DiagnosticsProperty('time', time))
      ..add(DiagnosticsProperty('mount', mount))
      ..add(DiagnosticsProperty('loaded', loaded));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _AlarmState &&
            (identical(other.time, time) ||
                const DeepCollectionEquality().equals(other.time, time)) &&
            (identical(other.mount, mount) ||
                const DeepCollectionEquality().equals(other.mount, mount)) &&
            (identical(other.loaded, loaded) ||
                const DeepCollectionEquality().equals(other.loaded, loaded)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(time) ^
      const DeepCollectionEquality().hash(mount) ^
      const DeepCollectionEquality().hash(loaded);

  @override
  _$AlarmStateCopyWith<_AlarmState> get copyWith =>
      __$AlarmStateCopyWithImpl<_AlarmState>(this, _$identity);
}

abstract class _AlarmState implements AlarmState {
  const factory _AlarmState({String time, bool mount, bool loaded}) =
      _$_AlarmState;

  @override
  String get time;
  @override
  bool get mount;
  @override
  bool get loaded;
  @override
  _$AlarmStateCopyWith<_AlarmState> get copyWith;
}
