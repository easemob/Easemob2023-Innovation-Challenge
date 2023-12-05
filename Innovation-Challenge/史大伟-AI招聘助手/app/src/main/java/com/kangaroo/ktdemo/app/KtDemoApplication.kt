package com.kangaroo.ktdemo.app

import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.preferencesDataStore
import com.hyphenate.chat.EMClient
import com.hyphenate.chat.EMOptions
import com.kangaroo.ktlib.app.KApplication
import com.kangaroo.ktlib.app.init.IInit
import dagger.hilt.android.HiltAndroidApp

@HiltAndroidApp
class KtDemoApplication : KApplication() {

    override fun appInit(): IInit {
        return AppInit(super.appInit())
    }
}