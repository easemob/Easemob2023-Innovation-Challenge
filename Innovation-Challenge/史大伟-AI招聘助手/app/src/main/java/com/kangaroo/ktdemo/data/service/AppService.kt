package com.kangaroo.ktdemo.data.service

import com.kangaroo.ktdemo.app.API_NAME
import com.kangaroo.ktlib.app.AppEnvironment
import com.kangaroo.ktlib.util.HRetrofit


object AppService {

    suspend fun getApiService(): ApiService {

        return HRetrofit.instance(AppEnvironment.getEnvConfig()!![API_NAME]!!,null).retrofit!!.create(ApiService::class.java)
    }

}
