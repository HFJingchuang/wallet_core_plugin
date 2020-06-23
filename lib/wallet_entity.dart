import 'dart:convert';

class WalletEntity {
  String mnemonics;
  String mncFile;
  Map<String, dynamic> keyStores;

  WalletEntity.fromJson(Map<String, dynamic> map)
      : mnemonics = map['mnemonics'],
        mncFile = map['mncFile'],
        keyStores = map['keyStores'];

  Map<String, dynamic> toJson() => {
        'mnemonics': mnemonics,
        'mncFile': mncFile,
        'keyStores': jsonEncode(keyStores),
      };

  @override
  String toString() {
    return '{mnemonics: $mnemonics, mncFile:$mncFile, keyStores: ${jsonEncode(keyStores)}}';
  }
}
