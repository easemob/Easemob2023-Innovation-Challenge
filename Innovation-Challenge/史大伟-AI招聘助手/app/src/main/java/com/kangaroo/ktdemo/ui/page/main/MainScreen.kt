package com.kangaroo.ktdemo.ui.page.main

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AccountCircle
import androidx.compose.material.icons.filled.AddCircle
import androidx.compose.material.icons.filled.Call
import androidx.compose.material.icons.filled.DateRange
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import com.kangaroo.ktdemo.ui.theme.TestoneTheme
import com.kangaroo.ktdemo.widget.BottomBarWidget
import com.kangaroo.ktdemo.widget.BottomItem
import androidx.compose.runtime.*
import androidx.compose.ui.platform.LocalContext
import com.kangaroo.ktdemo.R
import com.kangaroo.ktdemo.ui.page.setting.SettingScreen
import com.kangaroo.ktdemo.ui.page.user.UserScreen
import com.kangaroo.ktdemo.widget.TopBarWidget

val mBottomTabItems =
    listOf(
        BottomItem("聊天列表", Icons.Filled.AccountCircle),
        BottomItem("设置", Icons.Filled.AddCircle),
    )

/**
 * @author  SHI DA WEI
 * @date  2023/10/24 9:25
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MainScreen(){
    Surface(
        modifier = Modifier.fillMaxSize(),
        color = MaterialTheme.colorScheme.background
    ) {
        var bottomSelectedState by remember { mutableStateOf(0) }
        Scaffold(
            topBar = {TopBarWidget(title = LocalContext.current.getString(R.string.app_name))},
            bottomBar = {
                BottomBarWidget(bottomSelectedState, mBottomTabItems) {
                    bottomSelectedState = it
                }
            }
        ){paddingValues->
            Box (Modifier.padding(paddingValues)){
//                Greeting("Android")
                when (bottomSelectedState) {
                    0 -> UserScreen()
//                    1 -> Text("这是${mBottomTabItems[bottomSelectedState].label}")
                    1 -> SettingScreen()
                }
            }
        }

    }
}



@Composable
fun Greeting(name: String, modifier: Modifier = Modifier) {
    Text(
        text = "Hello $name!",
        modifier = modifier
    )
}

@Preview(showBackground = true)
@Composable
fun GreetingPreview() {
    TestoneTheme {
        Greeting("Android")
    }
}