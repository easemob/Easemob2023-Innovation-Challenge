package com.kangaroo.ktdemo.ui.page.login

import android.app.Activity
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.sharp.Face
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.material3.surfaceColorAtElevation
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.modifier.modifierLocalConsumer
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.core.view.WindowCompat
import androidx.hilt.navigation.compose.hiltViewModel
import com.kangaroo.ktdemo.R
import com.kangaroo.ktdemo.ui.theme.Purple40
import com.kangaroo.ktdemo.ui.theme.Purple80
import com.kangaroo.ktdemo.ui.theme.PurpleGrey40
import com.kangaroo.ktdemo.ui.theme.TestoneTheme
import com.kangaroo.ktdemo.ui.theme.White2F7
import com.kangaroo.ktlib.util.launcher.LibActivityLauncher
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class LoginActivity : ComponentActivity() {
    companion object{

        fun startFrom(activity: Activity) {
            LibActivityLauncher.instance
                .launch(activity, LoginActivity::class.java)
        }

        fun startFromClearTop(activity: Activity) {
            LibActivityLauncher.instance.launch(
                activity,
                Intent(activity, LoginActivity::class.java).apply {
                    addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                })

        }

    }
    @OptIn(ExperimentalMaterial3Api::class)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //全屏应用 在系统栏后布置应用
        WindowCompat.setDecorFitsSystemWindows(window, false)
        setContent {
            TestoneTheme {
                LoginScreen()
            }
        }
    }
}