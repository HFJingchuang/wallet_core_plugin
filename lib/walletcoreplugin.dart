import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:walletcoreplugin/wallet_entity.dart';

import 'common/constant.dart';

class Walletcoreplugin {
  static const MethodChannel _channel =
      const MethodChannel('com.jch/wallet_core_plugin');

  /// 创建钱包
  ///
  /// [chainType] use [ChainType].
  /// [language] use [WordList].
  /// [wordCount] use [WordCount].
  /// [isED25519] is only for [ChainType.SWTC].
  static Future<WalletEntity> createIdentity(
      {List<int> chainTypes,
      String password,
      WordList language = WordList.chinese_simplified,
      int wordCount = WordCount.twelve,
      String addressIndex,
      bool isED25519 = false}) async {
    final identityJson =
        await _channel.invokeMethod(CallMethod.createIdentity, {
      'chainTypes': chainTypes,
      'language': language.index,
      'wordCount': wordCount,
      'password': password,
      'addressIndex': addressIndex,
      'isED25519': isED25519,
    });
    return WalletEntity.fromJson(jsonDecode(identityJson));
  }

  /// 导出私钥
  ///
  /// [chainType] use [ChainType].
  /// [isED25519] is only for [ChainType.SWTC].
  static Future<String> exportPrivateKey(
      {int chainType, String keystore, String password}) async {
    final privateKey =
        await _channel.invokeMethod(CallMethod.exportPrivateKey, {
      'chainType': chainType,
      'keyStore': keystore,
      'password': password,
    });
    return privateKey;
  }

  /// 导入私钥
  ///
  /// [chainType] use [ChainType].
  /// [isED25519] is only for [ChainType.SWTC].
  static Future<String> importPrivateKey(
      {int chainType,
      String privateKey,
      String password,
      bool isEd25519 = false}) async {
    final walletJson =
        await _channel.invokeMethod(CallMethod.importPrivateKey, {
      'chainType': chainType,
      'privateKey': privateKey,
      'password': password,
      'isED25519': isEd25519
    });

    return walletJson;
  }

  /// 导入助记词
  ///
  /// [chainType] use [ChainType].
  /// [mnemonics] 助记词字符串
  /// [isED25519] is only for [ChainType.SWTC].
  static Future<WalletEntity> importMnemonic(
      {List<int> chainTypes,
      String mnemonics,
      String password,
      String addressIndex,
      bool isEd25519 = false}) async {
    final walletJson = await _channel.invokeMethod(CallMethod.importMnemonic, {
      'chainTypes': chainTypes,
      'mnemonics': mnemonics,
      'password': password,
      'addressIndex': addressIndex,
      'isED25519': isEd25519
    });

    return WalletEntity.fromJson(jsonDecode(walletJson));
  }

  /// 导出助记词
  ///
  /// [mnemonics] 助记词KeyStore
  static Future<String> exportMnemonic({
    String mnemonics,
    String password,
  }) async {
    final _mnemonics = await _channel.invokeMethod(CallMethod.exportMnemonic, {
      'mnemonics': mnemonics,
      'password': password,
    });

    return _mnemonics;
  }

  /// 转账交易本地签名
  ///
  /// [chainType] use [ChainType].
  /// [netWork] use [NetWork].
  static Future<String> signTransaction(
      {int chainType,
      String keyStore,
      String password,
      BigInt nonce,
      String toAddress,
      String token = 'SWT',
      String issuer = '',
      double value,
      double gasPrice,
      double gasLimit,
      int netWork = 0,
      double fee,
      String memo = ''}) async {
    final signedMsg = await _channel.invokeMethod(CallMethod.signTransaction, {
      'chainType': chainType,
      'keyStore': keyStore,
      'password': password,
      'gasPrice': gasPrice.toString(),
      'gasLimit': gasLimit.toString(),
      'netWork': netWork,
      'to': toAddress,
      'nonce': nonce.toString(),
      'token': token,
      'issuer': issuer,
      'value': value.toString(),
      'memo': memo
    });
    return signedMsg;
  }
}
