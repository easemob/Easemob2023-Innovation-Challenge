package com.kangaroo.ktdemo.ui.page.main

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.core.view.WindowCompat
import com.kangaroo.ktdemo.app.KtDemoApplication
import com.kangaroo.ktdemo.ui.theme.TestoneTheme
import com.kangaroo.ktlib.util.launcher.LibActivityLauncher
import com.kangaroo.ktlib.util.log.ULog
import com.kangaroo.ktlib.util.store.UDataStore
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch


@AndroidEntryPoint
class MainActivity : ComponentActivity() {
    companion object{

        fun startFrom(activity: Activity) {
            LibActivityLauncher.instance
                .launch(activity, MainActivity::class.java)
        }
        fun startFromClearTask(activity: Activity) {
            LibActivityLauncher.instance.launch(
                activity,
                Intent(activity, MainActivity::class.java).apply {
                    addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                })


        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        WindowCompat.setDecorFitsSystemWindows(window, true)
        setContent {
            TestoneTheme {
                MainScreen()
            }
        }
    }
}
