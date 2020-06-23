import 'dart:convert';

class WalletEntity {
  String mnemonics;

  Map<String, dynamic> keystores;

  WalletEntity.fromJson(Map<String, dynamic> map)
      : mnemonics = map['mnemonics'],
        keystores = map['keystores'];

  Map<String, dynamic> toJson() => {
        'mnemonics': mnemonics,
        'keystores': jsonEncode(keystores),
      };

  @override
  String toString() {
    return '{mnemonics: $mnemonics, keystores: ${jsonEncode(keystores)}}';
  }
}
