package com.kangaroo.ktdemo.widget

import android.app.Activity
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarColors
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.sp
import com.kangaroo.ktdemo.ui.theme.Purple40
import com.kangaroo.ktdemo.ui.theme.Purple80

/**
 * @author  SHI DA WEI
 * @date  2023/10/24 14:23
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TopBarWidget(title:String,back:Boolean = false) {
    var context = LocalContext.current
    TopAppBar(title = {
        Text(
            text = title,
            style = TextStyle(
                fontSize = 18.sp,
                fontWeight = FontWeight.Medium,
                color = Purple40
            )
        )
    }, colors = TopAppBarDefaults.centerAlignedTopAppBarColors(containerColor = Purple80),
        navigationIcon = {
            if(back){
                Icon(imageVector = Icons.Default.ArrowBack, contentDescription = null,modifier = Modifier.clickable {
                    (context as Activity).finish()
                })
            }
        })
}

@Preview(
    showBackground = true,
    widthDp = 375,
    heightDp = 50,
    backgroundColor = 0xFFFF5959
)
@Composable
fun PreviewTopBarWidgetLight() {
    TopBarWidget("")
}