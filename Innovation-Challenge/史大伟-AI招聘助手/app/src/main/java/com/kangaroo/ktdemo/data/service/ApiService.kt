package com.kangaroo.ktdemo.data.service

import com.kangaroo.ktdemo.app.AI_GROUP_ID
import com.kangaroo.ktdemo.app.AI_SCRICT
import com.kangaroo.ktdemo.data.model.network.requests.AIRequest
import com.kangaroo.ktdemo.data.model.network.responses.AIResponse
import retrofit2.Response
import retrofit2.http.*

interface ApiService {
//    headers = {"Authorization": f"Bearer {api_key}", "Content-Type": "application/json"}
    @POST(ApiMethods.chatcompletionPro)
    @Headers(
        "Authorization:Bearer $AI_SCRICT",
        "Content-Type:application/json"
    )
    suspend fun chatcompletionPro(@Query("GroupId") groupId:Long = AI_GROUP_ID,@Body payload: AIRequest): AIResponse

}
