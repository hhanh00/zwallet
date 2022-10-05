import 'package:json_annotation/json_annotation.dart';

part 'types.g.dart';

@JsonSerializable()
class Recipient {
  // ignore: non_constant_identifier_names
  final String address;
  final int amount;
  // ignore: non_constant_identifier_names
  final bool reply_to;
  final String subject;
  final String memo;
  // ignore: non_constant_identifier_names
  final int max_amount_per_note;

  Recipient(this.address, this.amount, this.reply_to, this.subject, this.memo, this.max_amount_per_note);

  factory Recipient.fromJson(Map<String, dynamic> json) =>
      _$RecipientFromJson(json);

  Map<String, dynamic> toJson() => _$RecipientToJson(this);
}

@JsonSerializable()
class RaptorQDrops {
  final List<String> drops;

  RaptorQDrops(this.drops);

  factory RaptorQDrops.fromJson(Map<String, dynamic> json) =>
      _$RaptorQDropsFromJson(json);

  Map<String, dynamic> toJson() => _$RaptorQDropsToJson(this);
}

@JsonSerializable()
class UnsignedTxSummary {
  final List<RecipientSummary> recipients;

  UnsignedTxSummary(this.recipients);

  factory UnsignedTxSummary.fromJson(Map<String, dynamic> json) =>
      _$UnsignedTxSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$UnsignedTxSummaryToJson(this);
}

@JsonSerializable()
class RecipientSummary {
  final int amount;
  final String address;

  RecipientSummary(this.amount, this.address);

  factory RecipientSummary.fromJson(Map<String, dynamic> json) =>
      _$RecipientSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$RecipientSummaryToJson(this);
}

@JsonSerializable()
class KeyPack {
  final String t_addr;
  final String t_key;
  final String z_addr;
  final String z_key;

  KeyPack(this.t_addr, this.t_key, this.z_addr, this.z_key);

  factory KeyPack.fromJson(Map<String, dynamic> json) =>
      _$KeyPackFromJson(json);

  Map<String, dynamic> toJson() => _$KeyPackToJson(this);
}

@JsonSerializable()
class Progress {
  final int height;
  final int trial_decryptions;
  final int downloaded;

  Progress(this.height, this.trial_decryptions, this.downloaded);

  factory Progress.fromJson(Map<String, dynamic> json) =>
      _$ProgressFromJson(json);

  Map<String, dynamic> toJson() => _$ProgressToJson(this);
}
