package com.redhat.sso.ninja.utils;

import java.util.HashMap;
import java.util.Map;

public class MapBuilder<K,V>{
    Map<K, V> values=new HashMap<K, V>();
    public MapBuilder<K,V> put(K key, V value){
      values.put(key, value); return this;
    }
    public MapBuilder<K,V> putAll(Map<? extends K,? extends V> m){
    	values.putAll(m); return this;
    }
    public Map<K, V> build(){
      return values;
    }
  }