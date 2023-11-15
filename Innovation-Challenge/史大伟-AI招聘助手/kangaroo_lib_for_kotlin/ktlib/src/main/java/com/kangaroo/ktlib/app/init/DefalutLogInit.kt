package com.kangaroo.ktlib.app.init

import com.kangaroo.ktlib.app.SYS_LOG_TAG
import com.kangaroo.ktlib.util.log.OrhanobutLog

/**
 * @author  SHI DA WEI
 * @date  2023/10/25 17:09
 */
class DefalutLogInit(init : IInit,val showThreadInfo:Boolean = true,val methodCount:Int = 0,val methodOffset:Int = 0,val tag:String = "APP",val sysLogPrint:Boolean = true) :
    Init(init) {
    override fun init() {
        super.init()
        OrhanobutLog.addCustomLogAdapter(showThreadInfo,methodCount,methodOffset,tag) {
            if(sConfiger.debugStatic){
                if(sysLogPrint){
                    true
                }else{
                    !(it!=null&&it.contains(SYS_LOG_TAG))
                }
            }else{
                false
            }
        }
    }
}