import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walletcoreplugin/common/constant.dart';
import 'package:walletcoreplugin/walletcoreplugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isPass = true;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      /// 创建钱包
      final walletEntity = await Walletcoreplugin.createIdentity(
          chainTypes: [ChainType.SWTC, ChainType.MOAC, ChainType.ETH],
          password: 'pwd123456');
      print('======== createIdentity ========');
      String mnemonics = walletEntity.mnemonics;
      print('mnemonics: ${mnemonics}');
      final wallets = walletEntity.keyStores;
      wallets.forEach((key, value) {
        print('${key} : ${value}');
      });

      /// 导入助记词
      final wallet = await Walletcoreplugin.importMnemonic(
          chainTypes: [ChainType.ETH, ChainType.MOAC, ChainType.SWTC],
          mnemonics: mnemonics,
          password: 'pwd123456');
      print('======== importMnemonic ========');
      final _wallets = wallet.keyStores;
      _wallets.forEach((key, value) {
        print('${key} : ${value}');
      });

      /// 导出助记词
      final mne = await Walletcoreplugin.exportMnemonic(
          mnemonics: wallet.mncFile, password: 'pwd123456');
      print('======== importMnemonic ========');
      assert(mnemonics == mne);

      /// 导入私钥
      /// 2062154cd708d9b1d61c526628912b69d98a014c
      final ethWallet = await Walletcoreplugin.importPrivateKey(
        chainType: ChainType.ETH,
        privateKey:
            '3dafb4ebb061ec56527beacf659b83c4c7ac794389caf8ea191f0b2870362706',
        password: 'pwd123456',
      );

      print('ethWallet: ${ethWallet}');

      final moacWallet = await Walletcoreplugin.importPrivateKey(
          chainType: ChainType.MOAC,
          privateKey:
              '3dafb4ebb061ec56527beacf659b83c4c7ac794389caf8ea191f0b2870362706',
          password: 'pwd123456');

      /// 2062154cd708d9b1d61c526628912b69d98a014c
      print('moacWallet: ${moacWallet}');

      /// jPzdcqLDpn7j66mo1pwNya3c51sJggdyYR
      final swtcWallet = await Walletcoreplugin.importPrivateKey(
          chainType: ChainType.SWTC,
          privateKey: 'snnfoQqLppDN9fVXcbK4d1Taunvo7',
          password: 'pwd123456');

      print('swtcWallet: ${swtcWallet}');

      final swtcWallet_ED = await Walletcoreplugin.importPrivateKey(
          chainType: ChainType.SWTC,
          privateKey: 'sEdVp8Mhgc8WvnswzDZ8Fv6RDcbNfCN',
          password: 'pwd123456',
          isEd25519: true);

      /// jM7uYXiKnBoRLaDGJxYu8EPKP5cW69kBbx
      print('swtcWallet: ${swtcWallet_ED}');

      /// 导出私钥
      String keystore =
          '{"address":"2062154cd708d9b1d61c526628912b69d98a014c","chainType":"ETH","dateTime":"2020-06-22 19-18-46","id":"722bab4f-46ad-4adb-ba94-389975ecb594","version":3,"crypto":{"cipher":"aes-128-ctr","cipherparams":{"iv":"b45aa56004d9467d8a807b4e67626552"},"ciphertext":"650e4198b6630a74ba0f17211414620597715c45d688c457f2cc298270cdfc52","kdf":"scrypt","kdfparams":{"dklen":32,"n":4096,"p":6,"r":8,"salt":"45a42cc13615fcc345df4bf46a68ce9457344bc476eaff9000affae31cd4eaed"},"mac":"c6d66a3cea71979fe380d5b6ad529e268e6fd65ab19eb0a1c45e5b0bbaed027b"}}';
      final ethKey = await Walletcoreplugin.exportPrivateKey(
        chainType: ChainType.ETH,
        keystore: keystore,
        password: 'pwd123456',
      );

      assert(
          '3dafb4ebb061ec56527beacf659b83c4c7ac794389caf8ea191f0b2870362706' ==
              ethKey);

      keystore =
          '{"address":"2062154cd708d9b1d61c526628912b69d98a014c","chainType":"MOAC","dateTime":"2020-06-22 23-07-11","id":"f9a139a6-3877-4b35-b2bc-cafeebbba7bd","version":3,"crypto":{"cipher":"aes-128-ctr","cipherparams":{"iv":"bc3fca33808340bad5b40ce39d68fcf0"},"ciphertext":"b4129a09d833419188350d168fc0f52272e7cdea062bdd8b56447b4f5fe908c3","kdf":"scrypt","kdfparams":{"dklen":32,"n":4096,"p":6,"r":8,"salt":"55e743844771398e4831c4c6e8bc8a7007c2e0b05cc218a5379a12f68fd17929"},"mac":"c2e9e4870af9d602a44664dbcf0ae3caaf81c40b64a7c5ab20c201baa39942f2"}}';
      final moacKey = await Walletcoreplugin.exportPrivateKey(
          chainType: ChainType.MOAC, keystore: keystore, password: 'pwd123456');

      assert(
          '3dafb4ebb061ec56527beacf659b83c4c7ac794389caf8ea191f0b2870362706' ==
              moacKey);

      keystore =
          '{"address":"jPzdcqLDpn7j66mo1pwNya3c51sJggdyYR","chainType":"SWTC","dateTime":"2020-06-22 23-07-11","id":"808047d8-d162-4c38-8ad6-f38d8361e5e6","version":3,"crypto":{"cipher":"aes-128-ctr","cipherparams":{"iv":"a5470450501894c802f2f48ebdd523ec"},"ciphertext":"14097625a0721e8ab29b869ae1bfde2a9a06ae565a80611cf635f23155","kdf":"scrypt","kdfparams":{"dklen":32,"n":4096,"p":6,"r":8,"salt":"b63260b89eba8f43f69da7678e37dbba0195678b1e437d088167f8c4c6b959ab"},"mac":"a1f1d2fd4463b323fce0f2c68de22ab4ea51e5a7d26cc70a0d96656f4993acbb"}}';
      final swtcKey = await Walletcoreplugin.exportPrivateKey(
          chainType: ChainType.SWTC, keystore: keystore, password: 'pwd123456');

      assert('snnfoQqLppDN9fVXcbK4d1Taunvo7' == swtcKey);

      keystore =
          '{"address":"jM7uYXiKnBoRLaDGJxYu8EPKP5cW69kBbx","chainType":"SWTC","dateTime":"2020-06-22 23-07-12","id":"a2a4ed3a-1a38-4cdc-a956-40f70115792f","version":3,"crypto":{"cipher":"aes-128-ctr","cipherparams":{"iv":"02398503daa710c9ece433aa5599c880"},"ciphertext":"04f99cadd7d127132b7ef007c5764f0a9d8b1b8f59561b7b7a0d982cb3737a","kdf":"scrypt","kdfparams":{"dklen":32,"n":4096,"p":6,"r":8,"salt":"8ce504bf3ab5c4480fbae5cbd656b21316a2e92b782fe80715b695736fde69d4"},"mac":"3d0a9bd201b54cfa2c09ad9397b3aac04600f17eb90b8ffaf3650c9c1b3338f2"}}';
      final swtcKey_ed = await Walletcoreplugin.exportPrivateKey(
          chainType: ChainType.SWTC,
          keystore: keystore,
          password: 'pwd123456',
          isED25519: true);

      assert('sEdVp8Mhgc8WvnswzDZ8Fv6RDcbNfCN' == swtcKey_ed);

      /// 本地签名
      final SIGNED_MSG_ETH =
          "0xf8724e8504a817c800831e8480949c5bdcd2c610c80eb8458cd836dd32449ab45ca7865af3107a400087e6b58be8af95312aa040a2f296579bf11788d2719b97f6c1d8cc738f60659a324dbe7f7865923ba4d4a05a5703cdac0a5f451823cd5cba44a28d67f110dd258e822fb974c86c459fcb4b";
      final keystore_eth =
          '{"chainType":"ETH","address":"4e3fbf81d58a2224d8dab52e30fccf3d9c29b457","dateTime":"2020-06-22 23-53-36","id":"20ba1a63-98a9-49b8-84ce-20102f40d218","version":3,"crypto":{"cipher":"aes-128-ctr","ciphertext":"da1e875f6cb909430c97890bb1bff4b409a83ebae563d3b0da7d65133b02bcac","cipherparams":{"iv":"fe1626f256f9a028a908495af93f0c9d"},"kdf":"scrypt","kdfparams":{"dklen":32,"n":4096,"p":6,"r":8,"salt":"462d17a39998a84b5df1e54905dd243ec1c257bdd56c5589f152a9451796a2f5"},"mac":"e59f100432eb28f0519263c0315feb203facd65e781e8491b6787ffd44fd7eb8"}}';
      final signedEth = await Walletcoreplugin.signTransaction(
          chainType: ChainType.ETH,
          keyStore: keystore_eth,
          password: 'pwd123456',
          nonce: BigInt.from(78),
          netWork: NetWork.ROPSTEN,
          toAddress: '0x9C5BdcD2C610C80Eb8458CD836dd32449Ab45cA7',
          value: 0.0001,
          gasPrice: 0.00000002,
          gasLimit: 2e-12,
          memo: '测试1');
      assert(SIGNED_MSG_ETH == signedEth);

      final SIGNED_MSG_MOAC =
          "0xf87664808504a817c800831e848094c8da3c2a4f6e4400a338c0d7927f2cb80ab85500865af3107a400087e6b58be8af9531808081eaa0d353c7f9c9765f54cec7f0dde9a996bdd759b87287dfc93b89bf9b5ed9b11cd4a02d94e31de49c14543a3f5439925e4a1d3552f48d0bc6440f2e375fd0786c6e19";
      final keystore_moac =
          '{"chainType":"MOAC","address":"8aacb5febf12546ca47fc5e9aa1bd1407378ad7a","dateTime":"2020-06-23 10-22-39","id":"55baab20-533a-4b92-853a-ab00cd26fdc6","version":3,"crypto":{"cipher":"aes-128-ctr","ciphertext":"969b699dd251891d2beba68ad4dbcfe6bf9b00f6c97b2916134df7614139345d","cipherparams":{"iv":"929f063d2350a6971e4cdbf789d28b85"},"kdf":"scrypt","kdfparams":{"dklen":32,"n":4096,"p":6,"r":8,"salt":"e59bb236eef54af6e91ed262a911bc9ec17264809b783bf730381e7ae116c56d"},"mac":"0f9192dc64cb612a7cea81a349abb6bd1dba631d1d9bd8d9ecbe160e046ed5c2"}}';
      final signedMoac = await Walletcoreplugin.signTransaction(
          chainType: ChainType.MOAC,
          keyStore: keystore_moac,
          password: 'pwd123456',
          nonce: BigInt.from(100),
          netWork: NetWork.MC_MAINNET,
          toAddress: '0xC8da3C2A4f6E4400A338c0D7927F2Cb80ab85500',
          value: 0.0001,
          gasPrice: 0.00000002,
          gasLimit: 2e-12,
          memo: '测试1');
      assert(SIGNED_MSG_MOAC == signedMoac);

      final SIGNED_MSG_SWTC =
          "120000228000000024000000B16140000000000003E8684000000000002710732102889E27E7A9CCE4AC7639A3B8D0B76802CD6DAA611DA9BB374BEDC425890A10DD74473045022100D161365853365028B47FF4F6062A5502DFD178A1DA9D0B719E80F76F14CFF22B0220498573EDA87C26115B7E3384549DC7CA7B6478C8779B515136862B016B16C2B6811477DAE3BDFE78BB2C82F15CAC65E2472AC65C0C2A8314C776498CA6EAE7DF50C685BE6F219B926FDE8B6FF9EA7D09535754E8BDACE8B4A6E1F1";
      final keystore_swtc =
          '{"chainType":"SWTC","address":"jBvrdYc6G437hipoCiEpTwrWSRBS2ahXN6","dateTime":"2020-06-23 10-31-00","id":"3736cb53-c83b-4c3a-b900-1c2efc28ec95","version":3,"crypto":{"cipher":"aes-128-ctr","ciphertext":"046109347d7532f2f98d7706d606206674b938eac4e1c461946ccac7c1","cipherparams":{"iv":"2358d407751b8a76376f0f1a5596f938"},"kdf":"scrypt","kdfparams":{"dklen":32,"n":4096,"p":6,"r":8,"salt":"31d7664dc31f83d6b9aa1bbfb1d0201989690ef5ff4dd3321d6b2460c58d3e1e"},"mac":"30a33808ec1ca80dd40a70b6c65facdc160a9b7e84484ff0c9a6016fa21ec2f4"}}';
      final signedSwtc = await Walletcoreplugin.signTransaction(
          chainType: ChainType.SWTC,
          keyStore: keystore_swtc,
          password: 'pwd123456',
          nonce: BigInt.from(177),
          toAddress: 'jKBCwv4EcyvYtD4PafP17PLpnnZ16szQsC',
          value: 0.001,
          memo: 'SWT转账');
      assert(SIGNED_MSG_SWTC == signedSwtc);
      setState(() {
        isPass = true;
      });
    } on PlatformException {
      setState(() {
        isPass = false;
      });
      platformVersion = 'Failed to get platform version.';
    } catch (e, s) {
      setState(() {
        isPass = false;
      });
      print(e);
      print(s);
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: FlatButton(
            child: Text('测试'),
            color: isPass ? Colors.teal : Colors.red,
            onPressed: () => initPlatformState(),
          ),
        ),
      ),
    );
  }
}
