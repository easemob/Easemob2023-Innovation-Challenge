package com.kangaroo.ktlib.util.task

import androidx.annotation.IntDef
import java.lang.annotation.Retention
import java.lang.annotation.RetentionPolicy

class PRunnable(@Priority val priority: Int, val runnable: Runnable) :Runnable{
    companion object{
        /**
         * 线程队列方式 先进先出
         * @param r1
         * @param r2
         * @return
         */
        @JvmStatic
        fun compareFIFO(r1: PRunnable, r2: PRunnable): Int {
            val result = r1.priority - r2.priority
            return if (result == 0) r1.serial - r2.serial else result
        }

        /**
         * 线程队列方式 后进先出
         * @param r1
         * @param r2
         * @return
         */
        @JvmStatic
        fun compareLIFO(r1: PRunnable, r2: PRunnable): Int {
            val result = r1.priority - r2.priority
            return if (result == 0) r2.serial - r1.serial else result
        }
    }

    constructor(runnable: Runnable): this (NORMAL,runnable)

    var serial = 0

    override fun run() {
        runnable.run()
    }



}

const val HIGH = 1 //优先级高
const val NORMAL = 2 //优先级中等
const val  LOW = 3 //优先级低

@IntDef(HIGH, NORMAL, LOW)
@Retention(RetentionPolicy.SOURCE)
annotation class Priority
