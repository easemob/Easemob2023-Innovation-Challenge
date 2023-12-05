package com.kangraoo.third.third_party_base.app

import com.kangraoo.third.third_party_base.tools.SSystem
import com.kangraoo.third.third_party_base.tools.task.TaskManager
import io.flutter.app.FlutterApplication

/**
 * @author shidawei
 * 创建日期：2022/1/19
 * 描述：
 */
abstract class SFApplication : FlutterApplication(),IPluginInit{

    override fun onCreate() {
        super.onCreate()
        AppPluginInit.iPluginInit = this
        AppPluginInit.create(this)
    }


}