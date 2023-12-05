package com.kangaroo.ktlib.util.task

import android.app.Application
import com.kangaroo.ktlib.util.encryption.HEncryption


object TaskManager{

    lateinit var taskExecutor: TaskExecutor

    fun init(config: TaskConfig){
        taskExecutor = TaskExecutor(config,true);
    }

}