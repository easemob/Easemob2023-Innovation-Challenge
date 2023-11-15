package com.kangaroo.ktlib.util.store

import android.text.TextUtils
import android.util.LruCache

/**
 * author : WaTaNaBe
 * e-mail : 297165331@qq.com
 * time : 2019/07/23
 * desc : 内存缓存工具
 */
class MemoryStore private constructor() {

    var cache = LruCache<Any?, Any>(
        Runtime.getRuntime().maxMemory().toInt() / 8
    )

    companion object{
        val instance : MemoryStore by lazy {
            MemoryStore()
        }
    }


    fun put(key: String, value: Any?) {
        cache.put(key, value)
    }

    fun put(map: Map<String, Any?>) {
        for ((key, value) in map) {
            put(key, value)
        }
    }

    fun <T> get(key: String, defaultValue: T?): T? {
        val o = cache[key]
        return if(o!=null){
            o as T
        } else defaultValue
    }

    fun remove(key: String) {
        cache.remove(key)
    }

    fun contains(key: String) = cache.snapshot().containsKey(key)

    fun clear() = cache.evictAll()


}