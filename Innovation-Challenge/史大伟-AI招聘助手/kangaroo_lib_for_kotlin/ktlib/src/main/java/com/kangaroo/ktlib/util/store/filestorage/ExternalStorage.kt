package com.kangaroo.ktlib.util.store.filestorage

import android.content.Context
import android.os.Environment
import android.text.TextUtils
import com.kangaroo.ktlib.app.tagToSysLogTag
import com.kangaroo.ktlib.util.SSystem
import com.kangaroo.ktlib.util.log.ULog
import com.kangaroo.ktlib.util.store.file.AttachmentStore
import java.io.File

/** package  */
internal class ExternalStorage(val context: Context,var sdkStorageRoot: String?){

    /**
     * 屏蔽软件扫描
     */
    private val NO_MEDIA_FILE_NAME = ".nomedia"
    private var hasPermission = true // 是否拥有存储卡权限

    init {
        /**
         * 判断权限
         */
        hasPermission = SSystem.checkSdcardPermission(context)
        if (!TextUtils.isEmpty(sdkStorageRoot)) {
            val dir = File(sdkStorageRoot)
            if (!dir.exists()) {
                dir.mkdirs()
            }
            if (dir.exists() && !dir.isFile) {
                if (!sdkStorageRoot!!.endsWith("/")) {
                    sdkStorageRoot = "$sdkStorageRoot/"
                }
            }
        }
        if (TextUtils.isEmpty(sdkStorageRoot)) {
            loadStorageState()
        }
        createSubFolders()
    }

    private fun loadStorageState() {
        val externalRoot =
            context.getExternalFilesDir(null)?.path
        sdkStorageRoot = if(externalRoot!=null){
            externalRoot + "/Android/data/" + context.packageName + "/"
        }else{
            context.getFilesDir().path + "/Android/data/" + context.packageName + "/"
        }
    }

    /**
     * 构建基础文件夹
     */
    private fun createSubFolders() {
        var result = true
        val root = File(sdkStorageRoot)
        if (root.exists() && !root.isDirectory) {
            root.delete()
        }
        for (storageType in StorageType.values()) {
            result = result && makeDirectory(storageType)
        }
        if (result) {
            createNoMediaFile(sdkStorageRoot)
        }
    }

    fun makeDirectory(storageType: StorageType): Boolean {
        return AttachmentStore.makeDirectory(sdkStorageRoot + storageType.storageDirectoryName)
    }

    private fun createNoMediaFile(path: String?) {
        AttachmentStore.create("$path/$NO_MEDIA_FILE_NAME")
    }

    /**
     * 文件全名转绝对路径（写）
     *
     * @param fileName
     * 文件全名（文件名.扩展名）
     * @return 返回绝对路径信息
     */
    fun getWritePath(fileName: String, fileType: StorageType): String {
        return pathForName(fileName, fileType, false, false)
    }

    private fun pathForName(
        fileName: String, type: StorageType, dir: Boolean,
        check: Boolean
    ): String {
        val directory = getDirectoryByDirType(type)
        val path = StringBuilder(directory)
        if (!dir) {
            path.append(fileName)
        }
        val pathString = path.toString()
        val file = File(pathString)
        return if (check) {
            if (file.exists()) {
                if (dir && file.isDirectory
                    || !dir && !file.isDirectory
                ) {
                    return pathString
                }
            }
            ""
        } else {
            pathString
        }
    }

    /**
     * 返回指定类型的文件夹路径
     *
     * @param fileType
     * @return
     */
    fun getDirectoryByDirType(fileType: StorageType): String {
        return sdkStorageRoot + fileType.storageDirectoryName
    }

    /**
     * 根据输入的文件名和类型，找到该文件的全路径。
     * @param fileName
     * @param fileType
     * @return 如果存在该文件，返回路径，否则返回空
     */
    fun getReadPath(fileName: String, fileType: StorageType) = if (fileName.isEmpty()) "" else pathForName(fileName, fileType, false, true)

    /**
     * 判断sd卡是否在状态，可用
     * @return
     */
    fun isSdkStorageReady(): Boolean{
        val externalRoot =
            context.getExternalFilesDir(null)?.absolutePath
        return if(externalRoot!=null){
            if (sdkStorageRoot!!.startsWith(externalRoot)) {
                Environment.getExternalStorageState() == Environment.MEDIA_MOUNTED
            } else {
                true
            }
        }else{
            false
        }
    }

    /**
     * 获取存储路径剩余空间
     * @return
     */
    val availableExternalSize: Long
        get() = SSystem.getResidualSpace(sdkStorageRoot)

    /**
     * 有效性检查
     */
    fun checkStorageValid(): Boolean {
        if (hasPermission) {
            return true // M以下版本&授权过的M版本不需要检查
        }
        hasPermission = SSystem.checkSdcardPermission(context) // 检查是否已经获取权限了
        if (hasPermission) {
            ULog.i("get permission to access storage",tag = tagToSysLogTag("storage"))
            // 已经重新获得权限，那么重新检查一遍初始化过程
            createSubFolders()
        }
        return hasPermission
    }
}