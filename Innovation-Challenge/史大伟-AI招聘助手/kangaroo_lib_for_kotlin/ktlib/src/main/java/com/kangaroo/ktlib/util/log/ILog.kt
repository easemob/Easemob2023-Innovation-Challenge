package com.kangaroo.ktlib.util.log

import com.orhanobut.logger.LogAdapter

/**
 * author : WaTaNaBe
 * e-mail : 297165331@qq.com
 * time : 2020/09/16
 * desc :
 */
interface ILog {

    fun d(vararg message : Any?,tag:String?=null)

    fun e(vararg message : Any?,tag:String?=null,throwable:Throwable? = null)

    fun w(vararg message : Any?,tag:String?=null)

    fun i(vararg message : Any?,tag:String?=null)

    fun v(vararg message : Any?,tag:String?=null)

    fun wtf(vararg message : Any?,tag:String?=null)

    @Deprecated("It is bad function")
    fun dm(message : String, vararg args : Any?,tag:String?=null)
    @Deprecated("It is bad function")
    fun em(message : String, vararg args : Any?,tag:String?=null,throwable :Throwable?=null)

    @Deprecated("It is bad function")
    fun wm(message : String, vararg args : Any?,tag:String?=null)

    @Deprecated("It is bad function")
    fun im(message : String, vararg args : Any?,tag:String?=null)

    @Deprecated("It is bad function")
    fun vm(message : String, vararg args : Any?,tag:String?=null)

    @Deprecated("It is bad function")
    fun wtfm(message : String, vararg args : Any?,tag:String?=null)

    /**
     * Formats the given json content and print it
     */
    fun json(json:String,tag:String?=null)

    /**
     * Formats the given xml content and print it
     */
    fun xml(xml :String,tag:String?=null)

    fun o(any: Any,tag:String?=null)

}