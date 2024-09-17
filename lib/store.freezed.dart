// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SeedInfo {
  String get seed => throw _privateConstructorUsedError;
  int get index => throw _privateConstructorUsedError;

  /// Create a copy of SeedInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of SeedInfo
  /// with the given fields replaced by the non-null parameter values.
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

  /// Create a copy of SeedInfo
  /// with the given fields replaced by the non-null parameter values.
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

  /// Create a copy of SeedInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of SeedInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SeedInfoImplCopyWith<_$SeedInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TxMemo {
  String get address => throw _privateConstructorUsedError;
  String get memo => throw _privateConstructorUsedError;

  /// Create a copy of TxMemo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of TxMemo
  /// with the given fields replaced by the non-null parameter values.
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

  /// Create a copy of TxMemo
  /// with the given fields replaced by the non-null parameter values.
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

  /// Create a copy of TxMemo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of TxMemo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TxMemoImplCopyWith<_$TxMemoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SwapAmount {
  String get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;

  /// Create a copy of SwapAmount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SwapAmountCopyWith<SwapAmount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SwapAmountCopyWith<$Res> {
  factory $SwapAmountCopyWith(
          SwapAmount value, $Res Function(SwapAmount) then) =
      _$SwapAmountCopyWithImpl<$Res, SwapAmount>;
  @useResult
  $Res call({String amount, String currency});
}

/// @nodoc
class _$SwapAmountCopyWithImpl<$Res, $Val extends SwapAmount>
    implements $SwapAmountCopyWith<$Res> {
  _$SwapAmountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SwapAmount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? currency = null,
  }) {
    return _then(_value.copyWith(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SwapAmountImplCopyWith<$Res>
    implements $SwapAmountCopyWith<$Res> {
  factory _$$SwapAmountImplCopyWith(
          _$SwapAmountImpl value, $Res Function(_$SwapAmountImpl) then) =
      __$$SwapAmountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String amount, String currency});
}

/// @nodoc
class __$$SwapAmountImplCopyWithImpl<$Res>
    extends _$SwapAmountCopyWithImpl<$Res, _$SwapAmountImpl>
    implements _$$SwapAmountImplCopyWith<$Res> {
  __$$SwapAmountImplCopyWithImpl(
      _$SwapAmountImpl _value, $Res Function(_$SwapAmountImpl) _then)
      : super(_value, _then);

  /// Create a copy of SwapAmount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? currency = null,
  }) {
    return _then(_$SwapAmountImpl(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SwapAmountImpl implements _SwapAmount {
  const _$SwapAmountImpl({required this.amount, required this.currency});

  @override
  final String amount;
  @override
  final String currency;

  @override
  String toString() {
    return 'SwapAmount(amount: $amount, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SwapAmountImpl &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @override
  int get hashCode => Object.hash(runtimeType, amount, currency);

  /// Create a copy of SwapAmount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SwapAmountImplCopyWith<_$SwapAmountImpl> get copyWith =>
      __$$SwapAmountImplCopyWithImpl<_$SwapAmountImpl>(this, _$identity);
}

abstract class _SwapAmount implements SwapAmount {
  const factory _SwapAmount(
      {required final String amount,
      required final String currency}) = _$SwapAmountImpl;

  @override
  String get amount;
  @override
  String get currency;

  /// Create a copy of SwapAmount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SwapAmountImplCopyWith<_$SwapAmountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SwapQuote _$SwapQuoteFromJson(Map<String, dynamic> json) {
  return _SwapQuote.fromJson(json);
}

/// @nodoc
mixin _$SwapQuote {
  String get estimated_amount => throw _privateConstructorUsedError;
  String get rate_id => throw _privateConstructorUsedError;
  String get valid_until => throw _privateConstructorUsedError;

  /// Serializes this SwapQuote to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SwapQuote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SwapQuoteCopyWith<SwapQuote> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SwapQuoteCopyWith<$Res> {
  factory $SwapQuoteCopyWith(SwapQuote value, $Res Function(SwapQuote) then) =
      _$SwapQuoteCopyWithImpl<$Res, SwapQuote>;
  @useResult
  $Res call({String estimated_amount, String rate_id, String valid_until});
}

/// @nodoc
class _$SwapQuoteCopyWithImpl<$Res, $Val extends SwapQuote>
    implements $SwapQuoteCopyWith<$Res> {
  _$SwapQuoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SwapQuote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? estimated_amount = null,
    Object? rate_id = null,
    Object? valid_until = null,
  }) {
    return _then(_value.copyWith(
      estimated_amount: null == estimated_amount
          ? _value.estimated_amount
          : estimated_amount // ignore: cast_nullable_to_non_nullable
              as String,
      rate_id: null == rate_id
          ? _value.rate_id
          : rate_id // ignore: cast_nullable_to_non_nullable
              as String,
      valid_until: null == valid_until
          ? _value.valid_until
          : valid_until // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SwapQuoteImplCopyWith<$Res>
    implements $SwapQuoteCopyWith<$Res> {
  factory _$$SwapQuoteImplCopyWith(
          _$SwapQuoteImpl value, $Res Function(_$SwapQuoteImpl) then) =
      __$$SwapQuoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String estimated_amount, String rate_id, String valid_until});
}

/// @nodoc
class __$$SwapQuoteImplCopyWithImpl<$Res>
    extends _$SwapQuoteCopyWithImpl<$Res, _$SwapQuoteImpl>
    implements _$$SwapQuoteImplCopyWith<$Res> {
  __$$SwapQuoteImplCopyWithImpl(
      _$SwapQuoteImpl _value, $Res Function(_$SwapQuoteImpl) _then)
      : super(_value, _then);

  /// Create a copy of SwapQuote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? estimated_amount = null,
    Object? rate_id = null,
    Object? valid_until = null,
  }) {
    return _then(_$SwapQuoteImpl(
      estimated_amount: null == estimated_amount
          ? _value.estimated_amount
          : estimated_amount // ignore: cast_nullable_to_non_nullable
              as String,
      rate_id: null == rate_id
          ? _value.rate_id
          : rate_id // ignore: cast_nullable_to_non_nullable
              as String,
      valid_until: null == valid_until
          ? _value.valid_until
          : valid_until // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SwapQuoteImpl implements _SwapQuote {
  const _$SwapQuoteImpl(
      {required this.estimated_amount,
      required this.rate_id,
      required this.valid_until});

  factory _$SwapQuoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$SwapQuoteImplFromJson(json);

  @override
  final String estimated_amount;
  @override
  final String rate_id;
  @override
  final String valid_until;

  @override
  String toString() {
    return 'SwapQuote(estimated_amount: $estimated_amount, rate_id: $rate_id, valid_until: $valid_until)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SwapQuoteImpl &&
            (identical(other.estimated_amount, estimated_amount) ||
                other.estimated_amount == estimated_amount) &&
            (identical(other.rate_id, rate_id) || other.rate_id == rate_id) &&
            (identical(other.valid_until, valid_until) ||
                other.valid_until == valid_until));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, estimated_amount, rate_id, valid_until);

  /// Create a copy of SwapQuote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SwapQuoteImplCopyWith<_$SwapQuoteImpl> get copyWith =>
      __$$SwapQuoteImplCopyWithImpl<_$SwapQuoteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SwapQuoteImplToJson(
      this,
    );
  }
}

abstract class _SwapQuote implements SwapQuote {
  const factory _SwapQuote(
      {required final String estimated_amount,
      required final String rate_id,
      required final String valid_until}) = _$SwapQuoteImpl;

  factory _SwapQuote.fromJson(Map<String, dynamic> json) =
      _$SwapQuoteImpl.fromJson;

  @override
  String get estimated_amount;
  @override
  String get rate_id;
  @override
  String get valid_until;

  /// Create a copy of SwapQuote
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SwapQuoteImplCopyWith<_$SwapQuoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SwapRequest _$SwapRequestFromJson(Map<String, dynamic> json) {
  return _SwapRequest.fromJson(json);
}

/// @nodoc
mixin _$SwapRequest {
  bool get fixed => throw _privateConstructorUsedError;
  String get rate_id => throw _privateConstructorUsedError;
  String get currency_from => throw _privateConstructorUsedError;
  String get currency_to => throw _privateConstructorUsedError;
  double get amount_from => throw _privateConstructorUsedError;
  String get address_to => throw _privateConstructorUsedError;

  /// Serializes this SwapRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SwapRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SwapRequestCopyWith<SwapRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SwapRequestCopyWith<$Res> {
  factory $SwapRequestCopyWith(
          SwapRequest value, $Res Function(SwapRequest) then) =
      _$SwapRequestCopyWithImpl<$Res, SwapRequest>;
  @useResult
  $Res call(
      {bool fixed,
      String rate_id,
      String currency_from,
      String currency_to,
      double amount_from,
      String address_to});
}

/// @nodoc
class _$SwapRequestCopyWithImpl<$Res, $Val extends SwapRequest>
    implements $SwapRequestCopyWith<$Res> {
  _$SwapRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SwapRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fixed = null,
    Object? rate_id = null,
    Object? currency_from = null,
    Object? currency_to = null,
    Object? amount_from = null,
    Object? address_to = null,
  }) {
    return _then(_value.copyWith(
      fixed: null == fixed
          ? _value.fixed
          : fixed // ignore: cast_nullable_to_non_nullable
              as bool,
      rate_id: null == rate_id
          ? _value.rate_id
          : rate_id // ignore: cast_nullable_to_non_nullable
              as String,
      currency_from: null == currency_from
          ? _value.currency_from
          : currency_from // ignore: cast_nullable_to_non_nullable
              as String,
      currency_to: null == currency_to
          ? _value.currency_to
          : currency_to // ignore: cast_nullable_to_non_nullable
              as String,
      amount_from: null == amount_from
          ? _value.amount_from
          : amount_from // ignore: cast_nullable_to_non_nullable
              as double,
      address_to: null == address_to
          ? _value.address_to
          : address_to // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SwapRequestImplCopyWith<$Res>
    implements $SwapRequestCopyWith<$Res> {
  factory _$$SwapRequestImplCopyWith(
          _$SwapRequestImpl value, $Res Function(_$SwapRequestImpl) then) =
      __$$SwapRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool fixed,
      String rate_id,
      String currency_from,
      String currency_to,
      double amount_from,
      String address_to});
}

/// @nodoc
class __$$SwapRequestImplCopyWithImpl<$Res>
    extends _$SwapRequestCopyWithImpl<$Res, _$SwapRequestImpl>
    implements _$$SwapRequestImplCopyWith<$Res> {
  __$$SwapRequestImplCopyWithImpl(
      _$SwapRequestImpl _value, $Res Function(_$SwapRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of SwapRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fixed = null,
    Object? rate_id = null,
    Object? currency_from = null,
    Object? currency_to = null,
    Object? amount_from = null,
    Object? address_to = null,
  }) {
    return _then(_$SwapRequestImpl(
      fixed: null == fixed
          ? _value.fixed
          : fixed // ignore: cast_nullable_to_non_nullable
              as bool,
      rate_id: null == rate_id
          ? _value.rate_id
          : rate_id // ignore: cast_nullable_to_non_nullable
              as String,
      currency_from: null == currency_from
          ? _value.currency_from
          : currency_from // ignore: cast_nullable_to_non_nullable
              as String,
      currency_to: null == currency_to
          ? _value.currency_to
          : currency_to // ignore: cast_nullable_to_non_nullable
              as String,
      amount_from: null == amount_from
          ? _value.amount_from
          : amount_from // ignore: cast_nullable_to_non_nullable
              as double,
      address_to: null == address_to
          ? _value.address_to
          : address_to // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SwapRequestImpl implements _SwapRequest {
  const _$SwapRequestImpl(
      {required this.fixed,
      required this.rate_id,
      required this.currency_from,
      required this.currency_to,
      required this.amount_from,
      required this.address_to});

  factory _$SwapRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$SwapRequestImplFromJson(json);

  @override
  final bool fixed;
  @override
  final String rate_id;
  @override
  final String currency_from;
  @override
  final String currency_to;
  @override
  final double amount_from;
  @override
  final String address_to;

  @override
  String toString() {
    return 'SwapRequest(fixed: $fixed, rate_id: $rate_id, currency_from: $currency_from, currency_to: $currency_to, amount_from: $amount_from, address_to: $address_to)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SwapRequestImpl &&
            (identical(other.fixed, fixed) || other.fixed == fixed) &&
            (identical(other.rate_id, rate_id) || other.rate_id == rate_id) &&
            (identical(other.currency_from, currency_from) ||
                other.currency_from == currency_from) &&
            (identical(other.currency_to, currency_to) ||
                other.currency_to == currency_to) &&
            (identical(other.amount_from, amount_from) ||
                other.amount_from == amount_from) &&
            (identical(other.address_to, address_to) ||
                other.address_to == address_to));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, fixed, rate_id, currency_from,
      currency_to, amount_from, address_to);

  /// Create a copy of SwapRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SwapRequestImplCopyWith<_$SwapRequestImpl> get copyWith =>
      __$$SwapRequestImplCopyWithImpl<_$SwapRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SwapRequestImplToJson(
      this,
    );
  }
}

abstract class _SwapRequest implements SwapRequest {
  const factory _SwapRequest(
      {required final bool fixed,
      required final String rate_id,
      required final String currency_from,
      required final String currency_to,
      required final double amount_from,
      required final String address_to}) = _$SwapRequestImpl;

  factory _SwapRequest.fromJson(Map<String, dynamic> json) =
      _$SwapRequestImpl.fromJson;

  @override
  bool get fixed;
  @override
  String get rate_id;
  @override
  String get currency_from;
  @override
  String get currency_to;
  @override
  double get amount_from;
  @override
  String get address_to;

  /// Create a copy of SwapRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SwapRequestImplCopyWith<_$SwapRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SwapLeg _$SwapLegFromJson(Map<String, dynamic> json) {
  return _SwapLeg.fromJson(json);
}

/// @nodoc
mixin _$SwapLeg {
  String get symbol => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;
  String get validation_address => throw _privateConstructorUsedError;
  String get address_explorer => throw _privateConstructorUsedError;
  String get tx_explorer => throw _privateConstructorUsedError;

  /// Serializes this SwapLeg to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SwapLeg
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SwapLegCopyWith<SwapLeg> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SwapLegCopyWith<$Res> {
  factory $SwapLegCopyWith(SwapLeg value, $Res Function(SwapLeg) then) =
      _$SwapLegCopyWithImpl<$Res, SwapLeg>;
  @useResult
  $Res call(
      {String symbol,
      String name,
      String image,
      String validation_address,
      String address_explorer,
      String tx_explorer});
}

/// @nodoc
class _$SwapLegCopyWithImpl<$Res, $Val extends SwapLeg>
    implements $SwapLegCopyWith<$Res> {
  _$SwapLegCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SwapLeg
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? name = null,
    Object? image = null,
    Object? validation_address = null,
    Object? address_explorer = null,
    Object? tx_explorer = null,
  }) {
    return _then(_value.copyWith(
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      validation_address: null == validation_address
          ? _value.validation_address
          : validation_address // ignore: cast_nullable_to_non_nullable
              as String,
      address_explorer: null == address_explorer
          ? _value.address_explorer
          : address_explorer // ignore: cast_nullable_to_non_nullable
              as String,
      tx_explorer: null == tx_explorer
          ? _value.tx_explorer
          : tx_explorer // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SwapLegImplCopyWith<$Res> implements $SwapLegCopyWith<$Res> {
  factory _$$SwapLegImplCopyWith(
          _$SwapLegImpl value, $Res Function(_$SwapLegImpl) then) =
      __$$SwapLegImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String symbol,
      String name,
      String image,
      String validation_address,
      String address_explorer,
      String tx_explorer});
}

/// @nodoc
class __$$SwapLegImplCopyWithImpl<$Res>
    extends _$SwapLegCopyWithImpl<$Res, _$SwapLegImpl>
    implements _$$SwapLegImplCopyWith<$Res> {
  __$$SwapLegImplCopyWithImpl(
      _$SwapLegImpl _value, $Res Function(_$SwapLegImpl) _then)
      : super(_value, _then);

  /// Create a copy of SwapLeg
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? name = null,
    Object? image = null,
    Object? validation_address = null,
    Object? address_explorer = null,
    Object? tx_explorer = null,
  }) {
    return _then(_$SwapLegImpl(
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      validation_address: null == validation_address
          ? _value.validation_address
          : validation_address // ignore: cast_nullable_to_non_nullable
              as String,
      address_explorer: null == address_explorer
          ? _value.address_explorer
          : address_explorer // ignore: cast_nullable_to_non_nullable
              as String,
      tx_explorer: null == tx_explorer
          ? _value.tx_explorer
          : tx_explorer // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SwapLegImpl implements _SwapLeg {
  const _$SwapLegImpl(
      {required this.symbol,
      required this.name,
      required this.image,
      required this.validation_address,
      required this.address_explorer,
      required this.tx_explorer});

  factory _$SwapLegImpl.fromJson(Map<String, dynamic> json) =>
      _$$SwapLegImplFromJson(json);

  @override
  final String symbol;
  @override
  final String name;
  @override
  final String image;
  @override
  final String validation_address;
  @override
  final String address_explorer;
  @override
  final String tx_explorer;

  @override
  String toString() {
    return 'SwapLeg(symbol: $symbol, name: $name, image: $image, validation_address: $validation_address, address_explorer: $address_explorer, tx_explorer: $tx_explorer)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SwapLegImpl &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.validation_address, validation_address) ||
                other.validation_address == validation_address) &&
            (identical(other.address_explorer, address_explorer) ||
                other.address_explorer == address_explorer) &&
            (identical(other.tx_explorer, tx_explorer) ||
                other.tx_explorer == tx_explorer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, symbol, name, image,
      validation_address, address_explorer, tx_explorer);

  /// Create a copy of SwapLeg
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SwapLegImplCopyWith<_$SwapLegImpl> get copyWith =>
      __$$SwapLegImplCopyWithImpl<_$SwapLegImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SwapLegImplToJson(
      this,
    );
  }
}

abstract class _SwapLeg implements SwapLeg {
  const factory _SwapLeg(
      {required final String symbol,
      required final String name,
      required final String image,
      required final String validation_address,
      required final String address_explorer,
      required final String tx_explorer}) = _$SwapLegImpl;

  factory _SwapLeg.fromJson(Map<String, dynamic> json) = _$SwapLegImpl.fromJson;

  @override
  String get symbol;
  @override
  String get name;
  @override
  String get image;
  @override
  String get validation_address;
  @override
  String get address_explorer;
  @override
  String get tx_explorer;

  /// Create a copy of SwapLeg
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SwapLegImplCopyWith<_$SwapLegImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SwapResponse _$SwapResponseFromJson(Map<String, dynamic> json) {
  return _SwapResponse.fromJson(json);
}

/// @nodoc
mixin _$SwapResponse {
  String get id => throw _privateConstructorUsedError;
  String get timestamp => throw _privateConstructorUsedError;
  String get currency_from => throw _privateConstructorUsedError;
  String get currency_to => throw _privateConstructorUsedError;
  String get amount_from => throw _privateConstructorUsedError;
  String get amount_to => throw _privateConstructorUsedError;
  String get address_from => throw _privateConstructorUsedError;
  String get address_to => throw _privateConstructorUsedError;

  /// Serializes this SwapResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SwapResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SwapResponseCopyWith<SwapResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SwapResponseCopyWith<$Res> {
  factory $SwapResponseCopyWith(
          SwapResponse value, $Res Function(SwapResponse) then) =
      _$SwapResponseCopyWithImpl<$Res, SwapResponse>;
  @useResult
  $Res call(
      {String id,
      String timestamp,
      String currency_from,
      String currency_to,
      String amount_from,
      String amount_to,
      String address_from,
      String address_to});
}

/// @nodoc
class _$SwapResponseCopyWithImpl<$Res, $Val extends SwapResponse>
    implements $SwapResponseCopyWith<$Res> {
  _$SwapResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SwapResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timestamp = null,
    Object? currency_from = null,
    Object? currency_to = null,
    Object? amount_from = null,
    Object? amount_to = null,
    Object? address_from = null,
    Object? address_to = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
      currency_from: null == currency_from
          ? _value.currency_from
          : currency_from // ignore: cast_nullable_to_non_nullable
              as String,
      currency_to: null == currency_to
          ? _value.currency_to
          : currency_to // ignore: cast_nullable_to_non_nullable
              as String,
      amount_from: null == amount_from
          ? _value.amount_from
          : amount_from // ignore: cast_nullable_to_non_nullable
              as String,
      amount_to: null == amount_to
          ? _value.amount_to
          : amount_to // ignore: cast_nullable_to_non_nullable
              as String,
      address_from: null == address_from
          ? _value.address_from
          : address_from // ignore: cast_nullable_to_non_nullable
              as String,
      address_to: null == address_to
          ? _value.address_to
          : address_to // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SwapResponseImplCopyWith<$Res>
    implements $SwapResponseCopyWith<$Res> {
  factory _$$SwapResponseImplCopyWith(
          _$SwapResponseImpl value, $Res Function(_$SwapResponseImpl) then) =
      __$$SwapResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String timestamp,
      String currency_from,
      String currency_to,
      String amount_from,
      String amount_to,
      String address_from,
      String address_to});
}

/// @nodoc
class __$$SwapResponseImplCopyWithImpl<$Res>
    extends _$SwapResponseCopyWithImpl<$Res, _$SwapResponseImpl>
    implements _$$SwapResponseImplCopyWith<$Res> {
  __$$SwapResponseImplCopyWithImpl(
      _$SwapResponseImpl _value, $Res Function(_$SwapResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of SwapResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timestamp = null,
    Object? currency_from = null,
    Object? currency_to = null,
    Object? amount_from = null,
    Object? amount_to = null,
    Object? address_from = null,
    Object? address_to = null,
  }) {
    return _then(_$SwapResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
      currency_from: null == currency_from
          ? _value.currency_from
          : currency_from // ignore: cast_nullable_to_non_nullable
              as String,
      currency_to: null == currency_to
          ? _value.currency_to
          : currency_to // ignore: cast_nullable_to_non_nullable
              as String,
      amount_from: null == amount_from
          ? _value.amount_from
          : amount_from // ignore: cast_nullable_to_non_nullable
              as String,
      amount_to: null == amount_to
          ? _value.amount_to
          : amount_to // ignore: cast_nullable_to_non_nullable
              as String,
      address_from: null == address_from
          ? _value.address_from
          : address_from // ignore: cast_nullable_to_non_nullable
              as String,
      address_to: null == address_to
          ? _value.address_to
          : address_to // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SwapResponseImpl implements _SwapResponse {
  const _$SwapResponseImpl(
      {required this.id,
      required this.timestamp,
      required this.currency_from,
      required this.currency_to,
      required this.amount_from,
      required this.amount_to,
      required this.address_from,
      required this.address_to});

  factory _$SwapResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SwapResponseImplFromJson(json);

  @override
  final String id;
  @override
  final String timestamp;
  @override
  final String currency_from;
  @override
  final String currency_to;
  @override
  final String amount_from;
  @override
  final String amount_to;
  @override
  final String address_from;
  @override
  final String address_to;

  @override
  String toString() {
    return 'SwapResponse(id: $id, timestamp: $timestamp, currency_from: $currency_from, currency_to: $currency_to, amount_from: $amount_from, amount_to: $amount_to, address_from: $address_from, address_to: $address_to)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SwapResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.currency_from, currency_from) ||
                other.currency_from == currency_from) &&
            (identical(other.currency_to, currency_to) ||
                other.currency_to == currency_to) &&
            (identical(other.amount_from, amount_from) ||
                other.amount_from == amount_from) &&
            (identical(other.amount_to, amount_to) ||
                other.amount_to == amount_to) &&
            (identical(other.address_from, address_from) ||
                other.address_from == address_from) &&
            (identical(other.address_to, address_to) ||
                other.address_to == address_to));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, timestamp, currency_from,
      currency_to, amount_from, amount_to, address_from, address_to);

  /// Create a copy of SwapResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SwapResponseImplCopyWith<_$SwapResponseImpl> get copyWith =>
      __$$SwapResponseImplCopyWithImpl<_$SwapResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SwapResponseImplToJson(
      this,
    );
  }
}

abstract class _SwapResponse implements SwapResponse {
  const factory _SwapResponse(
      {required final String id,
      required final String timestamp,
      required final String currency_from,
      required final String currency_to,
      required final String amount_from,
      required final String amount_to,
      required final String address_from,
      required final String address_to}) = _$SwapResponseImpl;

  factory _SwapResponse.fromJson(Map<String, dynamic> json) =
      _$SwapResponseImpl.fromJson;

  @override
  String get id;
  @override
  String get timestamp;
  @override
  String get currency_from;
  @override
  String get currency_to;
  @override
  String get amount_from;
  @override
  String get amount_to;
  @override
  String get address_from;
  @override
  String get address_to;

  /// Create a copy of SwapResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SwapResponseImplCopyWith<_$SwapResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Election _$ElectionFromJson(Map<String, dynamic> json) {
  return _Election.fromJson(json);
}

/// @nodoc
mixin _$Election {
  String get name => throw _privateConstructorUsedError;
  int get start_height => throw _privateConstructorUsedError;
  int get end_height => throw _privateConstructorUsedError;
  int get close_height => throw _privateConstructorUsedError;
  String get submit_url => throw _privateConstructorUsedError;
  List<String> get candidates => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  /// Serializes this Election to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Election
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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
      int start_height,
      int end_height,
      int close_height,
      String submit_url,
      List<String> candidates,
      String status});
}

/// @nodoc
class _$ElectionCopyWithImpl<$Res, $Val extends Election>
    implements $ElectionCopyWith<$Res> {
  _$ElectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Election
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? start_height = null,
    Object? end_height = null,
    Object? close_height = null,
    Object? submit_url = null,
    Object? candidates = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      start_height: null == start_height
          ? _value.start_height
          : start_height // ignore: cast_nullable_to_non_nullable
              as int,
      end_height: null == end_height
          ? _value.end_height
          : end_height // ignore: cast_nullable_to_non_nullable
              as int,
      close_height: null == close_height
          ? _value.close_height
          : close_height // ignore: cast_nullable_to_non_nullable
              as int,
      submit_url: null == submit_url
          ? _value.submit_url
          : submit_url // ignore: cast_nullable_to_non_nullable
              as String,
      candidates: null == candidates
          ? _value.candidates
          : candidates // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
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
      int start_height,
      int end_height,
      int close_height,
      String submit_url,
      List<String> candidates,
      String status});
}

/// @nodoc
class __$$ElectionImplCopyWithImpl<$Res>
    extends _$ElectionCopyWithImpl<$Res, _$ElectionImpl>
    implements _$$ElectionImplCopyWith<$Res> {
  __$$ElectionImplCopyWithImpl(
      _$ElectionImpl _value, $Res Function(_$ElectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Election
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? start_height = null,
    Object? end_height = null,
    Object? close_height = null,
    Object? submit_url = null,
    Object? candidates = null,
    Object? status = null,
  }) {
    return _then(_$ElectionImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      start_height: null == start_height
          ? _value.start_height
          : start_height // ignore: cast_nullable_to_non_nullable
              as int,
      end_height: null == end_height
          ? _value.end_height
          : end_height // ignore: cast_nullable_to_non_nullable
              as int,
      close_height: null == close_height
          ? _value.close_height
          : close_height // ignore: cast_nullable_to_non_nullable
              as int,
      submit_url: null == submit_url
          ? _value.submit_url
          : submit_url // ignore: cast_nullable_to_non_nullable
              as String,
      candidates: null == candidates
          ? _value._candidates
          : candidates // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ElectionImpl implements _Election {
  const _$ElectionImpl(
      {required this.name,
      required this.start_height,
      required this.end_height,
      required this.close_height,
      required this.submit_url,
      required final List<String> candidates,
      required this.status})
      : _candidates = candidates;

  factory _$ElectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ElectionImplFromJson(json);

  @override
  final String name;
  @override
  final int start_height;
  @override
  final int end_height;
  @override
  final int close_height;
  @override
  final String submit_url;
  final List<String> _candidates;
  @override
  List<String> get candidates {
    if (_candidates is EqualUnmodifiableListView) return _candidates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_candidates);
  }

  @override
  final String status;

  @override
  String toString() {
    return 'Election(name: $name, start_height: $start_height, end_height: $end_height, close_height: $close_height, submit_url: $submit_url, candidates: $candidates, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ElectionImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.start_height, start_height) ||
                other.start_height == start_height) &&
            (identical(other.end_height, end_height) ||
                other.end_height == end_height) &&
            (identical(other.close_height, close_height) ||
                other.close_height == close_height) &&
            (identical(other.submit_url, submit_url) ||
                other.submit_url == submit_url) &&
            const DeepCollectionEquality()
                .equals(other._candidates, _candidates) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      start_height,
      end_height,
      close_height,
      submit_url,
      const DeepCollectionEquality().hash(_candidates),
      status);

  /// Create a copy of Election
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ElectionImplCopyWith<_$ElectionImpl> get copyWith =>
      __$$ElectionImplCopyWithImpl<_$ElectionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ElectionImplToJson(
      this,
    );
  }
}

abstract class _Election implements Election {
  const factory _Election(
      {required final String name,
      required final int start_height,
      required final int end_height,
      required final int close_height,
      required final String submit_url,
      required final List<String> candidates,
      required final String status}) = _$ElectionImpl;

  factory _Election.fromJson(Map<String, dynamic> json) =
      _$ElectionImpl.fromJson;

  @override
  String get name;
  @override
  int get start_height;
  @override
  int get end_height;
  @override
  int get close_height;
  @override
  String get submit_url;
  @override
  List<String> get candidates;
  @override
  String get status;

  /// Create a copy of Election
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ElectionImplCopyWith<_$ElectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Vote {
  Election get election => throw _privateConstructorUsedError;
  List<int> get ids => throw _privateConstructorUsedError;
  int? get candidate => throw _privateConstructorUsedError;

  /// Create a copy of Vote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VoteCopyWith<Vote> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VoteCopyWith<$Res> {
  factory $VoteCopyWith(Vote value, $Res Function(Vote) then) =
      _$VoteCopyWithImpl<$Res, Vote>;
  @useResult
  $Res call({Election election, List<int> ids, int? candidate});

  $ElectionCopyWith<$Res> get election;
}

/// @nodoc
class _$VoteCopyWithImpl<$Res, $Val extends Vote>
    implements $VoteCopyWith<$Res> {
  _$VoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Vote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? election = null,
    Object? ids = null,
    Object? candidate = freezed,
  }) {
    return _then(_value.copyWith(
      election: null == election
          ? _value.election
          : election // ignore: cast_nullable_to_non_nullable
              as Election,
      ids: null == ids
          ? _value.ids
          : ids // ignore: cast_nullable_to_non_nullable
              as List<int>,
      candidate: freezed == candidate
          ? _value.candidate
          : candidate // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  /// Create a copy of Vote
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ElectionCopyWith<$Res> get election {
    return $ElectionCopyWith<$Res>(_value.election, (value) {
      return _then(_value.copyWith(election: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VoteImplCopyWith<$Res> implements $VoteCopyWith<$Res> {
  factory _$$VoteImplCopyWith(
          _$VoteImpl value, $Res Function(_$VoteImpl) then) =
      __$$VoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Election election, List<int> ids, int? candidate});

  @override
  $ElectionCopyWith<$Res> get election;
}

/// @nodoc
class __$$VoteImplCopyWithImpl<$Res>
    extends _$VoteCopyWithImpl<$Res, _$VoteImpl>
    implements _$$VoteImplCopyWith<$Res> {
  __$$VoteImplCopyWithImpl(_$VoteImpl _value, $Res Function(_$VoteImpl) _then)
      : super(_value, _then);

  /// Create a copy of Vote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? election = null,
    Object? ids = null,
    Object? candidate = freezed,
  }) {
    return _then(_$VoteImpl(
      election: null == election
          ? _value.election
          : election // ignore: cast_nullable_to_non_nullable
              as Election,
      ids: null == ids
          ? _value._ids
          : ids // ignore: cast_nullable_to_non_nullable
              as List<int>,
      candidate: freezed == candidate
          ? _value.candidate
          : candidate // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$VoteImpl implements _Vote {
  const _$VoteImpl(
      {required this.election, required final List<int> ids, this.candidate})
      : _ids = ids;

  @override
  final Election election;
  final List<int> _ids;
  @override
  List<int> get ids {
    if (_ids is EqualUnmodifiableListView) return _ids;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ids);
  }

  @override
  final int? candidate;

  @override
  String toString() {
    return 'Vote(election: $election, ids: $ids, candidate: $candidate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VoteImpl &&
            (identical(other.election, election) ||
                other.election == election) &&
            const DeepCollectionEquality().equals(other._ids, _ids) &&
            (identical(other.candidate, candidate) ||
                other.candidate == candidate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, election,
      const DeepCollectionEquality().hash(_ids), candidate);

  /// Create a copy of Vote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VoteImplCopyWith<_$VoteImpl> get copyWith =>
      __$$VoteImplCopyWithImpl<_$VoteImpl>(this, _$identity);
}

abstract class _Vote implements Vote {
  const factory _Vote(
      {required final Election election,
      required final List<int> ids,
      final int? candidate}) = _$VoteImpl;

  @override
  Election get election;
  @override
  List<int> get ids;
  @override
  int? get candidate;

  /// Create a copy of Vote
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VoteImplCopyWith<_$VoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
