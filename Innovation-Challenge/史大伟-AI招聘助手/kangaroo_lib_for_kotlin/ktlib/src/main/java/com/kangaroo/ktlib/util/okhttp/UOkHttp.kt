package com.kangaroo.ktlib.util.okhttp

import com.kangaroo.ktlib.util.store.filestorage.StorageType
import com.kangaroo.ktlib.util.store.filestorage.UStorage
import okhttp3.Cache
import okhttp3.OkHttpClient
import java.io.File
import java.util.concurrent.TimeUnit

/**
 * author : WaTaNaBe
 * e-mail : 297165331@qq.com
 * time : 2019/07/29
 * desc :
 */
class UOkHttp private constructor(){
    companion object{
        val instance :UOkHttp by lazy {
            UOkHttp()
        }
    }
    private var okHttpClient = OkHttpClient()
    private var cache = Cache(File(UStorage.getDirectoryByDirType(StorageType.TYPE_TEMP)), 10 * 1024 * 1024)

    fun getOkhttp(config: OkHttpConfig) =  okHttpClient.newBuilder()
            .addInterceptor(LibLogInterceptor())
            .connectTimeout(config.connectTimeout.toLong(), TimeUnit.SECONDS)
            .writeTimeout(config.writeTimeout.toLong(), TimeUnit.SECONDS)
            .readTimeout(config.readTimeout.toLong(), TimeUnit.SECONDS)
            .cache(cache)
            .build()

}