package com.kangaroo.ktlib.util.bus

import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.Observer
import java.lang.reflect.Field
import java.lang.reflect.Method

/**
 * @author  SHI DA WEI
 * @date  2023/10/31 9:41
 */
object LiveDataBus {

    //存放订阅者
    private val bus:MutableMap<String,BusMutableLiveData<Any>> by lazy { HashMap() }

    // 暴露一个函数，给外界注册 订阅者关系
    @Synchronized
    fun <T>with(key:String,isStick:Boolean =false ):BusMutableLiveData<T>{
        if (!bus.containsKey(key)){
            bus[key]=BusMutableLiveData(isStick)
        }
        return bus[key]as BusMutableLiveData<T>
    }

    class BusMutableLiveData<T>private constructor(): MutableLiveData<T>() {
        private var isStick:Boolean=false
        //主构造私有化，必须写次构造，次构造必须调用主构造
        constructor(isStick: Boolean):this(){
            this.isStick=isStick
        }

        override fun observe(owner: LifecycleOwner, observer: Observer<in T>) {
            super.observe(owner, observer)

            if (!isStick) {
                hook(observer = observer)
            }
        }
        private fun hook(observer: Observer<in T>){
            // 获取到LivData的类中的mObservers对象
            val liveDataClass:Class<LiveData<*>> =LiveData::class.java

            val mObserversField: Field = liveDataClass.getDeclaredField("mObservers")
            mObserversField.isAccessible=true// 私有修饰也可以访问

            // 获取到这个成员变量的对象  Any == Object
            val mObserversObject: Any = mObserversField.get(this)

            // 得到map对象的class对象   private SafeIterableMap<Observer<? super T>, ObserverWrapper> mObservers =
            val mObserversClass: Class<*> = mObserversObject.javaClass

            // 获取到mObservers对象的get方法   protected Entry<K, V> get(K k) {
            val get: Method = mObserversClass.getDeclaredMethod("get", Any::class.java)
            get.isAccessible = true // 私有修饰也可以访问

            //执行get方法
            val invokeEntry: Any = get.invoke(mObserversObject, observer)

            // 取到entry中的value   is "AAA" is String    is是判断类型 as是转换类型
            var observerWraper: Any? = null
            if (invokeEntry!=null&&invokeEntry is Map.Entry<*,*>){
                observerWraper=invokeEntry.value
            }
            if (observerWraper == null) {
                throw NullPointerException("observerWraper is null")
            }

            // 得到observerWraperr的类对象
            val supperClass: Class<*> = observerWraper.javaClass.superclass
            val mLastVersion: Field = supperClass.getDeclaredField("mLastVersion")
            mLastVersion.isAccessible = true

            val mVersion: Field = liveDataClass.getDeclaredField("mVersion")
            mVersion.isAccessible = true

            val mVersionValue: Any = mVersion.get(this)
            mLastVersion.set(observerWraper, mVersionValue)
        }
    }

}