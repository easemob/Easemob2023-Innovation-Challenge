package com.kangaroo.ktlib.app

import com.kangaroo.ktlib.app.init.sConfiger
import com.kangaroo.ktlib.app.init.sysDataStore
import com.kangaroo.ktlib.util.log.ULog
import kotlinx.coroutines.flow.first

/**
 * @author  SHI DA WEI
 * @date  2023/10/31 14:49
 */
enum class Environment {
    PRODUCT, DEV, TEST, LOCAL
}
object AppEnvironment {

    private var tenv:Environment? = null

    private lateinit var tenvs:Map<Environment,Map<String,String?>>

    private var tdefalutEnv = Environment.PRODUCT


    fun init(envs : Map<Environment,Map<String,String?>>,defalutEnv:Environment = Environment.PRODUCT){
        ULog.o(envs, tagToSysLogTag("AppEnvironment"))
        tenvs = envs
        if(sConfiger.debugStatic){
            tdefalutEnv = defalutEnv
        }
    }

    suspend fun setEnv(env:Environment){
        tenv = env
        sysDataStore.putData(SYS_ENV,env.name)
    }

    suspend fun getEnv():Environment{
        if(sConfiger.debugStatic){
            if(tenv!=null){
                return tenv!!
            }
            var name = sysDataStore.getData(SYS_ENV, tdefalutEnv.name).first()
            tenv = Environment.valueOf(name!!)
            return tenv!!
        }
        return tdefalutEnv
    }

    suspend fun getEnvConfig():Map<String, String?>?{
        return tenvs[getEnv()]
    }

    fun getEnvs():Map<Environment,Map<String,String?>>{
        return tenvs
    }

}