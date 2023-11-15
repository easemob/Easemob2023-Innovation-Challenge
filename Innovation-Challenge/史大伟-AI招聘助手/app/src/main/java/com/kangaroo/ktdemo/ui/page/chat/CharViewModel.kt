package com.kangaroo.ktdemo.ui.page.chat

import androidx.compose.foundation.lazy.LazyListState
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.kangaroo.ktdemo.data.UserRepository
import com.kangaroo.ktdemo.data.model.ChatModel
import com.kangaroo.ktdemo.data.model.network.requests.AIRequest
import com.kangaroo.ktdemo.data.model.network.requests.Chat
import com.kangaroo.ktlib.util.log.ULog
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import javax.inject.Inject

/**
 * @author  SHI DA WEI
 * @date  2023/11/9 9:16
 */
@HiltViewModel
class CharViewModel @Inject constructor(
    private val userRepository: UserRepository
) : ViewModel() {

    var contentm by mutableStateOf("")
        private set

    fun updateContentm(input: String) {
        contentm = input
    }

    val list = mutableStateListOf<ChatModel>()
    val liststate = LazyListState()

    val isLoading = MutableStateFlow(false)


    private fun addContent(chatModel: ChatModel){
        list.add(chatModel)
    }

    var payload = AIRequest()

    private fun userSendMessage(content:String){
        viewModelScope.launch {
            userRepository.sendMessage(content,"AI")
        }
    }

    fun send(){
        addContent(ChatModel(true,contentm))
        userSendMessage(contentm)
        payload.let {
            it.messages.add(Chat("USER","用户",contentm))
        }
        isLoading.value = true
        viewModelScope.launch {
            val data = userRepository.chatcompletionPro(payload)
            payload.let {
                it.messages.add(Chat("BOT","AI招聘助手",data.reply))
            }
            addContent(ChatModel(false,data.reply))
            isLoading.value = false
            liststate.scrollToItem(list.size-1)
        }
        updateContentm("")

    }

}