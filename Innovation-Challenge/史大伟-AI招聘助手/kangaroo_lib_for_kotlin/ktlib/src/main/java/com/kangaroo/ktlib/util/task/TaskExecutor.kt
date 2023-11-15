package com.kangaroo.ktlib.util.task


import android.annotation.TargetApi
import com.kangaroo.ktlib.util.SSystem
import java.util.*
import java.util.concurrent.*
import java.util.concurrent.atomic.AtomicInteger

class TaskExecutor(var config: TaskConfig,startup:Boolean):Executor {


    val serial = AtomicInteger(0) //主要获取添加任务

    init {
        if(startup){
            startup()
        }
    }

    var service: ExecutorService? = null

    fun startup() {
        synchronized(this) {
            if (service != null && !service!!.isShutdown()) {
                return
            }
            service = createExecutor(config)
        }
    }

    private fun executeRunnable(runnable: PRunnable) {
        synchronized(this) {
            if (service == null || service!!.isShutdown) {
                return
            }
            runnable.serial = serial.getAndIncrement()
            service!!.execute(runnable)
        }
    }

    fun execute(runnable: Runnable, delayed: Long) {
        val timer = Timer()
        timer.schedule(object : TimerTask() {
            override fun run() {
                execute(runnable)
            }
        }, delayed)
    }

    override fun execute(command: Runnable) {
        if (command is PRunnable) {
            executeRunnable(command)
        } else {
            executeRunnable(PRunnable(command))
        }
    }

    fun execute(
        runnable: Runnable,
        @Priority priority: Int) {
        executeRunnable(PRunnable(priority, runnable))
    }

    private fun createExecutor(config: TaskConfig): ExecutorService? {
        val service =
            ThreadPoolExecutor(
                SSystem.cpuCore()+1,
                2*SSystem.cpuCore()+1,
                config.timeout,
                TimeUnit.MILLISECONDS,
                PriorityBlockingQueue(
                    config.queueInitCapacity,
                    if (config.fifo) mQueueFIFOComparator else mQueueLIFOComparator
                ),
                TaskThreadFactory(config.taskName),
                ThreadPoolExecutor.DiscardPolicy()
            )
        allowCoreThreadTimeOut(
            service,
            config.allowCoreTimeOut
        )
        return service
    }

    fun isBusy(): Boolean {
        synchronized(this) {
            if (service == null || service!!.isShutdown) {
                return false
            }
            if (service is ThreadPoolExecutor) {
                val tService =
                    service as ThreadPoolExecutor
                return tService.activeCount >= tService.corePoolSize
            }
            return false
        }
    }

    private fun allowCoreThreadTimeOut(
        service: ThreadPoolExecutor,
        value: Boolean
    ) {
        allowCoreThreadTimeOut9(service, value)
    }

    @TargetApi(9)
    private fun allowCoreThreadTimeOut9(
        service: ThreadPoolExecutor,
        value: Boolean
    ) {
        service.allowCoreThreadTimeOut(value)
    }

    private var mQueueFIFOComparator:Comparator<Runnable> = kotlin.Comparator { lhs, rhs ->
        if(lhs is PRunnable && rhs is PRunnable) PRunnable.compareFIFO(lhs,rhs) else 0
    }

    private var mQueueLIFOComparator: Comparator<Runnable> = kotlin.Comparator { lhs, rhs ->
        if(lhs is PRunnable && rhs is PRunnable) PRunnable.compareLIFO(lhs,rhs) else 0
    }

    fun shutdown() {
        var executor: ExecutorService? = null
        synchronized(this) {
            // 交换变量
            if (service != null) {
                executor = service
                service = null
            }
        }
        if (executor != null) {
            // 停止线程
            if (!executor!!.isShutdown) {
                executor!!.shutdown()
            }

            // 回收变量
            executor = null
        }
    }



}