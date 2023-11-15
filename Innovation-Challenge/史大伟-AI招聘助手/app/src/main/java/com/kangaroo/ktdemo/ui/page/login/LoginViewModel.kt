package com.kangaroo.ktdemo.ui.page.login

import androidx.lifecycle.ViewModel
import dagger.hilt.android.lifecycle.HiltViewModel
import androidx.compose.runtime.*
import androidx.compose.ui.platform.LocalContext
import androidx.lifecycle.viewModelScope
import com.hyphenate.chat.EMClient
import com.hyphenate.exceptions.HyphenateException
import com.kangaroo.ktdemo.data.DefaultUserRepository
import com.kangaroo.ktdemo.data.UserRepository
import com.kangaroo.ktdemo.util.StateManager
import com.kangaroo.ktlib.app.ActivityLifeManager
import com.kangaroo.ktlib.data.DataResult
import com.kangaroo.ktlib.util.log.ULog
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

data class LoginUiState(
    val isLoading: Boolean = false,
    val userMessage: String? = null,
)


/**
 * @author  SHI DA WEI
 * @date  2023/11/6 14:43
 */
@HiltViewModel
class LoginViewModel @Inject constructor(
    private val userRepository: UserRepository
) : ViewModel() {
    var username by mutableStateOf("")
        private set

    var password by mutableStateOf("")
        private set

    fun updateUsername(input: String) {
        username = input
    }

    fun updatePassword(input: String) {
        password = input
    }

    fun login(){
        _uiState.update {
            it.copy(isLoading = true)
        }
        viewModelScope.launch {
            var data = userRepository.login(username, password)
            _uiState.update {
                it.copy(isLoading = false)
            }
            if(data is DataResult.Success){
                showSnackbarMessage(data.data.message)
                StateManager.init(ActivityLifeManager.getCurrentActivity()!!)
            }else if (data is DataResult.Error){
                showSnackbarMessage("登录失败${data.exception.message}")
            }
        }
    }

    private val _uiState = MutableStateFlow(LoginUiState())
    val uiState: StateFlow<LoginUiState> = _uiState.asStateFlow()

    fun regist(){
        _uiState.update {
            it.copy(isLoading = true)
        }
        viewModelScope.launch {
            var data = userRepository.regist(username, password)

            if(data is DataResult.Success){
//                showSnackbarMessage(data.data.message)
                login()
            }else if (data is DataResult.Error){
                _uiState.update {
                    it.copy(isLoading = false)
                }
                showSnackbarMessage("注册失败${data.exception.message}")
            }
        }
    }
//    private val _userMessage: MutableStateFlow<String?> = MutableStateFlow(null)
//    private val _isLoading = MutableStateFlow(false)

    private fun showSnackbarMessage(message: String) {
        _uiState.update {
            it.copy(userMessage = message)
        }
    }

    fun snackbarMessageShown() {
        _uiState.update {
            it.copy(userMessage = null)
        }
    }
}