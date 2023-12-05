package com.kangaroo.ktdemo.util

import android.app.Activity
import com.hyphenate.chat.EMClient
import com.kangaroo.ktdemo.ui.page.login.LoginActivity
import com.kangaroo.ktdemo.ui.page.main.MainActivity
import com.kangaroo.ktlib.util.log.ULog

/**
 * @author  SHI DA WEI
 * @date  2023/11/2 14:04
 */
object StateManager {

    suspend fun init(activity: Activity){
        if(UStore.hasUser()){
            EMClient.getInstance().chatManager().loadAllConversations()
            EMClient.getInstance().groupManager().loadAllGroups()
            MainActivity.startFrom(activity)
        }else{
            LoginActivity.startFrom(activity)
        }
    }

    suspend fun lougout(activity: Activity){
        UStore.clearUser()
        LoginActivity.startFromClearTop(activity)
    }
}