import 'package:YWallet/src/rust/api/simple.dart';
import 'package:mobx/mobx.dart';

part 'vote_data.g.dart';

class ElectionInfo = _ElectionInfo with _$ElectionInfo;

abstract class _ElectionInfo with Store {
  @observable String? filepath;
  @observable Election? election;
}
