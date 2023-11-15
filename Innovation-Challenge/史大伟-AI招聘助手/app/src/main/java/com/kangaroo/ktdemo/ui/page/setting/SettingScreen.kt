package com.kangaroo.ktdemo.ui.page.setting

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
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import com.kangaroo.ktdemo.R
import com.kangaroo.ktdemo.ui.page.login.LoginViewModel
import com.kangaroo.ktdemo.ui.theme.PurpleGrey40
import com.kangaroo.ktdemo.ui.theme.White2F7
import com.kangaroo.ktdemo.widget.MyDialogLoding
import kotlinx.coroutines.launch

/**
 * @author  SHI DA WEI
 * @date  2023/11/15 10:05
 */

@SuppressLint("UnusedMaterial3ScaffoldPaddingParameter")
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SettingScreen(viewModel: SettingViewModel = hiltViewModel()) {
    Scaffold{

        Box(modifier = Modifier
            .fillMaxSize()
            .background(PurpleGrey40)){

            Button(colors = ButtonDefaults.buttonColors(containerColor = Color.Blue),modifier = Modifier.fillMaxWidth()
                .padding(start = 10.dp, end = 10.dp),onClick = {
                viewModel.logout()
            }) {
                Text(text = "退出")
            }
        }
    }
}