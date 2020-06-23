import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:walletcoreplugin/wallet_entity.dart';

import 'common/constant.dart';

class Walletcoreplugin {
  static const MethodChannel _channel =
      const MethodChannel('com.jch/wallet_core_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

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
    final String identityJson = await _channel.invokeMethod('createIdentity', {
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
      {int chainType,
      String keystore,
      String password,
      bool isED25519 = false}) async {
    final String privateKey = await _channel.invokeMethod('exportPrivateKey', {
      'chainType': chainType,
      'keyStore': keystore,
      'password': password,
      'isED25519': isED25519,
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
      bool isEd22519 = false}) async {
    final String walletJson = await _channel.invokeMethod('importPrivateKey', {
      'chainType': chainType,
      'privateKey': privateKey,
      'password': password,
      'isED25519': isEd22519
    });

    return walletJson;
  }

  /// 导入助记词
  ///
  /// [chainType] use [ChainType].
  /// [isED25519] is only for [ChainType.SWTC].
  static Future<WalletEntity> importMnemonic(
      {List<int> chainType,
      String mnemonics,
      String password,
      String addressIndex,
      bool isEd22519 = false}) async {
    final String walletJson = await _channel.invokeMethod('importMnemonic', {
      'chainTypes': chainType,
      'mnemonics': mnemonics,
      'password': password,
      'addressIndex': addressIndex,
      'isED25519': isEd22519
    });

    return WalletEntity.fromJson(jsonDecode(walletJson));
  }

  /// 转账交易本地签名
  ///
  /// [chainType] use [ChainType].
  /// [netWork] use [NetWork].
  /// [token] [issuer] [fee] [isED25519] is only for [ChainType.SWTC].
  static Future<String> signTransaction(
      {int chainType,
      String keyStore,
      String password,
      bool isED25519 = false,
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
    final String signedMsg = await _channel.invokeMethod('signTransaction', {
      'chainType': chainType,
      'keyStore': keyStore,
      'password': password,
      'isED25519': isED25519,
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
