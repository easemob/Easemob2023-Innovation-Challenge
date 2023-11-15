package com.kangaroo.ktlib.util

import com.kangaroo.ktlib.R
import com.kangaroo.ktlib.app.init.sysContext
import com.kangaroo.ktlib.app.tagToSysLogTag
import com.kangaroo.ktlib.exception.LibNetWorkException
import com.kangaroo.ktlib.util.json.HJson
import com.kangaroo.ktlib.util.log.ULog
import com.kangaroo.ktlib.util.okhttp.OkHttpConfig
import com.kangaroo.ktlib.util.okhttp.UOkHttp
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.isActive
import kotlinx.coroutines.withContext
import retrofit2.Call
import retrofit2.Converter
import retrofit2.HttpException
import retrofit2.Retrofit
import retrofit2.converter.moshi.MoshiConverterFactory
import java.io.EOFException
import java.io.IOException
import java.net.ConnectException
import java.net.SocketException
import java.net.SocketTimeoutException
import java.net.UnknownHostException
import java.util.*
import javax.net.ssl.SSLException

class HRetrofit(baseUrl: String, factory: List<Converter.Factory>?,config: OkHttpConfig) {
    var retrofit: Retrofit? = null

    init {
        val builder = Retrofit.Builder()
            .baseUrl(baseUrl)
        if(factory!=null){
            for (cf in factory) {
                builder.addConverterFactory(cf)
            }
        }
        retrofit = builder
            .addConverterFactory(MoshiConverterFactory.create(HJson.uMosh.moshiBuild))
            .client(UOkHttp.instance.getOkhttp(config))
            .build()
    }

    companion object{
        private val hRetrofitMap: MutableMap<String, HRetrofit> = HashMap()
        fun instance(baseUrl: String, factory: List<Converter.Factory>?,config: OkHttpConfig = OkHttpConfig.build {  }): HRetrofit {
            if (!hRetrofitMap.containsKey(baseUrl)) {
                synchronized(hRetrofitMap) {
                    if (!hRetrofitMap.containsKey(baseUrl)) {
                        hRetrofitMap[baseUrl] = HRetrofit(baseUrl, factory,config)
                    }
                }
            }
            return hRetrofitMap[baseUrl]!!
        }

    }



}


suspend fun <T> Call<T>.subscribe(
    scope: CoroutineScope
): T? {
    return try {
        withContext(Dispatchers.IO) {
            val result = execute().body()
            // 检查协程是否取消
            if (isActive) {
                result
            } else null
        }
    } catch (e: Exception) {
        // 检查协程是否取消
        if (scope.isActive) {
            ULog.e("URL ", request().url.toString())
            errorHandle(e)
        }
        throw e
    }
}

val networkMsg: Int = R.string.libNetFailCheck
val networkNoMsg: Int = R.string.libNetNotNetCheck
val networkTimeOutMsg: Int = R.string.libNetTimeOutCheck
val networkErrorMsg: Int = R.string.libNetErrorCheck
val networkSuccessMsg: Int = R.string.libNetSuccessCheck
val networkJsonErrorMsg: Int = R.string.libNetJsonErrorCheck
val networkUnkonwnHostErrorMsg: Int = R.string.libNetUnknownHostCheck
val socketClose: Int = R.string.libSocketCloseCheck
val sslError: Int = R.string.libSslErrorCheck
private fun errorHandle(e: Exception) {
    when (e) {
        is HttpException -> {
            defaultError(e.code(), networkErrorMsg)
        }
        is UnknownHostException -> {
            defaultError(-1, networkUnkonwnHostErrorMsg)
        }
        is SocketTimeoutException -> {
            defaultError(-1, networkTimeOutMsg)
        }
        is ConnectException -> {
            defaultError(-1, networkMsg)
        }
        is SocketException -> {
            defaultError(-1, socketClose)
        }
        is EOFException -> {
            defaultError(-1, socketClose)
        }
        is SSLException -> {
            defaultError(-1, sslError)
        }
        else -> {
            throw e
        }
    }
}

private val defaultError = fun(code: Int, msg: Int) {
    val message = sysContext.resources.getString(msg)
    ULog.e(code, message, tag = tagToSysLogTag("net error"))
    throw LibNetWorkException(code, message)
}
