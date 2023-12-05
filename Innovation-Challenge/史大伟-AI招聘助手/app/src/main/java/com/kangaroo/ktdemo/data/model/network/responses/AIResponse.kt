package com.kangaroo.ktdemo.data.model.network.responses

import com.kangaroo.ktdemo.data.model.network.requests.Chat
import com.squareup.moshi.JsonClass

/**
 * @author  SHI DA WEI
 * @date  2023/11/14 14:03
 */
@JsonClass(generateAdapter = true)
class AIResponse (val reply:String)

//@JsonClass(generateAdapter = true)
//class Choices (val messages:MutableList<Chat>)
//
//{
//    "created": 1699941717,
//    "model": "abab5.5-chat",
//    "reply": "你好！请问有什么可以帮到你的吗？",
//    "choices": [
//    {
//        "finish_reason": "stop",
//        "messages": [
//        {
//            "sender_type": "BOT",
//            "sender_name": "AI招聘助手",
//            "text": "你好！请问有什么可以帮到你的吗？"
//        }
//        ]
//    }
//    ],
//    "usage": {
//    "total_tokens": 101
//},
//    "input_sensitive": false,
//    "output_sensitive": false,
//    "id": "01a240542ea6a397c75862aa3c92b2fb",
//    "base_resp": {
//    "status_code": 0,
//    "status_msg": ""
//}
//}