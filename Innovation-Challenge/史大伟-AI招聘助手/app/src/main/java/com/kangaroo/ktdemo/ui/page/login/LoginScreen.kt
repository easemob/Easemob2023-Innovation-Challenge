package com.kangaroo.ktdemo.ui.page.login

import android.annotation.SuppressLint
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.hyphenate.chat.EMClient
import com.hyphenate.exceptions.HyphenateException
import com.kangaroo.ktdemo.R
import com.kangaroo.ktdemo.ui.page.user.UserViewModel
import com.kangaroo.ktdemo.ui.theme.PurpleGrey40
import com.kangaroo.ktdemo.ui.theme.White2F7
// for a 'val' variable
import androidx.compose.runtime.getValue
// for a `var` variable also add
import androidx.compose.runtime.setValue
// or just
import androidx.compose.runtime.*
import com.kangaroo.ktdemo.widget.MyDialogLoding
import kotlinx.coroutines.launch

/**
 * @author  SHI DA WEI
 * @date  2023/11/6 17:00
 */
@SuppressLint("UnusedMaterial3ScaffoldPaddingParameter")
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun LoginScreen(viewModel:LoginViewModel = hiltViewModel()){
    val uiState by viewModel.uiState.collectAsStateWithLifecycle()
    val snackbarHostState = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()
    // Check for user messages to display on the screen

    Scaffold(
        snackbarHost = { SnackbarHost(snackbarHostState) },
    ){


        uiState.userMessage?.let { userMessage ->
            scope.launch {
                snackbarHostState.showSnackbar(userMessage)
                viewModel.snackbarMessageShown()
            }
        }
        MyDialogLoding(uiState.isLoading)
        Box(modifier = Modifier
            .fillMaxSize()
            .background(PurpleGrey40)){
            Column (modifier = Modifier
                .fillMaxWidth()
                .padding(top = 80.dp, start = 20.dp, end = 20.dp)){
                Text(text = "WellCome", color = White2F7, fontSize = 30.sp, modifier = Modifier.padding(bottom = 10.dp))
                Text(text = LocalContext.current.getString(R.string.app_name), color = White2F7, fontSize = 30.sp)
            }

            Column (modifier = Modifier
                .fillMaxWidth()
                .align(Alignment.BottomCenter)
                .padding(start = 20.dp, end = 20.dp, bottom = 80.dp)) {
                TextField(
                    value = viewModel.username,
                    onValueChange = {
                        viewModel.updateUsername(it)
                    },
                    placeholder = {
                        Text("请输入用户名")
                    },
                    modifier = Modifier.fillMaxWidth()
                )
                TextField(
                    value = viewModel.password,
                    onValueChange = {
                        viewModel.updatePassword(it)
                    },
                    placeholder = {
                        Text("请输入密码")
                    },
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(top = 10.dp)
                )
                Row (modifier = Modifier.padding(top = 20.dp)){
                    Button(colors = ButtonDefaults.buttonColors(containerColor = Color.Black),modifier = Modifier
                        .weight(1f)
                        .padding(start = 10.dp, end = 10.dp),onClick = {
                            viewModel.login()
                    }){
                        Text(text = "登录")
                    }
                    Button(colors = ButtonDefaults.buttonColors(containerColor = Color.Blue),modifier = Modifier
                        .weight(1f)
                        .padding(start = 10.dp, end = 10.dp),onClick = {
                        viewModel.regist()
                        }) {
                        Text(text = "去注册")
                    }
                }

            }
        }
    }

}