package com.kangaroo.ktlib.util.store

import android.text.TextUtils
import com.jakewharton.disklrucache.DiskLruCache
import com.kangaroo.ktlib.app.init.DefaultInit
import com.kangaroo.ktlib.app.init.sysContext
import com.kangaroo.ktlib.exception.LibPermissionException
import com.kangaroo.ktlib.exception.LibStorageException
import com.kangaroo.ktlib.exception.LibStorageNoEnoughSpaceException
import com.kangaroo.ktlib.util.SSystem
import com.kangaroo.ktlib.util.encryption.MessageDigestUtils
import com.kangaroo.ktlib.util.store.filestorage.StorageType
import com.kangaroo.ktlib.util.store.filestorage.UStorage
import com.kangaroo.ktlib.util.store.filestorage.UStorage.getWritePath
import com.kangaroo.ktlib.util.store.filestorage.UStorage.storageCheck
import java.io.*
import kotlin.jvm.Throws

/**
 * author : WaTaNaBe
 * e-mail : 297165331@qq.com
 * time : 2019/07/23
 * desc : 文件缓存类
 */
class DiskCacheStore private constructor() {

    companion object {
        private const val DISK_CACHE = "disk_cache"
        @JvmStatic
        val instance: DiskCacheStore by lazy {
            DiskCacheStore()
        }
    }
    @Volatile
    private var cache: DiskLruCache? = null


    private fun checkEnable() {
        if (cache == null || cache!!.isClosed) {
            val path = getWritePath(
                DISK_CACHE,
                StorageType.TYPE_CACHE
            )
            if(path!=null){
                cache = DiskLruCache.open(File(path), version, 1, 10 * UStorage.M) //10M
            }
        }
    }

    @Throws(LibPermissionException::class, LibStorageException::class)
    private fun checkStorage() {
        storageCheck(sysContext,StorageType.TYPE_CACHE)
    }

    //                    每当版本号改变，缓存路径下存储的所有数据都会被清除掉
    private val version: Int
        private get() {
            //                    每当版本号改变，缓存路径下存储的所有数据都会被清除掉
            return SSystem.getVersionCode(sysContext) as Int
        }


    @Synchronized
    @Throws(LibPermissionException::class, LibStorageException::class)
    fun put(key: String, value: Any?) {
        checkStorage()
        checkEnable()
        if (TextUtils.isEmpty(key)) return
        if(cache!=null){
            var editor = cache!!.edit( MessageDigestUtils.md5(key))
            if(value!=null){
                ObjectOutputStream(editor.newOutputStream(0)).use {
                    it.writeObject(value)
                    editor.commit()
                }
            }
            editor?.abort()
            cache!!.flush()
        }
    }

    @Throws(LibPermissionException::class, LibStorageException::class)
    fun put(map: Map<String, Any?>) {
        for ((key, value) in map) {
            put(key, value)
        }
    }

    @Synchronized
    @Throws(LibPermissionException::class, LibStorageException::class)
    fun <T> get(key: String, defaultValue: T?): T? {
        try {
            checkStorage()
        } catch (e: LibStorageNoEnoughSpaceException) {
        }
        checkEnable()
        if(cache!=null){
            val snapshot =
                cache!![MessageDigestUtils.md5(key)]
            if(snapshot!=null){
                ObjectInputStream(snapshot.getInputStream(0)).use {
                    var o = it.readObject()
                    return if(o!=null){
                        o as T
                    } else defaultValue
                }
            }
        }
        return defaultValue
    }

    @Synchronized
    @Throws(LibPermissionException::class, LibStorageException::class)
    fun remove(key: String) {
        try {
            checkStorage()
        } catch (e: LibStorageNoEnoughSpaceException) {
        }
        checkEnable()
        if(cache!=null){
            cache!!.remove(MessageDigestUtils.md5(key))
        }
    }

    @Synchronized
    @Throws(LibPermissionException::class, LibStorageException::class)
    fun contains(key: String): Boolean {
        try {
            checkStorage()
        } catch (e: LibStorageNoEnoughSpaceException) {
        }
        checkEnable()
        if(cache!=null){
            val snapshot =
                cache!![MessageDigestUtils.md5(key)]
            return snapshot != null
        }
        return false
    }

    @Synchronized
    @Throws(LibPermissionException::class, LibStorageException::class)
    fun clear() {
        try {
            checkStorage()
        } catch (e: LibStorageNoEnoughSpaceException) {
        }
        checkEnable()
        if(cache!=null){
            cache!!.delete()
        }
    }


}