package com.kangaroo.ktdemo.data.network

import com.hyphenate.EMCallBack
import com.hyphenate.chat.EMClient
import com.hyphenate.chat.EMMessage
import com.hyphenate.exceptions.HyphenateException
import com.kangaroo.ktdemo.data.model.network.requests.AIRequest
import com.kangaroo.ktdemo.data.model.network.responses.AIResponse
import com.kangaroo.ktdemo.data.model.network.responses.LoginResponse
import com.kangaroo.ktdemo.data.model.network.responses.NetUser
import com.kangaroo.ktdemo.data.model.network.responses.RegistResponse
import com.kangaroo.ktdemo.data.service.AppService
import com.kangaroo.ktdemo.exception.BusinessException
import com.kangaroo.ktdemo.util.UStore
import com.kangaroo.ktlib.data.DataResult
import com.kangaroo.ktlib.util.log.ULog
import kotlinx.coroutines.delay
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import retrofit2.Response
import javax.inject.Inject
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException


class UserNetworkDataSource @Inject constructor() : NetworkDataSource {

    // A mutex is used to ensure that reads and writes are thread-safe.
    private val accessMutex = Mutex()
    private var tasks = listOf(
        NetUser(
            id = "PISA",
            title = "Build tower in Pisa",
            shortDescription = "Ground looks good, no foundation work required."
        ),
        NetUser(
            id = "TACOMA",
            title = "Finish bridge in Tacoma",
            shortDescription = "Found awesome girders at half the cost!"
        )
    )

    override suspend fun loadTasks(): List<NetUser> = accessMutex.withLock {
        delay(SERVICE_LATENCY_IN_MILLIS)
        return tasks
    }

    override suspend fun regist(name:String,pwd:String): DataResult<RegistResponse> {
        try {
            // 注册失败会抛出 HyphenateException。
            // 同步方法，会阻塞当前线程。
            EMClient.getInstance().createAccount(name, pwd)
            //成功
            //callBack.onSuccess(createLiveData(userName));
            return DataResult.Success<RegistResponse>(RegistResponse(200,"注册成功"))
        } catch (e: HyphenateException) {
            //失败
            //callBack.onError(e.getErrorCode(), e.getMessage());
            e.printStackTrace()
            return DataResult.Error(BusinessException(e.errorCode.toString(), e.message))
        }
    }

    override suspend fun login(name: String, pwd: String): DataResult<LoginResponse> = suspendCancellableCoroutine {

        EMClient.getInstance().login(name, pwd, object : EMCallBack {
            // 登录成功回调
            override fun onSuccess() {
                it.resume(DataResult.Success<LoginResponse>(LoginResponse(200,"登录成功")))
            }

            // 登录失败回调，包含错误信息
            override fun onError(code: Int, error: String) {
                it.resume(DataResult.Error(BusinessException(code.toString(), error)))
            }

            override fun onProgress(i: Int, s: String) {

            }
        })
    }

    override suspend fun loginout(): DataResult<Boolean> {
        var res = EMClient.getInstance().logout(true)
        return if(res == 0){
            DataResult.Success<Boolean>(true)
        }else{
            DataResult.Error(BusinessException(res.toString(),"退出失败"))
        }
    }

    override suspend fun sendMessage(content: String, toChatUsername: String): DataResult<Boolean> = suspendCancellableCoroutine {
        // `content` 为要发送的文本内容，`toChatUsername` 为对方的账号。
        var message = EMMessage.createTextSendMessage(content, toChatUsername);
        // 发送消息
        EMClient.getInstance().chatManager().sendMessage(message)
        it.resume(DataResult.Success<Boolean>(true))
    }

    override suspend fun chatcompletionPro(payload: AIRequest): AIResponse {
        return AppService.getApiService().chatcompletionPro(payload = payload)
    }

}

private const val SERVICE_LATENCY_IN_MILLIS = 2000L
