package com.kangaroo.ktlib.data

import com.kangaroo.ktlib.R
import com.kangaroo.ktlib.app.init.sysContext
import com.kangaroo.ktlib.app.tagToSysLogTag
import com.kangaroo.ktlib.exception.LibNetWorkException
import com.kangaroo.ktlib.util.HNetwork
import com.kangaroo.ktlib.util.log.ULog
import kotlinx.coroutines.CancellationException
import java.net.ConnectException
import java.net.SocketTimeoutException
import java.net.UnknownHostException
import retrofit2.HttpException

/**
 * A generic class that holds a value with its loading status.
 * @param <T>
 */
sealed class DataResult<out R> {

    data class Success<out T>(val data: T) : DataResult<T>()
    data class Error(var exception: Exception) : DataResult<Nothing>() {
        init {
            ULog.e(exception.message, tag = tagToSysLogTag("DataResult"), throwable = exception)
        }
    }

    override fun toString(): String {
        return when (this) {
            is Success<*> -> "Success[data=$data]"
            is Error -> "Error[exception=$exception]"
        }
    }
}

/**
 * `true` if [Result] is of type [Success] & holds non-null [Success.data].
 */
val DataResult<*>.succeeded
    get() = this is DataResult.Success && data != null
//
//val networkMsg: Int = R.string.libNetFailCheck
//val networkNoMsg: Int = R.string.libNetNotNetCheck
//val networkTimeOutMsg: Int = R.string.libNetTimeOutCheck
//val networkErrorMsg: Int = R.string.libNetErrorCheck
//val networkSuccessMsg: Int = R.string.libNetSuccessCheck
//val networkJsonErrorMsg: Int = R.string.libNetJsonErrorCheck
//val networkUnkonwnHostErrorMsg: Int = R.string.libNetUnknownHostCheck
//
//private val defaultError = fun(code: Int, msg: Int):Exception {
//    val message = sysContext.resources.getString(msg)
//    ULog.e(code, message, tag = tagToSysLogTag("net error"))
//    return LibNetWorkException(code, message)
//}
//
//fun DataResult.Error.netError(): DataResult.Error {
//    if (exception is ConnectException) {
//        this.exception = defaultError(-1, networkMsg)
//    } else if (exception is SocketTimeoutException) {
//        this.exception = defaultError(-1, networkTimeOutMsg)
//    } else if (exception is HttpException) {
//        val code = (exception as HttpException).code()
//        val msg: String = HString.concatObject(
//            " ",
//            SApplication.context().getString(networkErrorMsg),
//            "code:",
//            code
//        )
//        TipToast.tip(Tip.Error, msg)
//    } else if (exception is UnknownHostException) {
//        if (HNetwork.checkNetwork(sysContext)) {
//            this.exception = defaultError(-1, networkUnkonwnHostErrorMsg)
//        } else {
//            this.exception = defaultError(-1, networkNoMsg)
//        }
//    }  else if (exception is CancellationException) {
//        ULog.e(exception,"job was cancel")
//    } else if (exception is LibNetWorkException) {
//        if (exception.code == 504) {
//            TipToast.tip(
//                Tip.Error,
//                RxTransformerHelper.networkNoMsg
//            )
//        } else {
//            val msg: String = HString.concatObject(
//                " ",
//                SApplication.context().getString(networkErrorMsg),
//                "code:",
//                exception.code,
//                exception.message
//            )
//            TipToast.tip(Tip.Error, msg)
//        }
//    } else {
//        if(SApplication.instance().sConfiger.debugStatic){
//            TipToast.tip(Tip.Error,exception.message.toString())
//        }
//    }
//    return this
//}
//
//val DataResult<*>.netLibError
//    get() = this is DataResult.Error && (this.exception is ConnectException || this.exception is SocketTimeoutException || this.exception is JsonSyntaxException || this.exception is HttpException || this.exception is UnknownHostException || this.exception is LibNetWorkException)
