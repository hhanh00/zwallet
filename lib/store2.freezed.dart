// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store2.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SeedInfo {
  String get seed => throw _privateConstructorUsedError;
  int get index => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SeedInfoCopyWith<SeedInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SeedInfoCopyWith<$Res> {
  factory $SeedInfoCopyWith(SeedInfo value, $Res Function(SeedInfo) then) =
      _$SeedInfoCopyWithImpl<$Res, SeedInfo>;
  @useResult
  $Res call({String seed, int index});
}

/// @nodoc
class _$SeedInfoCopyWithImpl<$Res, $Val extends SeedInfo>
    implements $SeedInfoCopyWith<$Res> {
  _$SeedInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? seed = null,
    Object? index = null,
  }) {
    return _then(_value.copyWith(
      seed: null == seed
          ? _value.seed
          : seed // ignore: cast_nullable_to_non_nullable
              as String,
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SeedInfoImplCopyWith<$Res>
    implements $SeedInfoCopyWith<$Res> {
  factory _$$SeedInfoImplCopyWith(
          _$SeedInfoImpl value, $Res Function(_$SeedInfoImpl) then) =
      __$$SeedInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String seed, int index});
}

/// @nodoc
class __$$SeedInfoImplCopyWithImpl<$Res>
    extends _$SeedInfoCopyWithImpl<$Res, _$SeedInfoImpl>
    implements _$$SeedInfoImplCopyWith<$Res> {
  __$$SeedInfoImplCopyWithImpl(
      _$SeedInfoImpl _value, $Res Function(_$SeedInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? seed = null,
    Object? index = null,
  }) {
    return _then(_$SeedInfoImpl(
      seed: null == seed
          ? _value.seed
          : seed // ignore: cast_nullable_to_non_nullable
              as String,
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$SeedInfoImpl implements _SeedInfo {
  const _$SeedInfoImpl({required this.seed, required this.index});

  @override
  final String seed;
  @override
  final int index;

  @override
  String toString() {
    return 'SeedInfo(seed: $seed, index: $index)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SeedInfoImpl &&
            (identical(other.seed, seed) || other.seed == seed) &&
            (identical(other.index, index) || other.index == index));
  }

  @override
  int get hashCode => Object.hash(runtimeType, seed, index);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SeedInfoImplCopyWith<_$SeedInfoImpl> get copyWith =>
      __$$SeedInfoImplCopyWithImpl<_$SeedInfoImpl>(this, _$identity);
}

abstract class _SeedInfo implements SeedInfo {
  const factory _SeedInfo(
      {required final String seed, required final int index}) = _$SeedInfoImpl;

  @override
  String get seed;
  @override
  int get index;
  @override
  @JsonKey(ignore: true)
  _$$SeedInfoImplCopyWith<_$SeedInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TxMemo {
  String get address => throw _privateConstructorUsedError;
  String get memo => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TxMemoCopyWith<TxMemo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TxMemoCopyWith<$Res> {
  factory $TxMemoCopyWith(TxMemo value, $Res Function(TxMemo) then) =
      _$TxMemoCopyWithImpl<$Res, TxMemo>;
  @useResult
  $Res call({String address, String memo});
}

/// @nodoc
class _$TxMemoCopyWithImpl<$Res, $Val extends TxMemo>
    implements $TxMemoCopyWith<$Res> {
  _$TxMemoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? memo = null,
  }) {
    return _then(_value.copyWith(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      memo: null == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TxMemoImplCopyWith<$Res> implements $TxMemoCopyWith<$Res> {
  factory _$$TxMemoImplCopyWith(
          _$TxMemoImpl value, $Res Function(_$TxMemoImpl) then) =
      __$$TxMemoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String address, String memo});
}

/// @nodoc
class __$$TxMemoImplCopyWithImpl<$Res>
    extends _$TxMemoCopyWithImpl<$Res, _$TxMemoImpl>
    implements _$$TxMemoImplCopyWith<$Res> {
  __$$TxMemoImplCopyWithImpl(
      _$TxMemoImpl _value, $Res Function(_$TxMemoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? memo = null,
  }) {
    return _then(_$TxMemoImpl(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      memo: null == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$TxMemoImpl implements _TxMemo {
  const _$TxMemoImpl({required this.address, required this.memo});

  @override
  final String address;
  @override
  final String memo;

  @override
  String toString() {
    return 'TxMemo(address: $address, memo: $memo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TxMemoImpl &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.memo, memo) || other.memo == memo));
  }

  @override
  int get hashCode => Object.hash(runtimeType, address, memo);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TxMemoImplCopyWith<_$TxMemoImpl> get copyWith =>
      __$$TxMemoImplCopyWithImpl<_$TxMemoImpl>(this, _$identity);
}

abstract class _TxMemo implements TxMemo {
  const factory _TxMemo(
      {required final String address,
      required final String memo}) = _$TxMemoImpl;

  @override
  String get address;
  @override
  String get memo;
  @override
  @JsonKey(ignore: true)
  _$$TxMemoImplCopyWith<_$TxMemoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
