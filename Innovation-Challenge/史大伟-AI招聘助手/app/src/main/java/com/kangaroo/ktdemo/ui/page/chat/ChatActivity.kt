package com.kangaroo.ktdemo.ui.page.chat

import android.app.Activity
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.core.view.WindowCompat
import com.kangaroo.ktdemo.R
import com.kangaroo.ktdemo.ui.page.login.LoginActivity
import com.kangaroo.ktdemo.ui.page.login.LoginScreen
import com.kangaroo.ktdemo.ui.theme.TestoneTheme
import com.kangaroo.ktlib.util.launcher.LibActivityLauncher
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class ChatActivity : ComponentActivity() {

    companion object{

        fun startFrom(activity: Activity) {
            LibActivityLauncher.instance
                .launch(activity, ChatActivity::class.java)
        }

    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //全屏应用 在系统栏后布置应用
        WindowCompat.setDecorFitsSystemWindows(window, false)
        setContent {
            TestoneTheme {
                ChatScreen()
            }
        }
    }
}