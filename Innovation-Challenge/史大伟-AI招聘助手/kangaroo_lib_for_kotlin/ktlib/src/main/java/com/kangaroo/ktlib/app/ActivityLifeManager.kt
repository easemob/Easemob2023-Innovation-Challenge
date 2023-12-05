package com.kangaroo.ktlib.app

import android.app.Activity
import androidx.annotation.NonNull
import com.kangaroo.ktlib.R
import com.kangaroo.ktlib.util.log.ULog
import java.lang.ref.WeakReference
import java.util.*
import kotlin.collections.HashMap

/**
 * author : WaTaNaBe
 * e-mail : 297165331@qq.com
 * time : 2020/09/14
 * desc :
 */
object ActivityLifeManager {

    private var currentActivity:WeakReference<Activity>? = null
    private val activityStack = HashMap<Int,Stack<Activity>>()
    /**
     * 设置当前活动的activity
     */
    @JvmStatic fun sysCurrentActivity(activity:Activity){
        currentActivity?.clear()
        currentActivity = null
        currentActivity = WeakReference(activity)
    }

    /**
     * 得到当前活动的activity
     */
    @JvmStatic fun getCurrentActivity(): Activity?{
        return currentActivity?.get()
    }

    /**
     * 清除当前活动的activity
     */
    @JvmStatic fun sysClearCurrentActivity(activity : Activity){
        val cur = currentActivity?.get()
        if(cur!=null && cur === activity){
            currentActivity?.clear()
            currentActivity = null
        }
    }

    /**
     * 栈中有多少activity
     */
    @JvmStatic fun activityInStack(activity: Activity):Int{
        val taskId = activity.taskId
        if (taskId in activityStack.keys){
            val stack = activityStack[taskId]
            if(stack!=null&&stack.size>0){
                return stack.size
            }
        }
        return 0
    }

    /**
     * 将Activity入栈
     */
    @JvmStatic fun pushActivity(@NonNull activity: Activity){
        val taskId = activity.taskId
        val stack:Stack<Activity>?
        if (taskId in activityStack.keys){
            stack = activityStack[taskId]
        }else{
            stack = Stack<Activity>()
            activityStack[taskId] = stack
        }
        stack!!.push(activity)

        ULog.i(activity.getString(R.string.libActivityFrom), "(" + activity.javaClass.simpleName+".kt :" + 1 + ")","(" + activity.javaClass.simpleName+".java :" + 1 + ")", activity.getString(R.string.libActivityInStack), tag = tagToSysLogTag("activityLife"));

    }

    /**
     * 将activity出栈
     */
    @JvmStatic fun popActivity(@NonNull activity: Activity){
        val taskId = activity.taskId
        val stack:Stack<Activity>?
        if (taskId in activityStack.keys){
            stack = activityStack[taskId]
            if(stack!=null&&stack.size>0){
                stack.pop()
            }
            if(activityInStack(activity)==0){
                activityStack.remove(activity.taskId)
            }
        }
        if(activityInStack()==0){
            if(activity.applicationContext is IActivityStackClear){
                (activity.applicationContext as IActivityStackClear).clearAllActivity()
            }
        }

        ULog.i(activity.getString(R.string.libActivityFrom), "("+activity.javaClass.simpleName+".kt :" + 1  + ")","(" + activity.javaClass.simpleName+".java :" + 1 + ")"  ,activity.getString(R.string.libActivityOutStack), tag = tagToSysLogTag("activityLife"));

    }

    /**
     * 所有栈中有多少activity
     */
    @JvmStatic fun activityInStack():Int{
        var size:Int = 0
        activityStack.forEach {
            size += it.value.size
        }
        return size
    }

    /**
     * 退出栈中所有Activity
     */
    @JvmStatic fun finishAllActivity(){
        activityStack.forEach {
            it.value.forEach { ac ->
                ac.finish()
            }
        }
    }

    /**
     * 退出当前task栈中所有Activity
     */
    @JvmStatic fun finishAllActivity(activity:Activity){
        val taskId = activity.taskId
        if (taskId in activityStack.keys){
            activityStack[taskId]?.forEach { ac ->
                ac.finish()
            }
        }
    }



}