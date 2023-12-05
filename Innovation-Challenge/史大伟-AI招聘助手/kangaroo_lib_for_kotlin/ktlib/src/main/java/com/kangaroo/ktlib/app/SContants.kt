package com.kangaroo.ktlib.app

/**
 * author : WaTaNaBe
 * e-mail : 297165331@qq.com
 * time : 2020/09/14
 * desc :
 */
//system log tag
internal const val SYS_LOG_TAG = "SYS_LOG_"

//my tag with system log tag
internal fun tagToSysLogTag(tag:String?) = "$SYS_LOG_TAG$tag"


internal const val SYS_DEBUG_CONSOLE = "sys_debug_console"
internal const val SYS_DEBUG_STATUS = "sys_debug_status"
internal const val SYS_DEBUG_DATA_LIST = "sys_debug_data_list"
internal const val SYS_DEBUG_DATA_SELECT = "sys_debug_data_select"

//系统环境
internal const val SYS_ENV = "SYS_ENV";

internal const val SYS_PERSISTENT = "sys_persistent.pd"

const val ENV_NAME = "ENV_NAME";