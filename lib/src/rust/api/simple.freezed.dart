// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'simple.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Election {
  String get name => throw _privateConstructorUsedError;
  int get startHeight => throw _privateConstructorUsedError;
  int get endHeight => throw _privateConstructorUsedError;
  String get question => throw _privateConstructorUsedError;
  List<String> get candidates => throw _privateConstructorUsedError;
  bool get signatureRequired => throw _privateConstructorUsedError;
  bool get downloaded => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ElectionCopyWith<Election> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ElectionCopyWith<$Res> {
  factory $ElectionCopyWith(Election value, $Res Function(Election) then) =
      _$ElectionCopyWithImpl<$Res, Election>;
  @useResult
  $Res call(
      {String name,
      int startHeight,
      int endHeight,
      String question,
      List<String> candidates,
      bool signatureRequired,
      bool downloaded});
}

/// @nodoc
class _$ElectionCopyWithImpl<$Res, $Val extends Election>
    implements $ElectionCopyWith<$Res> {
  _$ElectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? startHeight = null,
    Object? endHeight = null,
    Object? question = null,
    Object? candidates = null,
    Object? signatureRequired = null,
    Object? downloaded = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      startHeight: null == startHeight
          ? _value.startHeight
          : startHeight // ignore: cast_nullable_to_non_nullable
              as int,
      endHeight: null == endHeight
          ? _value.endHeight
          : endHeight // ignore: cast_nullable_to_non_nullable
              as int,
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      candidates: null == candidates
          ? _value.candidates
          : candidates // ignore: cast_nullable_to_non_nullable
              as List<String>,
      signatureRequired: null == signatureRequired
          ? _value.signatureRequired
          : signatureRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      downloaded: null == downloaded
          ? _value.downloaded
          : downloaded // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ElectionImplCopyWith<$Res>
    implements $ElectionCopyWith<$Res> {
  factory _$$ElectionImplCopyWith(
          _$ElectionImpl value, $Res Function(_$ElectionImpl) then) =
      __$$ElectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      int startHeight,
      int endHeight,
      String question,
      List<String> candidates,
      bool signatureRequired,
      bool downloaded});
}

/// @nodoc
class __$$ElectionImplCopyWithImpl<$Res>
    extends _$ElectionCopyWithImpl<$Res, _$ElectionImpl>
    implements _$$ElectionImplCopyWith<$Res> {
  __$$ElectionImplCopyWithImpl(
      _$ElectionImpl _value, $Res Function(_$ElectionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? startHeight = null,
    Object? endHeight = null,
    Object? question = null,
    Object? candidates = null,
    Object? signatureRequired = null,
    Object? downloaded = null,
  }) {
    return _then(_$ElectionImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      startHeight: null == startHeight
          ? _value.startHeight
          : startHeight // ignore: cast_nullable_to_non_nullable
              as int,
      endHeight: null == endHeight
          ? _value.endHeight
          : endHeight // ignore: cast_nullable_to_non_nullable
              as int,
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      candidates: null == candidates
          ? _value._candidates
          : candidates // ignore: cast_nullable_to_non_nullable
              as List<String>,
      signatureRequired: null == signatureRequired
          ? _value.signatureRequired
          : signatureRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      downloaded: null == downloaded
          ? _value.downloaded
          : downloaded // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ElectionImpl implements _Election {
  const _$ElectionImpl(
      {required this.name,
      required this.startHeight,
      required this.endHeight,
      required this.question,
      required final List<String> candidates,
      required this.signatureRequired,
      required this.downloaded})
      : _candidates = candidates;

  @override
  final String name;
  @override
  final int startHeight;
  @override
  final int endHeight;
  @override
  final String question;
  final List<String> _candidates;
  @override
  List<String> get candidates {
    if (_candidates is EqualUnmodifiableListView) return _candidates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_candidates);
  }

  @override
  final bool signatureRequired;
  @override
  final bool downloaded;

  @override
  String toString() {
    return 'Election(name: $name, startHeight: $startHeight, endHeight: $endHeight, question: $question, candidates: $candidates, signatureRequired: $signatureRequired, downloaded: $downloaded)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ElectionImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.startHeight, startHeight) ||
                other.startHeight == startHeight) &&
            (identical(other.endHeight, endHeight) ||
                other.endHeight == endHeight) &&
            (identical(other.question, question) ||
                other.question == question) &&
            const DeepCollectionEquality()
                .equals(other._candidates, _candidates) &&
            (identical(other.signatureRequired, signatureRequired) ||
                other.signatureRequired == signatureRequired) &&
            (identical(other.downloaded, downloaded) ||
                other.downloaded == downloaded));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      startHeight,
      endHeight,
      question,
      const DeepCollectionEquality().hash(_candidates),
      signatureRequired,
      downloaded);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ElectionImplCopyWith<_$ElectionImpl> get copyWith =>
      __$$ElectionImplCopyWithImpl<_$ElectionImpl>(this, _$identity);
}

abstract class _Election implements Election {
  const factory _Election(
      {required final String name,
      required final int startHeight,
      required final int endHeight,
      required final String question,
      required final List<String> candidates,
      required final bool signatureRequired,
      required final bool downloaded}) = _$ElectionImpl;

  @override
  String get name;
  @override
  int get startHeight;
  @override
  int get endHeight;
  @override
  String get question;
  @override
  List<String> get candidates;
  @override
  bool get signatureRequired;
  @override
  bool get downloaded;
  @override
  @JsonKey(ignore: true)
  _$$ElectionImplCopyWith<_$ElectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Vote {
  String get hash => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  BigInt get amount => throw _privateConstructorUsedError;
  int? get height => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $VoteCopyWith<Vote> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VoteCopyWith<$Res> {
  factory $VoteCopyWith(Vote value, $Res Function(Vote) then) =
      _$VoteCopyWithImpl<$Res, Vote>;
  @useResult
  $Res call({String hash, String address, BigInt amount, int? height});
}

/// @nodoc
class _$VoteCopyWithImpl<$Res, $Val extends Vote>
    implements $VoteCopyWith<$Res> {
  _$VoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hash = null,
    Object? address = null,
    Object? amount = null,
    Object? height = freezed,
  }) {
    return _then(_value.copyWith(
      hash: null == hash
          ? _value.hash
          : hash // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as BigInt,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VoteImplCopyWith<$Res> implements $VoteCopyWith<$Res> {
  factory _$$VoteImplCopyWith(
          _$VoteImpl value, $Res Function(_$VoteImpl) then) =
      __$$VoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String hash, String address, BigInt amount, int? height});
}

/// @nodoc
class __$$VoteImplCopyWithImpl<$Res>
    extends _$VoteCopyWithImpl<$Res, _$VoteImpl>
    implements _$$VoteImplCopyWith<$Res> {
  __$$VoteImplCopyWithImpl(_$VoteImpl _value, $Res Function(_$VoteImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hash = null,
    Object? address = null,
    Object? amount = null,
    Object? height = freezed,
  }) {
    return _then(_$VoteImpl(
      hash: null == hash
          ? _value.hash
          : hash // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as BigInt,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$VoteImpl implements _Vote {
  const _$VoteImpl(
      {required this.hash,
      required this.address,
      required this.amount,
      this.height});

  @override
  final String hash;
  @override
  final String address;
  @override
  final BigInt amount;
  @override
  final int? height;

  @override
  String toString() {
    return 'Vote(hash: $hash, address: $address, amount: $amount, height: $height)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VoteImpl &&
            (identical(other.hash, hash) || other.hash == hash) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.height, height) || other.height == height));
  }

  @override
  int get hashCode => Object.hash(runtimeType, hash, address, amount, height);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VoteImplCopyWith<_$VoteImpl> get copyWith =>
      __$$VoteImplCopyWithImpl<_$VoteImpl>(this, _$identity);
}

abstract class _Vote implements Vote {
  const factory _Vote(
      {required final String hash,
      required final String address,
      required final BigInt amount,
      final int? height}) = _$VoteImpl;

  @override
  String get hash;
  @override
  String get address;
  @override
  BigInt get amount;
  @override
  int? get height;
  @override
  @JsonKey(ignore: true)
  _$$VoteImplCopyWith<_$VoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
