package com.kangaroo.ktlib.app

import android.app.Activity
import android.app.Application
import android.os.Bundle

/**
 * author : WaTaNaBe
 * e-mail : 297165331@qq.com
 * time : 2020/09/09
 * desc :
 */
class DefaultActivityLifecycleCallbacks : Application.ActivityLifecycleCallbacks{
    override fun onActivityCreated(p0: Activity, p1: Bundle?) {
        ActivityLifeManager.sysCurrentActivity(p0)
        ActivityLifeManager.pushActivity(p0)
    }

    override fun onActivityStarted(p0: Activity) {
    }

    override fun onActivityResumed(p0: Activity) {
        ActivityLifeManager.sysCurrentActivity(p0)
    }

    override fun onActivityPaused(p0: Activity) {
        ActivityLifeManager.sysClearCurrentActivity(p0);
    }

    override fun onActivityStopped(p0: Activity) {
    }

    override fun onActivitySaveInstanceState(p0: Activity, p1: Bundle) {
    }

    override fun onActivityDestroyed(p0: Activity) {
        ActivityLifeManager.popActivity(p0);
    }
}