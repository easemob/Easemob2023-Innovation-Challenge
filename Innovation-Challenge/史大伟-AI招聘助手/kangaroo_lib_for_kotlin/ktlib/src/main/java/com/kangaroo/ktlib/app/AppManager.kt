package com.kangaroo.ktlib.app

import android.app.Activity
import android.content.Intent
import android.os.Process
import com.kangaroo.ktlib.app.init.sysContext
import com.kangaroo.ktlib.util.log.ULog
import kotlin.system.exitProcess

/**
 * app管理工具
 */
object AppManager {

    /**
     * 退出应用程序
     */
    fun appExit() {
        ActivityLifeManager.finishAllActivity()
        // 退出程序
        Process.killProcess(Process.myPid())
        exitProcess(1)
    }

    /**
     * 重启应用
     * @param activity
     */
    fun restartApp(activity: Activity) {
        val intent1 = Intent(activity, getRestartActivityClass())
        intent1.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK or Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED)
        if (intent1.component != null) {
            intent1.action = Intent.ACTION_MAIN
            intent1.addCategory(Intent.CATEGORY_LAUNCHER)
        }
        activity.finish()
        activity.startActivity(intent1)
        killCurrentProcess()
    }

    /**
     * 获取APP初始页面
     * @param context
     * @return
     */
    private fun getRestartActivityClass(): Class<out Activity?>? {
        val intent = sysContext.packageManager.getLaunchIntentForPackage(sysContext.packageName)
        if (intent != null && intent.component != null) {
            try {
                return Class.forName(
                    intent!!.component!!.className
                ) as Class<out Activity?>
            } catch (e: ClassNotFoundException) {
                // Should not happen, print it to the log!
                ULog.e(
                    "getLauncherActivity",
                    "Failed when resolving the restart activity class via getLaunchIntentForPackage, stack trace follows!",throwable = e, tag = tagToSysLogTag("app")
                )
            }
        }
        return null
    }

    private fun killCurrentProcess() {
        Process.killProcess(Process.myPid())
        exitProcess(10)
    }
}
