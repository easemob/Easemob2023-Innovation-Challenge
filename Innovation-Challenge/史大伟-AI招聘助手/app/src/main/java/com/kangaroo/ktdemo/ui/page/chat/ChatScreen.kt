package com.kangaroo.ktdemo.ui.page.chat

import android.annotation.SuppressLint
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AccountBox
import androidx.compose.material.icons.filled.AccountCircle
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.kangaroo.ktdemo.R
import com.kangaroo.ktdemo.data.model.ChatModel
import com.kangaroo.ktdemo.ui.page.login.LoginViewModel
import com.kangaroo.ktdemo.ui.theme.Purple80
import com.kangaroo.ktdemo.ui.theme.PurpleGrey40
import com.kangaroo.ktdemo.ui.theme.White2F7
import com.kangaroo.ktdemo.widget.MyDialogLoding
import com.kangaroo.ktdemo.widget.TopBarWidget
import kotlinx.coroutines.launch

/**
 * @author  SHI DA WEI
 * @date  2023/11/9 9:16
 */
@SuppressLint("UnusedMaterial3ScaffoldPaddingParameter", "StateFlowValueCalledInComposition")
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ChatScreen(viewModel: CharViewModel = hiltViewModel()){
    Scaffold(
        topBar = { TopBarWidget(title = LocalContext.current.getString(R.string.app_name), back = true) },

    ){ it ->

        Box(modifier = Modifier
            .padding(it)
            .fillMaxSize()){
//            Column {
//                chatLayout(false,"你好")
//                chatLayout(true,"你好")
//            }

            val isLoading by viewModel.isLoading.collectAsStateWithLifecycle()

            MyDialogLoding(isLoading)

            LazyColumn (
                modifier = Modifier.fillMaxWidth(),
                state = viewModel.liststate
            ) {
                items(items = viewModel.list){
                    chatLayout(item = it)
                }
            }


            Row (modifier = Modifier
                .fillMaxWidth()
                .background(White2F7)
                .align(Alignment.BottomStart)){

                TextField(
                    value = viewModel.contentm,
                    onValueChange = {
                        viewModel.updateContentm(it)
                    },
                    placeholder = {
                        Text("请输入内容")
                    },
                    modifier = Modifier.weight(1f)
                )
                Button(onClick = {
                    viewModel.send()
                }) {
                    Text(text = "发送")

                }
            }
        }
    }

}

@Composable
fun chatLayout(item: ChatModel){
    Row (modifier = Modifier.fillMaxWidth()){
        if(!item.isRight){
            Icon(
                imageVector = Icons.Filled.AccountCircle,
                contentDescription = null,
                modifier = Modifier
                    .size(54.dp)
                    .padding(bottom = 4.dp),
                tint = Purple80,
            )
        }


        Text(modifier = Modifier.weight(1f), text = item.text, style = TextStyle(textAlign = if(item.isRight)TextAlign.Right else TextAlign.Left))

        if(item.isRight){
            Icon(
                imageVector = Icons.Filled.AccountBox,
                contentDescription = null,
                modifier = Modifier
                    .size(54.dp)
                    .padding(bottom = 4.dp),
                tint = Purple80,
            )
        }
    }
}
