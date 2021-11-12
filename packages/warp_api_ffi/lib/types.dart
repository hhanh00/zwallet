import 'package:json_annotation/json_annotation.dart';

part 'types.g.dart';

@JsonSerializable()
class Recipient {
  // ignore: non_constant_identifier_names
  final String address;
  final int amount;
  final String memo;
  // ignore: non_constant_identifier_names
  final int max_amount_per_note;

  Recipient(this.address, this.amount, this.memo, this.max_amount_per_note);

  factory Recipient.fromJson(Map<String, dynamic> json) =>
      _$RecipientFromJson(json);

  Map<String, dynamic> toJson() => _$RecipientToJson(this);
}

