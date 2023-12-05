/*
 * Copyright 2019 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.kangaroo.ktdemo.data.network

import com.kangaroo.ktdemo.app.AI_GROUP_ID
import com.kangaroo.ktdemo.data.model.network.requests.AIRequest
import com.kangaroo.ktdemo.data.model.network.responses.AIResponse
import com.kangaroo.ktdemo.data.model.network.responses.LoginResponse
import com.kangaroo.ktdemo.data.model.network.responses.NetUser
import com.kangaroo.ktdemo.data.model.network.responses.RegistResponse
import com.kangaroo.ktlib.data.DataResult
import retrofit2.Response
import retrofit2.http.Body
import retrofit2.http.Query

/**
 * Main entry point for accessing tasks data from the network.
 *
 */
interface NetworkDataSource {

    suspend fun loadTasks(): List<NetUser>

    suspend fun regist(name:String,pwd:String) : DataResult<RegistResponse>
    suspend fun login(name:String,pwd:String) : DataResult<LoginResponse>
    suspend fun loginout() : DataResult<Boolean>

    suspend fun sendMessage(content:String,toChatUsername:String) : DataResult<Boolean>

    suspend fun chatcompletionPro(payload: AIRequest): AIResponse
}
