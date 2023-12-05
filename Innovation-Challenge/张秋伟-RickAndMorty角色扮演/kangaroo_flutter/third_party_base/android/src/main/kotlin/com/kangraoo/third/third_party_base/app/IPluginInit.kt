package com.kangraoo.third.third_party_base.app

/**
 * @author shidawei
 * 创建日期：2022/1/18
 * 描述：
 */
interface IPluginInit {

    fun appInit()

    fun notMainProcessThreadInit()

    fun notMainProcessInit()

    fun mainAppthreadInit()

    fun mainAppInit()

    //同意隐私调用方法
    fun privacy()
}