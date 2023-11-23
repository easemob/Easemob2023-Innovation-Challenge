package com.kangraoo.third.third_party_base.app

import android.content.Context
import android.content.SharedPreferences
import com.kangraoo.third.third_party_base.tools.SSystem
import com.kangraoo.third.third_party_base.tools.task.TaskConfig
import com.kangraoo.third.third_party_base.tools.task.TaskManager
import io.flutter.app.FlutterApplication

/**
 * @author shidawei
 * 创建日期：2022/1/18
 * 描述：
 */
object AppPluginInit {

    var debugStatic: Boolean = false
    var privacy : Boolean = false
    var taskConfig = TaskConfig.build { }
    lateinit var sps : SharedPreferences

    fun create(mContext: Context){
        sps = mContext.getSharedPreferences("AppPluginInit",Context.MODE_PRIVATE)
        debugStatic = sps.getBoolean(DEBUG,false)
        privacy = sps.getBoolean(PRIVACY,false)
        iPluginInit?.appInit()
        if (SSystem.inMainProcess(mContext)) {
            iPluginInit?.mainAppInit()
            TaskManager.taskExecutor.execute {
                iPluginInit?.mainAppthreadInit()
            }
        } else {
            iPluginInit?.notMainProcessInit()
            TaskManager.taskExecutor.execute {
                iPluginInit?.notMainProcessThreadInit()
            }
        }
    }

    fun init(mContext: Context, debugStatic: Boolean, privacy : Boolean){
        this.debugStatic = debugStatic
        this.privacy = privacy
        val edit = sps.edit()
        edit.putBoolean(DEBUG,debugStatic)
        edit.putBoolean(PRIVACY,privacy)
        edit.apply()
    }

    var iPluginInit: IPluginInit? = null

    fun update(mContext: Context, privacy: Boolean) {
        this.privacy = privacy
        val edit = sps.edit()
        edit.putBoolean(PRIVACY,privacy)
        edit.apply()
        if(privacy){
            iPluginInit?.privacy()
        }
    }


}