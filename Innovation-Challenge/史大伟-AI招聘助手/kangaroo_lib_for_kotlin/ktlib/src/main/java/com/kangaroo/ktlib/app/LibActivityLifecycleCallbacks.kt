package com.kangaroo.ktlib.app

import android.app.Activity
import android.app.Application
import android.os.Bundle

/**
 * author : WaTaNaBe
 * e-mail : 297165331@qq.com
 * time : 2020/09/14
 * desc :
 */
class LibActivityLifecycleCallbacks (val lifecycleCallbacks :Application.ActivityLifecycleCallbacks):Application.ActivityLifecycleCallbacks by lifecycleCallbacks