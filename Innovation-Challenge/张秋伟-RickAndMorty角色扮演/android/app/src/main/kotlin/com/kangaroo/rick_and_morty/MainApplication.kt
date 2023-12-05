package com.kangaroo.rick_and_morty

import com.kangraoo.third.third_party_base.app.SFApplication;

class MainApplication : SFApplication() {

    override fun appInit(){}

    override fun notMainProcessThreadInit(){}

    override fun notMainProcessInit(){}

    override fun mainAppthreadInit(){}

    override fun mainAppInit(){}

    //同意隐私调用方法
    override fun privacy(){}
}