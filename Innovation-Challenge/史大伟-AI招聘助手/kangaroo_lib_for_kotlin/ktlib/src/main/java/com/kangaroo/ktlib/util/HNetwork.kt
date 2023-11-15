package com.kangaroo.ktlib.util

import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkCapabilities

object HNetwork {

    /**
     * 获取可用的网络信息
     *
     * @return
     */
    private fun getActiveNetworkInfo(context: Context): NetworkCapabilities? {
        val cm = context
            .getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        return cm.getNetworkCapabilities(cm.activeNetwork)
    }

    /**
     */
    fun checkNetwork(context: Context): Boolean = getActiveNetworkInfo(context)!=null

    /**
     * 当前网络是否是wifi网络
     *
     * @return
     */
    fun isWifi(context: Context): Boolean {
        val activeNetInfo = getActiveNetworkInfo(context)
        return (activeNetInfo != null
                && activeNetInfo.hasTransport(NetworkCapabilities.TRANSPORT_WIFI))
    }

    /**
     * 判断当前网络是否是移动数据连接网络
     */
    fun isMobileNet(context: Context): Boolean {
        val activeNetInfo = getActiveNetworkInfo(context)
        return (activeNetInfo != null
                && activeNetInfo.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR))
    }

    /**
     * 判断当前网络是否是以太网
     */
    fun isEthernet(context: Context): Boolean {
        val activeNetInfo = getActiveNetworkInfo(context)
        return (activeNetInfo != null
                && activeNetInfo.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET))
    }


}