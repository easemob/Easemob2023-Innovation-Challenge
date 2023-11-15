package com.kangaroo.ktlib.util.log

import com.kangaroo.ktlib.util.HString
import com.kangaroo.ktlib.util.json.HJson
import com.orhanobut.logger.AndroidLogAdapter
import com.orhanobut.logger.Logger
import com.orhanobut.logger.PrettyFormatStrategy

/**
 * author : WaTaNaBe
 * e-mail : 297165331@qq.com
 * time : 2020/09/16
 * desc :
 */
class OrhanobutLog: ILog {

    companion object{
        fun clearLogAdapters(){
            Logger.clearLogAdapters()
        }

        fun addCustomLogAdapter(showThreadInfo:Boolean,methodCount:Int,methodOffset:Int ,tag:String ,isLoggable:(String?) -> Boolean){
            val formatStrategy = PrettyFormatStrategy.newBuilder()
                .showThreadInfo(showThreadInfo)  // (Optional) Whether to show thread info or not. Default true
                .methodCount(methodCount)         // 决定打印多少行（每一行代表一个方法）默认：2
                .methodOffset(methodOffset)        // 设置方法的偏移量
                .tag(tag)   // (Optional) Custom tag for each log. Default PRETTY_LOGGER
                .build()
            Logger.addLogAdapter(object : AndroidLogAdapter(formatStrategy){
                override fun isLoggable(priority: Int, tag: String?): Boolean {
                    return isLoggable(tag)
                }

                override fun log(priority: Int, tag: String?, message: String) {
                    super.log(priority, tag, message)
                }
            })
        }
    }

    override fun d(vararg message: Any?, tag: String?) {
        Logger.t(tag).d(concatObject(*message))
    }

    override fun e(vararg message: Any?, tag: String?, throwable: Throwable?) {
        Logger.t(tag).let {
            if(throwable!=null){
                it.e(throwable,concatObject(*message))
            }else{
                it.e(concatObject(*message))
            }
        }
    }


    override fun w(vararg message: Any?, tag: String?) {
        Logger.t(tag).w(concatObject(*message))
    }

    override fun i(vararg message: Any?, tag: String?) {
        Logger.t(tag).i(concatObject(*message))
    }

    override fun v(vararg message: Any?, tag: String?) {
        Logger.t(tag).v(concatObject(*message))
    }

    override fun wtf(vararg message: Any?, tag: String?) {
        Logger.t(tag).wtf(concatObject(*message))
    }

    override fun dm(message: String, vararg args: Any?, tag: String?) {
        Logger.t(tag).d(message,*args)
    }

    override fun em(message: String, vararg args: Any?, tag: String?, throwable: Throwable?) {
        Logger.t(tag).let {
            if(throwable!=null){
                it.e(throwable,message,*args)
            }else{
                it.e(message,*args)
            }
        }
    }

    override fun wm(message: String, vararg args: Any?, tag: String?) {
        Logger.t(tag).w(message,*args)
    }

    override fun im(message: String, vararg args: Any?, tag: String?) {
        Logger.t(tag).i(message,*args)
    }

    override fun vm(message: String, vararg args: Any?, tag: String?) {
        Logger.t(tag).v(message,*args)
    }

    override fun wtfm(message: String, vararg args: Any?, tag: String?) {
        Logger.t(tag).wtf(message,*args)
    }

    override fun json(json: String, tag: String?) {
        Logger.t(tag).json(json)
    }

    override fun xml(xml: String, tag: String?) {
        Logger.t(tag).xml(xml)
    }

    override fun o(any: Any, tag: String?) {
        json(HJson.toSimpJson(any),tag = tag)
    }

//    private fun traceClassName():String = Thread.currentThread().stackTrace[3].fileName

    private fun concatObject(vararg args: Any?) = HString.concatObject(" ",*args)
}