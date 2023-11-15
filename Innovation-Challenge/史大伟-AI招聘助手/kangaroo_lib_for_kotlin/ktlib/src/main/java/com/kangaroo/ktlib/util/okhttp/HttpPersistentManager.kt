package com.kangaroo.ktlib.util.okhttp

import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.dataStore
import com.kangaroo.ktlib.app.SYS_PERSISTENT
import com.kangaroo.ktlib.app.init.sysContext
import com.kangaroo.ktlib.data.models.PersistentPreferences
import com.kangaroo.ktlib.data.models.data.PersistentSerializer
import kotlinx.coroutines.flow.first

const val URL_PERSISTENT = 1
const val HEADER_PERSISTENT = 2
const val ALL_PERSISTENT = 3

@JvmInline
value class HttpPersistentType(val type:Int) {
    companion object{
        val url = HttpPersistentType(URL_PERSISTENT)
        val header = HttpPersistentType(HEADER_PERSISTENT)
        val all = HttpPersistentType(ALL_PERSISTENT)
    }
}

val Context.PersistentPreferences: DataStore<PersistentPreferences> by dataStore(fileName = SYS_PERSISTENT, serializer = PersistentSerializer)

/**
 * http持久化管理
 */
class HttpPersistentManager {
    companion object {
        val instance: HttpPersistentManager by lazy() {
            HttpPersistentManager() }
    }

    private suspend fun store(host: String, type: HttpPersistentType,func : (MutableMap<String, String>)->Unit){
        sysContext.PersistentPreferences.updateData {
            it.toBuilder().let {innerit ->
                if(innerit.valueMap==null){
                    var map = mutableMapOf<String,PersistentPreferences.Persistent>()
                    innerit.putAllValue(map)
                }
                var key = host + "_" + type.type
                if(innerit.valueMap[key]==null){
                    var persistent = PersistentPreferences.Persistent.newBuilder().putAllAttrs(
                        mutableMapOf<String,String>()
                    ).build()
                    innerit.putValue(key,persistent)
                }
                var per = innerit.valueMap[key]
                func(per!!.attrsMap)
                innerit.build()
            }
        }
    }

    private val headerPersistent = HashMap<String, HashMap<String, String?>>()
    private val urlPersistent = HashMap<String, HashMap<String, String?>>()

    suspend fun setPersistent(host: String, key: String, value: String?, type: HttpPersistentType = HttpPersistentType.all) {
        if (type == HttpPersistentType.all || type == HttpPersistentType.header) {
            if (!headerPersistent.containsKey(host)) {
                headerPersistent[host] = HashMap<String, String?>()
            }
            var keyMap: HashMap<String, String?> = headerPersistent[host]!!
            keyMap[key] = value
            store(host, HttpPersistentType.header){
                it[key] = value ?: ""
            }
        }
        if (type == HttpPersistentType.all || type == HttpPersistentType.url) {
            if (!urlPersistent.containsKey(host)) {
                urlPersistent[host] = HashMap<String, String?>()
            }
            var keyMap: HashMap<String, String?> = urlPersistent[host]!!
            keyMap[key] = value
            store(host, HttpPersistentType.url){
                it[key] = value ?: ""
            }
        }
    }

    suspend fun setPersistent(host: String, map: HashMap<String, String?>,  type: HttpPersistentType = HttpPersistentType.all) {
        if (type == HttpPersistentType.all || type == HttpPersistentType.header) {
            if (!headerPersistent.containsKey(host)) {
                headerPersistent[host] = HashMap<String, String?>()
            }
            var keyMap: HashMap<String, String?> = headerPersistent[host]!!
            keyMap.putAll(map)
            store(host, HttpPersistentType.header){
                keyMap.forEach {inner->
                    it[inner.key] = inner.value ?: ""
                }
            }
        }
        if (type == HttpPersistentType.all || type == HttpPersistentType.url) {
            if (!urlPersistent.containsKey(host)) {
                urlPersistent[host] = HashMap<String, String?>()
            }
            var keyMap: HashMap<String, String?> = urlPersistent[host]!!
            keyMap.putAll(map)
            store(host, HttpPersistentType.url){
                keyMap.forEach {inner->
                    it[inner.key] = inner.value ?: ""
                }
            }
        }
    }

    fun getPersistent(host: String,  type: HttpPersistentType = HttpPersistentType.all): HashMap<String, String?>? {
        var map: HashMap<String, String?>? = null
        if (type == HttpPersistentType.all || type == HttpPersistentType.header) {
            var headerMap = if (headerPersistent.containsKey(host)) { headerPersistent[host] } else { null }
            if (headerMap != null) {
                if (map == null) {
                    map = HashMap()
                }
                map.putAll(headerMap)
            }
        }
        if (type == HttpPersistentType.all || type == HttpPersistentType.url) {
            var urlMap = if (urlPersistent.containsKey(host)) { urlPersistent[host] } else { null }
            if (urlMap != null) {
                if (map == null) {
                    map = HashMap()
                }
                map.putAll(urlMap)
            }
        }
        return map
    }

    suspend fun flushPersistent(host: String,  type: HttpPersistentType = HttpPersistentType.all) {
        if (type == HttpPersistentType.all || type == HttpPersistentType.header) {
            var map = all(host, HttpPersistentType.header)
            headerPersistent[host]?.clear()
            if (map != null) {
                if (!headerPersistent.containsKey(host)) {
                    headerPersistent[host] = HashMap<String, String?>()
                }
                val keyMap: HashMap<String, String?> = headerPersistent[host]!!
                keyMap.putAll(map)
            }
        }
        if (type == HttpPersistentType.all || type == HttpPersistentType.url) {
            var map = all(host, HttpPersistentType.url)
            urlPersistent[host]?.clear()
            if (map != null) {
                if (!urlPersistent.containsKey(host)) {
                    urlPersistent[host] = HashMap<String, String?>()
                }
                val keyMap: HashMap<String, String?> = urlPersistent[host]!!
                keyMap.putAll(map)
            }
        }
    }

    suspend fun removeAllPersistent(host: String,  type: HttpPersistentType = HttpPersistentType.all) {
        if (type == HttpPersistentType.all || type == HttpPersistentType.header) {
            headerPersistent[host]?.clear()
            store(host, HttpPersistentType.header){
                it.clear()
            }
        }
        if (type == HttpPersistentType.all || type == HttpPersistentType.url) {
            urlPersistent[host]?.clear()
            store(host, HttpPersistentType.url){
                it.clear()
            }
        }
    }

    private suspend fun all(host: String, type: HttpPersistentType = HttpPersistentType.all): Map<String, String?>? {
        var map = sysContext.PersistentPreferences.data.first().valueMap
        var key = host + "_" + type.type
        var value = map[key]
        if(value!=null&&value.attrsMap!=null){
            return value.attrsMap
        }
        return null
    }
}