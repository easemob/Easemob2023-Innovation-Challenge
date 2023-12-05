package com.kangaroo.ktdemo.data

import com.kangaroo.ktdemo.data.model.Task
import com.kangaroo.ktdemo.data.model.network.requests.AIRequest
import com.kangaroo.ktdemo.data.model.network.responses.AIResponse
import com.kangaroo.ktdemo.data.model.network.responses.LoginResponse
import com.kangaroo.ktdemo.data.model.network.responses.RegistResponse
import com.kangaroo.ktlib.data.DataResult
import kotlinx.coroutines.flow.Flow
import retrofit2.Response

/**
 * @author  SHI DA WEI
 * @date  2023/10/24 15:22
 */
interface UserRepository {

    fun getTasksStream(): Flow<List<Task>>
    suspend fun refresh()

    suspend fun regist(name:String,pwd:String) : DataResult<RegistResponse>

    suspend fun login(name: String, pwd: String):DataResult<LoginResponse>

    suspend fun sendMessage(content:String,toChatUsername:String) : DataResult<Boolean>

    suspend fun chatcompletionPro(payload: AIRequest): AIResponse

    suspend fun loginout() : DataResult<Boolean>

}