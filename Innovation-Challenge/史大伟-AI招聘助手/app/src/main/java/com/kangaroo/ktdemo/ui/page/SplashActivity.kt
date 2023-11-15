package com.kangaroo.ktdemo.ui.page

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.Favorite
import androidx.compose.material.icons.sharp.Face
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.TextUnit
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.core.view.WindowCompat
import androidx.lifecycle.lifecycleScope
import com.kangaroo.ktdemo.R
import com.kangaroo.ktdemo.ui.theme.Purple40
import com.kangaroo.ktdemo.ui.theme.Purple80
import com.kangaroo.ktdemo.ui.theme.TestoneTheme
import com.kangaroo.ktdemo.ui.theme.White2F7
import com.kangaroo.ktdemo.util.StateManager
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class SplashActivity : ComponentActivity() {


    override fun onResume() {
        super.onResume()
        lifecycleScope.launch {
            delay(1500)
            StateManager.init(this@SplashActivity)
            overridePendingTransition(0, 0)
            finish()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //全屏应用 在系统栏后布置应用
        WindowCompat.setDecorFitsSystemWindows(window, false)
        setContent {
            TestoneTheme {
                Box(modifier = Modifier.fillMaxSize().background(White2F7)){

                    Column(verticalArrangement = Arrangement.Center,
                        horizontalAlignment = Alignment.CenterHorizontally,
                        modifier = Modifier.align(Alignment.Center)) {
                            Icon(Icons.Sharp.Face, contentDescription = null, tint = Purple40,modifier = Modifier.size(100.dp).padding(10.dp))
                            Text(text = LocalContext.current.getString(R.string.app_name), fontSize = 25.sp, color = Purple80)
                    }
                }

            }
        }
    }
}