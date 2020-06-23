/// 可选助记词语种
enum WordList { chinese_simplified, english, french, japanese, spanish }

/// 可选助记词个数
class WordCount {
  /// 12个助记词
  static const twelve = 12;

  /// 15个助记词
  static const fifteen = 15;

  /// 21个助记词
  static const twenty_one = 21;

  /// 24个助记词
  static const twenty_four = 24;
}

/// 支持区块链底层
class ChainType {
  /// 以太坊
  static const ETH = 60;

  /// 墨客
  static const MOAC = 314;

  /// 井通
  static const SWTC = 315;
}

/// 支持区块链底层
class NetWork {
  static const NONE = -1;
  static const MAINNET = 1;
  static const EXPANSE_MAINNET = 2;
  static const ROPSTEN = 3;
  static const RINKEBY = 4;
  static const ROOTSTOCK_MAINNET = 30;
  static const ROOTSTOCK_TESTNET = 31;
  static const KOVAN = 42;
  static const ETHEREUM_CLASSIC_MAINNET = 61;
  static const ETHEREUM_CLASSIC_TESTNET = 62;
  static const MC_MAINNET = 99;
  static const MC_TESTNET = 101;
}

/// 支持API
class CallMethod {
  static const createIdentity = "createIdentity";

  static const exportPrivateKey = "exportPrivateKey";

  static const importPrivateKey = "importPrivateKey";

  static const importMnemonic = "importMnemonic";

  static const exportMnemonic = "exportMnemonic";

  static const signTransaction = "signTransaction";
}
