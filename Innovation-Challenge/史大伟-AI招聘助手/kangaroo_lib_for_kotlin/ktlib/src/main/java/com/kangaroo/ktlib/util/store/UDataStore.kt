package com.kangaroo.ktlib.util.store

import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.doublePreferencesKey
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.floatPreferencesKey
import androidx.datastore.preferences.core.intPreferencesKey
import androidx.datastore.preferences.core.longPreferencesKey
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.core.stringSetPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.runBlocking
import kotlin.reflect.KClass

/**
 * @author  SHI DA WEI
 * @date  2023/10/26 14:29
 */
class UDataStore constructor(val dataStore: DataStore<Preferences>) {

    inline fun <reified T> getData(key: String, defaultValue: T?): Flow<T?> {
        val keyValue = getKey<T>(key)
        return dataStore.data.map { map ->
            map[keyValue] ?: defaultValue
        }
    }

    suspend inline fun <reified T> putData(key: String, value: T) {
        val keyValue = getKey<T>(key)
        dataStore.edit { map ->
            map[keyValue] = value
        }
    }



    suspend fun putAllData(vararg pairs: Preferences.Pair<*>) {
        dataStore.edit { map ->
            map.putAll(*pairs)
        }
    }

    inline fun <reified T> getKey(key: String): Preferences.Key<T> {

        return when (T::class) {
            Int::class -> intPreferencesKey(key) as Preferences.Key<T>
            Long::class -> longPreferencesKey(key) as Preferences.Key<T>
            String::class -> stringPreferencesKey(key) as Preferences.Key<T>
            Boolean::class ->  booleanPreferencesKey(key) as Preferences.Key<T>
            Float::class -> floatPreferencesKey(key) as Preferences.Key<T>
            Double::class -> doublePreferencesKey(key) as Preferences.Key<T>
            Set::class -> stringSetPreferencesKey(key) as Preferences.Key<T>
            else -> throw IllegalArgumentException("This type cannot be saved to the Data Store")
        }
    }

    suspend fun clearData() =  dataStore.edit { it.clear() }

    suspend inline fun <reified T> remove(key: String) {
        val keyValue = getKey<T>(key)
        dataStore.edit { it ->
            it.remove(keyValue)
        }
    }

    suspend inline fun <reified T> contains(key: String): Boolean{
        val keyValue = getKey<T>(key)
        return dataStore.data.map { it.contains(keyValue) }.first()
    }

}