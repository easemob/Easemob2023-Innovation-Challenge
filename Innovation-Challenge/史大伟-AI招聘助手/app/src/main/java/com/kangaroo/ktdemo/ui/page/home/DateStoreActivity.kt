package com.kangaroo.ktdemo.ui.page.home

import android.content.Context
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.preferencesDataStore
import com.kangaroo.ktdemo.app.KtDemoApplication
import com.kangaroo.ktdemo.ui.theme.TestoneTheme
import com.kangaroo.ktlib.util.log.ULog
import com.kangaroo.ktlib.util.store.UDataStore
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch

class DateStoreActivity : ComponentActivity() {
    val Context.dataStore: DataStore<Preferences> by preferencesDataStore(name = "Study")

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        CoroutineScope(Dispatchers.Main).launch{
            val ustore = UDataStore((applicationContext as KtDemoApplication).dataStore)
            ustore.putData<String>("123","123")
            var m = ustore.getData<String>("123",null).first()
            ULog.d("结果",m)
            var m2 = ustore.getData<String>("1234",null).first()
            ULog.d("结果",m2)

            var m3 = ustore.contains<String>("123")
            ULog.d("结果",m3)
            var m4 = ustore.contains<String>("1234")
            ULog.d("结果",m4)

            ustore.remove<String>("123")

            var m6 = ustore.contains<String>("123")
            ULog.d("结果",m6)

            ustore.putData<String>("1234","1234")

            var m7 = ustore.contains<String>("1234")
            ULog.d("结果",m7)

            ustore.clearData()

            var m8 = ustore.contains<String>("1234")
            ULog.d("结果",m8)
        }
        setContent {
            TestoneTheme {
                // A surface container using the 'background' color from the theme
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    Greeting3("Android")
                }
            }
        }
    }
}

@Composable
fun Greeting3(name: String, modifier: Modifier = Modifier) {
    Text(
        text = "Hello $name!",
        modifier = modifier
    )
}

@Preview(showBackground = true)
@Composable
fun GreetingPreview3() {
    TestoneTheme {
        Greeting3("Android")
    }
}