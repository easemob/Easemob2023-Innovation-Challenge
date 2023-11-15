/*
 * Copyright 2022 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.kangaroo.ktdemo.ui.page.user

import android.app.Activity
import android.content.Intent
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AccountCircle
import androidx.compose.material3.Button
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.kangaroo.ktdemo.ui.page.chat.ChatActivity
import com.kangaroo.ktdemo.ui.page.home.DateStoreActivity
import com.kangaroo.ktdemo.ui.page.test.TestActivity
import com.kangaroo.ktdemo.ui.theme.Purple80
import com.kangaroo.ktdemo.ui.theme.TestoneTheme
import com.kangaroo.ktdemo.ui.theme.blueEFD

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun UserScreen(
    modifier: Modifier = Modifier,
    viewModel: UserViewModel = hiltViewModel(),
) {
    var activity = LocalContext.current as Activity
    Scaffold(
//        scaffoldState = scaffoldState,
//        topBar = { StatisticsTopAppBar(openDrawer) }
    ) { paddingValues ->
//        val uiState by viewModel.uiState.collectAsStateWithLifecycle()

//        StatisticsContent(
//            loading = uiState.isLoading,
//            empty = uiState.isEmpty,
//            activeTasksPercent = uiState.activeTasksPercent,
//            completedTasksPercent = uiState.completedTasksPercent,
//            onRefresh = { viewModel.refresh() },
//            modifier = modifier.padding(paddingValues)
//        )
        Row (modifier = modifier.fillMaxWidth().padding(paddingValues).background(blueEFD).clickable {
            ChatActivity.startFrom(activity)
        }){
            Icon(
                imageVector = Icons.Filled.AccountCircle,
                contentDescription = null,
                modifier = Modifier
                    .size(54.dp)
                    .padding(bottom = 4.dp),
                tint = Purple80,
            )
            Spacer(modifier = Modifier.width(10.dp))
            Column {
                Text(text = "智能招聘助手")
                Text(text = "点击交谈")
            }
        }
    }
}

@Composable
private fun StatisticsContent(
    loading: Boolean,
    empty: Boolean,
    activeTasksPercent: Float,
    completedTasksPercent: Float,
    onRefresh: () -> Unit,
    modifier: Modifier = Modifier
) {
    var context = LocalContext.current
    Column(modifier.fillMaxWidth()) {
        Text(text = loading.toString())
        Text(text = empty.toString())
        Text(text = activeTasksPercent.toString())
        Text(text = completedTasksPercent.toString())
        Button(onClick = {
            onRefresh.invoke()
            var intent = Intent(context,TestActivity::class.java)
            context.startActivity(intent)
        }) {
            Text(text = "刷新")
        }
        Button(onClick = {
            onRefresh.invoke()
            var intent = Intent(context,DateStoreActivity::class.java)
            context.startActivity(intent)
        }) {
            Text(text = "跳转")
        }
    }
}

@Preview
@Composable
fun StatisticsContentPreview() {
    TestoneTheme {
        Surface {
            StatisticsContent(
                loading = false,
                empty = false,
                activeTasksPercent = 80f,
                completedTasksPercent = 20f,
                onRefresh = { }
            )
        }
    }
}

@Preview
@Composable
fun StatisticsContentEmptyPreview() {
    TestoneTheme {
        Surface {
            StatisticsContent(
                loading = false,
                empty = true,
                activeTasksPercent = 0f,
                completedTasksPercent = 0f,
                onRefresh = { }
            )
        }
    }
}
