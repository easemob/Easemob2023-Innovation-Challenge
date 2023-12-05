package com.kangaroo.ktdemo.data.model.network.requests

import com.squareup.moshi.JsonClass

/**
 * @author  SHI DA WEI
 * @date  2023/11/13 15:57
 */
@JsonClass(generateAdapter = true)
class AIRequest {
    var model:String = "abab5.5-chat"
    var tokens_to_generate:Int = 1024
    var reply_constraints: Map<String,String> = mapOf<String,String>("sender_type" to "BOT", "sender_name" to "AI招聘助手")
    var bot_setting: List<Map<String,String>> = listOf(mapOf<String,String>("bot_name" to "AI招聘助手","content" to "AI招聘助手是一款帮助你修改简历的AI助手" ))
    var messages:MutableList<Chat> = mutableListOf()
}
//"sender_type": "USER","text": line
@JsonClass(generateAdapter = true)
data class Chat(val sender_type:String,val sender_name:String,val text:String)
//
//{
//    "model": "abab5.5-chat",
//    "tokens_to_generate": 1000,
//    "temperature": 0.5,
//    "top_p": 0.95,
//    "stream": true,
//    "reply_constraints": {
//    "sender_type": "BOT",
//    "sender_name": "MM智能助理"
//},
//    "sample_messages": [],
//    "plugins": [],
//    "messages": [
//    {
//        "sender_type": "USER",
//        "sender_name": "用户",
//        "text": "<<认真负责>>，以上是简历中的个人评价。帮我对它们进行优化，让它们更专业、吸引人。需要至少3条优化后的评价。"
//    },
//    {
//        "sender_type": "BOT",
//        "sender_name": "MM智能助理",
//        "text": "1. 具备高度的责任心和敬业精神，对工作充满热情，始终以实现卓越为目标。\n2. 注重细节，精益求精，对工作成果抱有极高的要求，力求超越领导的期望。\n3. 具备良好的沟通能力和团队协作精神，能够迅速融入团队并发挥积极作用。"
//    }
//    ],
//    "bot_setting": [
//    {
//        "bot_name": "MM智能助理",
//        "content": "MM智能助理是一款由MiniMax自研的，没有调用其他产品的接口的大型语言模型。MiniMax是一家中国科技公司，一直致力于进行大模型相关的研究。"
//    }
//    ]
//}