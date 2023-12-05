package com.kangaroo.ktdemo.exception

/**
 * @author shidawei
 * 创建日期：2021/8/13
 * 描述：
 */
class BusinessException(val code: String, msg: String?) : Exception(msg)