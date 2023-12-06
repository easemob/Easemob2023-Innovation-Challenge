package tech.baici.app.kchat


import android.app.Application
import android.content.Context
import kotlin.properties.Delegates


class App: Application() {

    companion object {

        var instance by Delegates.notNull<App>()

        fun applicationContext(): Context {
            return instance.applicationContext
        }
    }

    override fun onCreate() {
        instance = this
        super.onCreate()
    }

}