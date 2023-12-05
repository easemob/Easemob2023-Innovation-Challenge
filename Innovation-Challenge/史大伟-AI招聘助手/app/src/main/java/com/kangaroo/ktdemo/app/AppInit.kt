package com.kangaroo.ktdemo.app

import com.hyphenate.chat.EMClient
import com.hyphenate.chat.EMOptions
import com.kangaroo.ktlib.app.AppEnvironment
import com.kangaroo.ktlib.app.ENV_NAME
import com.kangaroo.ktlib.app.Environment
import com.kangaroo.ktlib.app.init.IInit
import com.kangaroo.ktlib.app.init.Init
import com.kangaroo.ktlib.app.init.sysContext
import com.kangaroo.ktlib.util.HRetrofit
import com.kangaroo.ktlib.util.log.ULog
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

/**
 * @author  SHI DA WEI
 * @date  2023/11/13 10:19
 */
class AppInit(init : IInit)  : Init(init) {
    override fun init() {
        super.init()
        var options = EMOptions()
        options.appKey = EM_OPTIONS_KEY
        EMClient.getInstance().init(sysContext, options)
//        https://api.minimax.chat/v1/text/chatcompletion_pro?GroupId={group_id}
//        Map<Environment, Map<String, String?>> envs
        var envs = mutableMapOf<Environment, Map<String, String?>>()
        var product = mutableMapOf<String, String?>()
        product[ENV_NAME] = "生产";
        product[API_NAME] = "https://api.minimax.chat/"
        envs[Environment.PRODUCT] = product
        AppEnvironment.init(envs)
        GlobalScope.launch {
            var config = AppEnvironment.getEnvConfig()
            ULog.d(config)
            HRetrofit.instance(config!![API_NAME]!!,null)
        }
    }
}