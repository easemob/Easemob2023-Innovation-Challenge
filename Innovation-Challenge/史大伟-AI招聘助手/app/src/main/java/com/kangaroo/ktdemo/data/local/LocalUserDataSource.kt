package com.kangaroo.ktdemo.data.local

import com.kangaroo.ktdemo.data.model.Task
import com.kangaroo.ktdemo.data.model.local.LocalUser
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.flow.flow

/**
 * @author  SHI DA WEI
 * @date  2023/10/25 9:08
 */
class LocalUserDataSource(){

    private val list = mutableListOf(
        LocalUser("你好","你好是我",true,"1"),
        LocalUser("你好2","你好是我2",false,"2"),
        LocalUser("你好3","你好是我3",true,"3"),
        LocalUser("你好4","你好是我4",true,"4"))

    private lateinit var flow:Flow<List<LocalUser>>

    fun observeAll(): Flow<List<LocalUser>>{

        flow =  flow<List<LocalUser>> {

            delay(2000)
            emit(list)
        }
        return flow;
;    }

    fun deleteAll() {
        list.clear()
    }

    fun upsertAll(toLocal: List<LocalUser>) {
        list.addAll(toLocal)
    }

}