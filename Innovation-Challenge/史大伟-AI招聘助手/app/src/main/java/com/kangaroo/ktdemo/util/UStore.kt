package com.kangaroo.ktdemo.util

import android.content.Context
import android.util.Log
import androidx.datastore.core.DataStore
import androidx.datastore.dataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.preferencesDataStore
import com.kangaroo.ktdemo.app.KtDemoApplication
import com.kangaroo.ktdemo.data.model.UserPreferences
import com.kangaroo.ktdemo.data.model.UserSerializer
import com.kangaroo.ktlib.app.init.sysContext
import com.kangaroo.ktlib.util.log.ULog
import com.kangaroo.ktlib.util.store.UDataStore
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.firstOrNull

/**
 * @author  SHI DA WEI
 * @date  2023/11/2 13:41
 */
const val USER:String = "user"
const val KT_DEMO:String = "kt_demo.pd"

val Context.userStore: DataStore<UserPreferences> by dataStore(fileName = KT_DEMO, serializer = UserSerializer)
object UStore {
    suspend fun putUser(user :(UserPreferences.Builder) -> Unit){
        sysContext.userStore.updateData { it ->
            it.toBuilder().let {innerIt ->
                user(innerIt)
                innerIt.build()
            }
        }
    }

    suspend fun getUser():UserPreferences = sysContext.userStore.data.first()

    suspend fun hasUser():Boolean = getUser().token.isNotEmpty()

    suspend fun clearUser(){
        sysContext.userStore.updateData {
            it.toBuilder().clear().build()
        }
    }
}
