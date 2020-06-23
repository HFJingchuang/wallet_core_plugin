package com.jch.walletcoreplugin.bean;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.Map;

public class KeyStores {

    public String getMnemonics() {
        return mnemonics;
    }

    public void setMnemonics(String mnemonics) {
        this.mnemonics = mnemonics;
    }

    public Map<String, String> getKeyStores() {
        return keyStores;
    }

    public void setKeyStores(Map<String, String> keyStores) {
        this.keyStores = keyStores;
    }

    public String getMncFile() {
        return mncFile;
    }

    public void setMncFile(String mncFile) {
        this.mncFile = mncFile;
    }

    private String mnemonics;

    private String mncFile;

    private Map<String, String> keyStores;


    @Override
    public String toString() {
        ObjectMapper mapper = new ObjectMapper();
        String mapJakcson = "";
        try {
            mapJakcson = mapper.writeValueAsString(this);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        return mapJakcson;
    }

}
