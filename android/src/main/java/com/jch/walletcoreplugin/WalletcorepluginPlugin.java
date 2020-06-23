package com.jch.walletcoreplugin;

import androidx.annotation.NonNull;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.jch.core.cypto.ChainIdLong;
import com.jch.core.cypto.ECKeyPair;
import com.jch.core.cypto.MnemonicUtils;
import com.jch.core.cypto.RandomSeed;
import com.jch.core.eth.RawTransaction;
import com.jch.core.eth.TransactionEncoder;
import com.jch.core.swtc.Config;
import com.jch.core.swtc.EDKeyPair;
import com.jch.core.swtc.K256KeyPair;
import com.jch.core.swtc.bean.AmountInfo;
import com.jch.core.swtc.core.coretypes.AccountID;
import com.jch.core.swtc.core.coretypes.Amount;
import com.jch.core.swtc.core.coretypes.uint.UInt32;
import com.jch.core.swtc.core.types.known.tx.signed.SignedTransaction;
import com.jch.core.swtc.core.types.known.tx.txns.Payment;
import com.jch.core.wallet.BIP44.Bip44WalletGenerator;
import com.jch.core.wallet.Bip39Wallet;
import com.jch.core.wallet.ChainTypes;
import com.jch.core.wallet.Wallet;
import com.jch.core.wallet.WalletFile;
import com.jch.core.wallet.WalletUtils;
import com.jch.walletcoreplugin.bean.Arguments;
import com.jch.walletcoreplugin.bean.KeyStores;

import org.web3j.utils.Convert;
import org.web3j.utils.Numeric;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import static java.nio.charset.StandardCharsets.UTF_8;

/**
 * WalletcorepluginPlugin
 */
public class WalletcorepluginPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "com.jch/wallet_core_plugin");
        channel.setMethodCallHandler(this);
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "com.jch/wallet_core_plugin");
        channel.setMethodCallHandler(new WalletcorepluginPlugin());
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call == null || call.method == null) {
            result.error(ErrorCode.CALL_ERROR, "call or call.method is null", call);
            return;
        }
        switch (call.method) {
            case "getPlatformVersion":
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;
            case CallMethod.createIdentity:
                createWallet(call, result);
                break;
            case CallMethod.exportPrivateKey:
                onExportPrivateKey(call, result);
                break;
            case CallMethod.importPrivateKey:
                onImportPrivateKey(call, result);
                break;
            case CallMethod.importMnemonic:
                onImportMnemonic(call, result);
                break;
            case CallMethod.signTransaction:
                onSignTransaction(call, result);
                break;
            default:
                result.notImplemented();
                break;
        }

    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }


    /**
     * 创建钱包
     *
     * @param call
     * @param result
     */
    private void createWallet(MethodCall call, Result result) {
        try {
            if (isArgumentIllegal(call, result)) {
                return;
            }
            Arguments arguments = getArgs(call);
            byte[] initialEntropy = RandomSeed.random(utils.getWordCount(arguments.wordCount));
            String mnemonics = new MnemonicUtils(utils.getWordList(arguments.language)).generateMnemonic(initialEntropy);
            Map<String, String> keyStoreMap = new HashMap<>();
            List<Integer> chainTypes = arguments.chainTypes;
            for (int i = 0; i < chainTypes.size(); i++) {
                ChainTypes chainType = ChainTypes.parseCoinType(chainTypes.get(i));
                Bip39Wallet bip39Wallet = Bip44WalletGenerator.fromMnemonicWithPath(chainType, mnemonics, arguments.password, utils.getAddressIndex(chainType, arguments.addressIndex), arguments.isED25519);
                keyStoreMap.put(chainType.chainName(), bip39Wallet.getWalletFile().toString());
            }
            KeyStores keyStores = new KeyStores();
            keyStores.setMnemonics(mnemonics);
            keyStores.setKeystores(keyStoreMap);
            result.success(keyStores.toString());
        } catch (Exception e) {
            e.printStackTrace();
            result.error(ErrorCode.ERROR, e.getMessage(), null);
        }

    }

    /**
     * 导入私钥
     *
     * @param call
     * @param result
     */
    private void onImportPrivateKey(MethodCall call, Result result) {
        try {
            if (isArgumentIllegal(call, result)) {
                return;
            }
            Arguments arguments = getArgs(call);
            ChainTypes chainType = ChainTypes.parseCoinType(arguments.chainType);
            WalletFile walletFile = WalletUtils.generateWalletFromPrivateKey(chainType, arguments.privateKey, arguments.password, arguments.isED25519);
            result.success(walletFile.toString());
        } catch (Exception e) {
            e.printStackTrace();
            result.error(ErrorCode.IMPORT_ERROR, e.getMessage(), null);
        }
    }

    /**
     * 导出私钥
     *
     * @param call
     * @param result
     */
    private void onExportPrivateKey(MethodCall call, Result result) {
        try {
            if (isArgumentIllegal(call, result)) {
                return;
            }
            Arguments arguments = getArgs(call);
            ChainTypes chainType = ChainTypes.parseCoinType(arguments.chainType);
            WalletFile walletFile = WalletFile.parse(arguments.keyStore);
            String privateKye = "";
            switch (chainType) {
                case MOAC:
                case ETH:
                    ECKeyPair keyPair = (ECKeyPair) Wallet.decrypt(chainType, arguments.password, false, walletFile);
                    privateKye = Numeric.toHexStringNoPrefix(keyPair.getPrivateKey());
                    break;
                case SWTC:
                    if (arguments.isED25519) {
                        EDKeyPair edKeyPair = (EDKeyPair) Wallet.decrypt(chainType, arguments.password, true, walletFile);
                        privateKye = edKeyPair.getSecret();
                    } else {
                        K256KeyPair k256KeyPair = (K256KeyPair) Wallet.decrypt(chainType, arguments.password, false, walletFile);
                        privateKye = k256KeyPair.getSecret();
                    }
                    break;
            }
            result.success(privateKye);
        } catch (Exception e) {
            e.printStackTrace();
            result.error(ErrorCode.KEYSTORE_ERROR, e.getMessage(), null);
        }
    }

    /**
     * 导入助记词
     *
     * @param call
     * @param result
     */
    private void onImportMnemonic(MethodCall call, Result result) {
        try {
            if (isArgumentIllegal(call, result)) {
                return;
            }
            Arguments arguments = getArgs(call);
            Map<String, String> keyStoreMap = new HashMap<>();
            List<Integer> chainTypes = arguments.chainTypes;
            for (int i = 0; i < chainTypes.size(); i++) {
                ChainTypes chainType = ChainTypes.parseCoinType(chainTypes.get(i));
                Bip39Wallet bip39Wallet = Bip44WalletGenerator.fromMnemonicWithPath(chainType, arguments.mnemonics, arguments.password, utils.getAddressIndex(chainType, arguments.addressIndex), arguments.isED25519);
                keyStoreMap.put(chainType.chainName(), bip39Wallet.getWalletFile().toString());
            }
            KeyStores keyStores = new KeyStores();
            keyStores.setMnemonics(arguments.mnemonics);
            keyStores.setKeystores(keyStoreMap);
            result.success(keyStores.toString());
        } catch (Exception e) {
            e.printStackTrace();
            result.error(ErrorCode.MNEMONIC_ERROR, e.getMessage(), null);
        }
    }

    /**
     * 转账交易本地签名
     *
     * @param call
     * @param result
     */
    private void onSignTransaction(MethodCall call, Result result) {
        try {
            if (isArgumentIllegal(call, result)) {
                return;
            }
            Arguments arguments = getArgs(call);
            ChainTypes chainType = ChainTypes.parseCoinType(arguments.chainType);
            WalletFile walletFile = WalletFile.parse(arguments.keyStore);
            String signedMsg = "";
            switch (chainType) {
                case ETH:
                    if (arguments.netWork == 0) {
                        arguments.netWork = ChainIdLong.ETHEREUM_CLASSIC_MAINNET;
                    }
                    String memo = Numeric.toHexString(arguments.memo.getBytes(UTF_8));
                    BigInteger gasPrice = Convert.toWei(new BigDecimal(arguments.gasPrice), Convert.Unit.ETHER).toBigInteger();
                    BigInteger gasLimit = Convert.toWei(new BigDecimal(arguments.gasLimit), Convert.Unit.ETHER).toBigInteger();
                    BigInteger value = Convert.toWei(new BigDecimal(arguments.value), Convert.Unit.ETHER).toBigInteger();
                    ECKeyPair keyPair = (ECKeyPair) Wallet.decrypt(chainType, arguments.password, false, walletFile);
                    RawTransaction rawTransaction = RawTransaction.createTransaction(arguments.nonce, gasPrice, gasLimit, arguments.to, value, memo);
                    byte[] singedTx = TransactionEncoder.signMessage(rawTransaction, arguments.netWork, keyPair);
                    signedMsg = Numeric.toHexString(singedTx);
                    break;
                case MOAC:
                    if (arguments.netWork == 0) {
                        arguments.netWork = ChainIdLong.MC_MAINNET;
                    }
                    memo = Numeric.toHexString(arguments.memo.getBytes(UTF_8));
                    BigInteger _gasPrice = Convert.toWei(new BigDecimal(arguments.gasPrice), Convert.Unit.ETHER).toBigInteger();
                    BigInteger _gasLimit = Convert.toWei(new BigDecimal(arguments.gasLimit), Convert.Unit.ETHER).toBigInteger();
                    BigInteger _value = Convert.toWei(new BigDecimal(arguments.value), Convert.Unit.ETHER).toBigInteger();
                    ECKeyPair _keyPair = (ECKeyPair) Wallet.decrypt(chainType, arguments.password, false, walletFile);
                    com.jch.core.moac.RawTransaction _rawTransaction = com.jch.core.moac.RawTransaction.createTransaction(arguments.nonce, _gasPrice, _gasLimit, arguments.to, _value, memo);
                    byte[] _singedTx = com.jch.core.moac.TransactionEncoder.signMessage(_rawTransaction, arguments.netWork, _keyPair);
                    signedMsg = Numeric.toHexString(_singedTx);
                    break;
                case SWTC:
                    AmountInfo amountInfo = new AmountInfo();
                    amountInfo.setCurrency(arguments.token);// 转出代币简称
                    amountInfo.setValue(arguments.value);// 转出代币数量
                    amountInfo.setIssuer(arguments.issuer);// 转出代币银关

                    Payment payment = new Payment();
                    payment.as(AccountID.Destination, arguments.to);
                    payment.setAmountInfo(amountInfo);
                    if (arguments.fee != null) {
                        payment.as(Amount.Fee, arguments.fee);// 交易燃料费
                    } else {
                        payment.as(Amount.Fee, String.valueOf(Config.FEE));// 交易燃料费
                    }
                    payment.sequence(new UInt32(arguments.nonce));// 转出地址序列号
                    payment.flags(new UInt32(0));
                    List<String> memos = new ArrayList<String>();// 交易备注
                    memos.add(arguments.memo);
                    payment.addMemo(memos);
                    if (arguments.isED25519) {
                        EDKeyPair edKeyPair = (EDKeyPair) Wallet.decrypt(chainType, arguments.password, true, walletFile);
                        payment.as(AccountID.Account, edKeyPair.getAddress());
                        SignedTransaction signedTx = payment.sign(edKeyPair.getSecret(), true);// 签名
                        signedMsg = signedTx.tx_blob;
                    } else {
                        K256KeyPair k256KeyPair = (K256KeyPair) Wallet.decrypt(chainType, arguments.password, false, walletFile);
                        payment.as(AccountID.Account, k256KeyPair.getAddress());
                        SignedTransaction signedTx = payment.sign(k256KeyPair.getSecret(), false);// 签名
                        signedMsg = signedTx.tx_blob;
                    }
                    break;
            }
            result.success(signedMsg);
        } catch (Exception e) {
            e.printStackTrace();
            result.error(ErrorCode.SIGN_ERROR, e.getMessage(), null);
        }
    }

    private boolean isArgumentIllegal(MethodCall call, Result result) {
        if (!(call.arguments instanceof Map)) {
            result.error(ErrorCode.ARGS_ERROR, String.format("arguments in %s method type error.need map", call.method), null);
            return true;
        }
        return false;
    }

    private Arguments getArgs(MethodCall call) throws JsonProcessingException {
        ObjectMapper objectMapper = new ObjectMapper();
        Object arguments = call.arguments;
        String json = objectMapper.writeValueAsString(arguments);
        return objectMapper.readValue(json, Arguments.class);
    }
}
