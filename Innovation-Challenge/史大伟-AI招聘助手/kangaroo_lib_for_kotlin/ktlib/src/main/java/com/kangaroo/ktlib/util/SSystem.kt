package com.kangaroo.ktlib.util

import android.Manifest
import android.app.Activity
import android.app.ActivityManager
import android.app.ActivityManager.RunningAppProcessInfo
import android.app.Service
import android.content.*
import android.content.pm.*
import android.net.Uri
import android.os.*
import android.provider.Settings
import android.text.TextUtils
import com.kangaroo.ktlib.app.tagToSysLogTag
import com.kangaroo.ktlib.util.encryption.MessageDigestUtils
import com.kangaroo.ktlib.util.log.ULog
import java.io.File
import java.util.*

/**
 * author : WaTaNaBe
 * e-mail : 297165331@qq.com
 * time : 2020/09/08
 * desc :
 */
object SSystem {

    /**
     * 获取cpu可用核心数目
     */
    fun cpuCore():Int{
        return Runtime.getRuntime().availableProcessors();
    }

    /**
     * 判断当前进程是否是主线程
     */
    fun isMainThread():Boolean{
        return Looper.getMainLooper() === Looper.myLooper()
    }

    /**
     * 判断当前进程是否是主进程
     * @param context
     * @return
     */
    fun inMainProcess(context: Context): Boolean {
        val packageName = context.packageName
        val processName = getProcessName(context)
        return packageName == processName
    }

    /**
     * 获取当前进程名
     * @param context
     * @return 进程名
     */
    private fun getProcessName(context: Context): String? {
        var processName: String? = null
        val am = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        for (info in am.runningAppProcesses) {
            if (info.pid == Process.myPid()) {
                processName = info.processName
                break
            }
        }
        return if (!TextUtils.isEmpty(processName)) {
            processName
        } else {
            null
        }
    }

    /**
     * 设备唯一值
     */
    // TODO: 2019/09/09 有些过时，后期改
    fun getUniqueId(): String  =
        MessageDigestUtils.md5(StringBuilder("35")
            .append(Build.CPU_ABI.length % 10)
            .append(Build.DEVICE.length % 10)
            .append(Build.DISPLAY.length % 10)
            .append(Build.HOST.length % 10)
            .append(Build.ID.length % 10)
            .append(Build.MANUFACTURER.length % 10)
            .append(Build.MODEL.length % 10)
            .append(Build.PRODUCT.length % 10)
            .append(Build.TAGS.length % 10)
            .append(Build.TYPE.length % 10)
            .append(Build.USER.length % 10).toString())

    /**
     * 安装应用
     *
     * @param context
     * @param file
     */
    fun installAPK(context: Context, file: File) {
        if (!file.exists()) {
            return
        }
        val intent = Intent()
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        intent.action = Intent.ACTION_VIEW
        intent.setDataAndType(
            Uri.fromFile(file),
            "application/vnd.android.package-archive"
        )
        context.startActivity(intent)
    }

    /**
     * 版本相关
     */
    private var versionCode: Long? = null

    private var versionName: String? = null

    private var appName: String? = null

    /**
     * 版本名
     * @return
     */
    fun getVersionName(context: Context): String? {
        return if (versionName == null) {
            getPackageInfo(context).versionName
        } else versionName
    }


    /**
     * 版本号
     * @return
     */
    fun getVersionCode(context: Context): Long? {
        if (versionCode == null) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                getPackageInfo(context).longVersionCode
            } else {
                getPackageInfo(context).versionCode.toLong()
            }
        }
        return versionCode
    }

    /**
     * 获取app名称
     * @return
     */
    fun getAppName(context: Context): String? {
        if (appName == null) {
            getPackageInfo(context)
        }
        return appName
    }


    /**
     * 获取版本信息
     * @return
     */
    private fun getPackageInfo(context: Context): PackageInfo {
        val pm: PackageManager = context.packageManager
        var pi = pm.getPackageInfo(context.packageName,
                PackageManager.GET_CONFIGURATIONS)
        versionCode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            pi.longVersionCode
        } else {
            pi.versionCode.toLong()
        }
        versionName = pi.versionName
        appName = context.applicationInfo.loadLabel(pm).toString()
        return pi
    }

    /**
     * ro.serialno的用处是来保存唯一设备号
     * @return
     */
    @Deprecated("不能通过反射进行api调用了，废弃")
    fun getOnlyId(): String {
        return getAndroidOsSystemProperties("ro.serialno")
    }

    /**
     *
     * @param key
     * @return
     */
    private fun getAndroidOsSystemProperties(key: String): String {
        val c = Class.forName("android.os.SystemProperties")
        val get = c.getMethod("get", String::class.java)
        return get.invoke(c, key) as String
    }

    fun getOsInfo(): String {
        return Build.VERSION.RELEASE
    }

    fun getPhoneModelWithManufacturer(): String {
        return Build.MANUFACTURER + " " + Build.MODEL
    }

    /**
     * 判断是否有sd卡，并可读写
     * @return
     */
    fun isSdcard(): Boolean = Environment.getExternalStorageState() == Environment.MEDIA_MOUNTED


    /**
     * 获取目录剩余空间
     * @param directoryPath
     * @return
     */
    fun getResidualSpace(directoryPath: String?): Long {
        val sf = StatFs(directoryPath)
        var blockSize:Long
        var availCount:Long

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR2) {
            blockSize = sf.blockSizeLong
            availCount = sf.availableBlocksLong
        }else{
            blockSize = sf.blockSize.toLong()
            availCount = sf.availableBlocks.toLong()
        }
        return availCount * blockSize
    }

    /**
     * 检查SD卡存储读写权限检查
     */
    fun checkSdcardPermission(context: Context): Boolean = PackageManager.PERMISSION_GRANTED == context.packageManager.checkPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE, context.applicationInfo.packageName)

    /**
     * 判断是否有这个软件包
     * @param packageName
     * @return
     */
    fun isInstallPackage(packageName: String): Boolean = File("/data/data/$packageName").exists()


    /**
     * 通过进程id获取包名
     * @param pID
     * @return
     */
    fun getAppName(context: Context,pID: Int): String? {
        var processName: String? = null
        val am = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val l: List<*> = am.runningAppProcesses
        val i = l.iterator()
        while (i.hasNext()) {
            val info = i.next() as RunningAppProcessInfo
            if (info.pid == pID) {
                processName = info.processName
                return processName
            }
        }
        return processName
    }

    fun getJavaClassName(clazz: Class<*>): String =  clazz.simpleName + ".java"

    fun getKotlinClassName(clazz: Class<*>): String =  clazz.simpleName + ".kt"


    /**
     * 检测手机是否Rooted
     *
     * @return
     */
    fun isRooted(context: Context): Boolean {
        val isSdk = isGoogleSdk(context)
        val tags: Any? = Build.TAGS
        if (!isSdk && tags != null
                && (tags as String).contains("test-keys")) {
            return true
        }
        if (File("/system/app/Superuser.apk").exists()) {
            return true
        }
        return !isSdk && File("/system/xbin/su").exists()
    }

    private fun isGoogleSdk(context: Context): Boolean {
        val str = Settings.Secure.getString(context
                .contentResolver, Settings.Secure.ANDROID_ID)
        return ("sdk" == Build.PRODUCT
                || "google_sdk" == Build.PRODUCT || str == null)
    }

    /**
     * 获取手机剩余电量
     *
     * @return
     */
    fun battery(context: Context): String {
        val filter= IntentFilter(Intent.ACTION_BATTERY_CHANGED)
        val intent: Intent? = context.registerReceiver(null, filter)
        return if(intent!=null){
            val level = intent.getIntExtra("level", -1)
            val scale = intent.getIntExtra("scale", -1)
            if (scale == -1) {
                "--"
            } else {
                String.format(Locale.US, "%d %%", level * 100 / scale)
            }
        } else{
            "--"
        }
    }

    /**
     * 打印内存信息
     */
    fun sysMemoryInfo(context: Context) {
        val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memInfo = ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memInfo)
        ULog.i("availMem:", "${memInfo.availMem/1024} kb", "\n",
                "threshold:", "${memInfo.threshold/1024} kb", "\n",
                "totalMem:${memInfo.totalMem / 1024 } kb", "\n",
                "lowMemory:${memInfo.lowMemory}", tag = tagToSysLogTag("system")
        )
    }


    /**
     * 获取手机当前可用内存
     * @return
     */
    fun getAvailMemory(context: Context): Long {
        val am = context
                .getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val mi = ActivityManager.MemoryInfo()
        am.getMemoryInfo(mi)
        return mi.availMem
    }


    /**
     * 获取Activity 的meta
     * @param activity
     * @param metaName
     * @return
     */
    fun getActivityMeta(activity: Activity, metaName: String): String? {
        return activity.packageManager
                .getActivityInfo(activity.componentName,
                        PackageManager.GET_META_DATA).metaData.getString(metaName)
    }

    /**
     * 获取Application 的meta
     * @param context
     * @param metaName
     * @return
     */
    fun getApplicationMeta(context: Context, metaName: String): String? {
        return context.packageManager
                .getApplicationInfo(context.packageName,
                        PackageManager.GET_META_DATA).metaData.getString(metaName)
    }

    /**
     * 获取Service 的meta
     * @param context
     * @param clazz
     * @param metaName
     * @return
     */
    fun getServiceMeta(context: Context, clazz: Class<Service>, metaName: String): String? {
        val cn = ComponentName(context, clazz)
        return  context.packageManager
                .getServiceInfo(cn, PackageManager.GET_META_DATA).metaData.getString(metaName)
    }

    /**
     * 获取Receiver 的meta
     * @param context
     * @param clazz
     * @param metaName
     * @return
     */
    fun getReceiverMeta(context: Context, clazz: Class<BroadcastReceiver>, metaName: String): String? {
        val cn = ComponentName(context, clazz)
        return context.packageManager
                .getReceiverInfo(cn,
                        PackageManager.GET_META_DATA).metaData.getString(metaName)
    }

}