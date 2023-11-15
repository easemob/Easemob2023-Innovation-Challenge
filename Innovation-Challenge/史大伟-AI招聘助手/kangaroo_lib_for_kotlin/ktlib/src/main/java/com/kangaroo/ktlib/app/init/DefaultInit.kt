package com.kangaroo.ktlib.app.init

import android.app.Application
import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.preferencesDataStore
import com.kangaroo.ktlib.app.SConfiger
import com.kangaroo.ktlib.util.encryption.HEncryption
import com.kangaroo.ktlib.util.store.UDataStore
import com.kangaroo.ktlib.util.store.filestorage.UStorage
import com.kangaroo.ktlib.util.task.TaskConfig
import com.kangaroo.ktlib.util.task.TaskManager
import kotlin.properties.Delegates

/**
 * author : WaTaNaBe
 * e-mail : 297165331@qq.com
 * time : 2020/09/08
 * desc :
 */
var sConfiger  by Delegates.notNull<SConfiger>()
var sysContext : Application by Delegates.notNull<Application>()
val Context.sysStore: DataStore<Preferences> by preferencesDataStore(name = "SYS_SHAREDPREFERENCES")
val sysDataStore: UDataStore by lazy {
    UDataStore(sysContext.sysStore)
}

class DefaultInit(
    private val sContext : Application, private val configer:SConfiger = SConfiger(), private val appSafeCode : String = "DEFAULT_123456789", private val storageRoot: String? = null,
    private val taskConfig:TaskConfig = TaskConfig.build {  }) :IInit{

    override fun init() {
        sConfiger = configer
        sysContext = sContext
        TaskManager.init(taskConfig)
        HEncryption.init(sContext,appSafeCode)
        UStorage.init(sContext,storageRoot)
    }
}