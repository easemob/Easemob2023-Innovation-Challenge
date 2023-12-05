package com.kangaroo.ktdemo.ui.page.setting

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.hyphenate.chat.EMClient
import com.kangaroo.ktdemo.data.UserRepository
import com.kangaroo.ktdemo.data.model.Task
import com.kangaroo.ktdemo.ui.page.login.LoginActivity
import com.kangaroo.ktdemo.ui.page.user.StatisticsUiState
import com.kangaroo.ktdemo.ui.page.user.getActiveAndCompletedStats
import com.kangaroo.ktdemo.util.StateManager
import com.kangaroo.ktlib.app.ActivityLifeManager
import com.kangaroo.ktlib.data.DataResult
import com.kangaroo.ktlib.util.Async
import com.kangaroo.ktlib.util.WhileUiSubscribed
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

/**
 * @author  SHI DA WEI
 * @date  2023/11/15 10:04
 */
@HiltViewModel
class SettingViewModel @Inject constructor(
    private val userRepository: UserRepository
) : ViewModel() {

    fun logout(){
        viewModelScope.launch {
            var data = userRepository.loginout()
            if(data is DataResult.Success){
                StateManager.lougout(ActivityLifeManager.getCurrentActivity()!!)
            }else if (data is DataResult.Error){

            }
        }
    }
}