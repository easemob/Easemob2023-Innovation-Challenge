package com.kangaroo.ktlib.app

import android.app.Application
import android.util.Log
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.ProcessLifecycleOwner
import com.kangaroo.ktlib.app.init.DefalutJsonInit
import com.kangaroo.ktlib.app.init.DefalutLogInit
import com.kangaroo.ktlib.app.init.DefaultInit
import com.kangaroo.ktlib.app.init.IInit
import com.kangaroo.ktlib.util.SSystem
import com.kangaroo.ktlib.util.log.ULog

abstract class KApplication : Application(),IActivityStackClear {

    companion object{
        fun processLifeCycleOwner(iApplicationLife: IApplicationLife){
            ProcessLifecycleOwner.get().lifecycle.addObserver(object : LifecycleEventObserver{
                override fun onStateChanged(source: LifecycleOwner, event: Lifecycle.Event) {
                    when (event) {
                        Lifecycle.Event.ON_CREATE -> {
                            iApplicationLife.onLifeCreate()
                        }
                        Lifecycle.Event.ON_START -> {
                            iApplicationLife.onLifeStart()
                        }
                        Lifecycle.Event.ON_RESUME -> { // 应用前台
                            iApplicationLife.onLifeResume()
                        }
                        Lifecycle.Event.ON_PAUSE -> { // 应用后台
                            iApplicationLife.onLifePause()
                        }
                        Lifecycle.Event.ON_STOP -> {
                            iApplicationLife.onLifeStop()
                        }
                        else -> {}
                    }
                }
            })
        }
    }

    override fun onTerminate() {
        super.onTerminate()
        if(systemActivityLifecycleCallbacks!=null){
            unregisterActivityLifecycleCallbacks(systemActivityLifecycleCallbacks)
        }
        systemActivityLifecycleCallbacks = null
    }

    override fun onCreate() {
        super.onCreate()
        appInit().init()
        processLifeCycleOwner(DefaultApplicationLife())
        systemActivityLifecycleCallbacks = getActivityLifecycleCallbacks()
        registerActivityLifecycleCallbacks(systemActivityLifecycleCallbacks)
    }

    open fun appInit(): IInit {
        return DefalutLogInit(DefalutJsonInit(DefaultInit(this)))
    }


    private var systemActivityLifecycleCallbacks:ActivityLifecycleCallbacks? = null


    open fun getActivityLifecycleCallbacks():ActivityLifecycleCallbacks{
        return DefaultActivityLifecycleCallbacks()
    }

    override fun clearAllActivity() {
        ULog.d("clearAllActivity", tag = tagToSysLogTag("Application"))
    }

}

interface IActivityStackClear{
    fun clearAllActivity();
}

interface IApplicationLife {
    fun onLifePause()

    fun onLifeStop()

    fun onLifeStart()
    fun onLifeResume()
    fun onLifeCreate()
}

class DefaultApplicationLife : IApplicationLife{

    val tag:String = "ApplicationLife"

    override fun onLifePause() {
        ULog.d("onLifePause", tag = tagToSysLogTag(tag))
    }

    override fun onLifeStop() {
        ULog.d("onLifeStop", tag = tagToSysLogTag(tag))
    }

    override fun onLifeStart() {
        ULog.d("onLifeStart", tag = tagToSysLogTag(tag))
    }

    override fun onLifeResume() {
        ULog.d("onLifeResume", tag = tagToSysLogTag(tag))
    }

    override fun onLifeCreate() {
        ULog.d("onLifeCreate", tag = tagToSysLogTag(tag))
    }

}