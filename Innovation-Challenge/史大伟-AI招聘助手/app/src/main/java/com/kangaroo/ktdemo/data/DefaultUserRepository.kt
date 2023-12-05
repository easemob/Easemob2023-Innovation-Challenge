package com.kangaroo.ktdemo.data

import com.hyphenate.chat.EMClient
import com.kangaroo.ktdemo.data.local.LocalUserDataSource
import com.kangaroo.ktdemo.data.model.Task
import com.kangaroo.ktdemo.data.model.network.requests.AIRequest
import com.kangaroo.ktdemo.data.model.network.responses.AIResponse
import com.kangaroo.ktdemo.data.model.network.responses.LoginResponse
import com.kangaroo.ktdemo.data.model.network.responses.RegistResponse
import com.kangaroo.ktdemo.data.model.toExternal
import com.kangaroo.ktdemo.data.model.toLocal
import com.kangaroo.ktdemo.data.network.UserNetworkDataSource
import com.kangaroo.ktdemo.util.UStore
import com.kangaroo.ktlib.data.DataResult
import com.kangaroo.ktlib.data.succeeded
import com.kangaroo.ktlib.di.ApplicationScope
import com.kangaroo.ktlib.di.DefaultDispatcher
import com.kangaroo.ktlib.di.IoDispatcher
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.withContext
import retrofit2.Response
import javax.inject.Inject
import javax.inject.Singleton

/**
 * @author  SHI DA WEI
 * @date  2023/10/24 15:28
 */
@Singleton
class DefaultUserRepository @Inject constructor(
    private val networkDataSource: UserNetworkDataSource,
    private val localDataSource: LocalUserDataSource,
    @IoDispatcher private val dispatcher: CoroutineDispatcher,
    @ApplicationScope private val scope: CoroutineScope,
): UserRepository{

    override fun getTasksStream(): Flow<List<Task>> {
        return localDataSource.observeAll().map { tasks ->
            withContext(dispatcher) {
                tasks.toExternal()
            }
        }
    }
    override suspend fun refresh() {
        withContext(dispatcher) {
            val remoteTasks = networkDataSource.loadTasks()
            localDataSource.deleteAll()
            localDataSource.upsertAll(remoteTasks.toLocal())
        }
    }

    override suspend fun regist(name: String, pwd: String): DataResult<RegistResponse> {
        return withContext(dispatcher) {
            networkDataSource.regist(name, pwd)
        }
    }

    override suspend fun login(name: String, pwd: String): DataResult<LoginResponse> {
        return withContext(dispatcher) {
            var data = networkDataSource.login(name, pwd)
            if(data.succeeded){
                EMClient.getInstance().chatManager().loadAllConversations()
                EMClient.getInstance().groupManager().loadAllGroups()
                UStore.putUser {
                    it.token = name
                    it.userName = name
                }
            }
            data
        }
    }

    override suspend fun sendMessage(content: String, toChatUsername: String): DataResult<Boolean> {
        return withContext(dispatcher) {
            networkDataSource.sendMessage(content, toChatUsername)
        }
    }

    override suspend fun chatcompletionPro(payload: AIRequest): AIResponse {
        return withContext(dispatcher) {
            networkDataSource.chatcompletionPro(payload)
        }
    }

    override suspend fun loginout(): DataResult<Boolean> {
        return withContext(dispatcher) {
            networkDataSource.loginout()
        }
    }
}