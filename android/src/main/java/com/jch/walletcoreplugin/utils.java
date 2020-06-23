package com.jch.walletcoreplugin;


import com.jch.core.cypto.wordlists.Chinese_simplified;
import com.jch.core.cypto.wordlists.English;
import com.jch.core.cypto.wordlists.French;
import com.jch.core.cypto.wordlists.Japanese;
import com.jch.core.cypto.wordlists.Spanish;
import com.jch.core.cypto.wordlists.WordCount;
import com.jch.core.cypto.wordlists.WordList;
import com.jch.core.exceptions.CoinNotFindException;
import com.jch.core.exceptions.NonSupportException;
import com.jch.core.wallet.BIP44.AddressIndex;
import com.jch.core.wallet.BIP44.BIP44;
import com.jch.core.wallet.ChainTypes;

public class utils {
    public static WordList getWordList(int lang) {
        switch (lang) {
            case 1:
                return English.INSTANCE;
            case 2:
                return French.INSTANCE;
            case 4:
                return Japanese.INSTANCE;
            case 3:
                return Spanish.INSTANCE;
            case 0:
            default:
                return Chinese_simplified.INSTANCE;
        }
    }

    public static WordCount getWordCount(int count) {
        switch (count) {
            case 15:
                return WordCount.FIFTEEN;
            case 21:
                return WordCount.TWENTY_ONE;
            case 24:
                return WordCount.TWENTY_FOUR;
            case 12:
            default:
                return WordCount.TWELVE;

        }
    }

    public static AddressIndex getAddressIndex(ChainTypes chainTypes, String addressIndex) throws NonSupportException, CoinNotFindException {
        if (addressIndex != null && addressIndex.length() > 0) {
            return BIP44.parsePath(addressIndex);
        }
        return BIP44.m()
                .purpose44()
                .chainType(chainTypes)
                .account(0)
                .external()
                .address(0);
    }
}
