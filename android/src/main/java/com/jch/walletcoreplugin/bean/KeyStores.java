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

    public Map<String, String> getKeystores() {
        return keystores;
    }

    public void setKeystores(Map<String, String> keystores) {
        this.keystores = keystores;
    }

    private String mnemonics;

    private Map<String, String> keystores;


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
