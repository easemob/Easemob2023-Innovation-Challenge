package com.kangaroo.ktlib.data.models

import android.os.Parcelable
import com.kangaroo.ktlib.util.UTime
import java.io.Serializable

/**
 * author : WaTaNaBe
 * e-mail : 297165331@qq.com
 * time : 2020/09/15
 * desc : 过期模型
 */
class SExpModel(val value: Any?, val expireMills: Long,val createTime: Long = UTime.currentTimeMillis()) : Serializable {

    fun isExpire() = !(createTime + expireMills > UTime.currentTimeMillis() || expireMills < 0)
}
//
//@Parcelize
//class SExpParceModel(var key: String?,val expireMills: Long,val createTime: Long = UTime.currentTimeMillis()) : Parcelable {
//    fun isExpire() = !(createTime + expireMills > UTime.currentTimeMillis() || expireMills < 0)
//}