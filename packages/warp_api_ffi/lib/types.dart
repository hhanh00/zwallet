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

@JsonSerializable()
class TxOutput {
  final int id;
  final String address;
  final int amount;
  final int pool;

  TxOutput(this.id, this.address, this.amount, this.pool);

  factory TxOutput.fromJson(Map<String, dynamic> json) =>
      _$TxOutputFromJson(json);

  Map<String, dynamic> toJson() => _$TxOutputToJson(this);
}

@JsonSerializable()
class TxReport {
  final List<TxOutput> outputs;
  final int transparent;
  final int sapling;
  final int orchard;
  final int net_sapling;
  final int net_orchard;
  final int fee;
  final int privacy_level;

  TxReport(this.outputs, this.transparent, this.sapling,
      this.orchard, this.net_sapling, this.net_orchard,
      this.fee, this.privacy_level);

  factory TxReport.fromJson(Map<String, dynamic> json) =>
      _$TxReportFromJson(json);

  Map<String, dynamic> toJson() => _$TxReportToJson(this);
}

@JsonSerializable()
class Backup {
  final String name;
  final String? seed;
  final int index;
  final String? sk;
  final String ivk;

  Backup(this.name, this.seed, this.index, this.sk, this.ivk);

  String value() {
    switch (type) {
      case 0:
        return seed!;
      case 1:
        return sk!;
      case 2:
        return ivk;
    }
    return "";
  }

  int get type {
    if (seed != null)
      return 0;
    else if (sk != null)
      return 1;
    return 2;
  }

  factory Backup.fromJson(Map<String, dynamic> json) =>
      _$BackupFromJson(json);

  Map<String, dynamic> toJson() => _$BackupToJson(this);
}

@JsonSerializable()
class Servers {
  final List<String> urls;
  Servers(this.urls);

  factory Servers.fromJson(Map<String, dynamic> json) =>
      _$ServersFromJson(json);

  Map<String, dynamic> toJson() => _$ServersToJson(this);
}
