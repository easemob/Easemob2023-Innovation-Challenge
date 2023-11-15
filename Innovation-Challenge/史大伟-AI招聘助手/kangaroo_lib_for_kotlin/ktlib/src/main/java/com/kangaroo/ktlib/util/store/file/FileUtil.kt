package com.kangaroo.ktlib.util.store.file

import android.text.TextUtils
import android.webkit.MimeTypeMap
import com.kangaroo.ktlib.app.tagToSysLogTag
import com.kangaroo.ktlib.util.log.ULog
import java.io.File
import java.math.BigDecimal
import java.util.*

/**
 * 文件基本操作
 */
object FileUtil {

    /**
     * 判断是否有后缀
     * @param filename
     * @return
     */
    fun hasExtentsion(filename: String)= getExtensionName(filename).isNotEmpty()

    /**
     * 获取文件扩展名
     * @param filename
     * @return
     */
    fun getExtensionName(filename: String): String {
        if (filename.isNotEmpty()) {
            val dot = filename.lastIndexOf('.')
            if (dot > -1 && dot < filename.length - 1) {
                return filename.substring(dot + 1)
            }
        }
        return ""
    }

    /**
     * 获取文件名
     * @param filepath
     * @return
     */
    fun getFileNameFromPath(filepath: String): String {
        if (!TextUtils.isEmpty(filepath)) {
            val sep = filepath.lastIndexOf('/')
            if (sep > -1 && sep < filepath.length - 1) {
                return filepath.substring(sep + 1)
            }
        }
        return filepath
    }

    /**
     * 获取不带扩展名的文件名
     * @param filename
     * @return
     */
    fun getFileNameNoEx(filename: String): String {
        if (!TextUtils.isEmpty(filename)) {
            val dot = filename.lastIndexOf('.')
            if (dot > -1 && dot < filename.length) {
                return filename.substring(0, dot)
            }
        }
        return filename
    }

    /**
     * 获取MimeType
     * @param filePath
     * @return
     */
    fun getMimeType(filePath: String): String? {
        if (filePath.isEmpty()) {
            return ""
        }
        var type: String? = null
        val extension =
            getExtensionName(filePath.toLowerCase(Locale.getDefault()))
        if (extension.isNotEmpty()) {
            val mime = MimeTypeMap.getSingleton()
            type = mime.getMimeTypeFromExtension(extension)
        }
        ULog.i("url:", filePath, " ", "type:", type, tag = tagToSysLogTag("file"))
        if (TextUtils.isEmpty(type)) {
            if (filePath.endsWith("aac")) {
                type = "audio/aac"
            } else {
                val ext: String? = FileType.getFileType(filePath)
                if (ext !=null) {
                    val mime = MimeTypeMap.getSingleton()
                    type = mime.getMimeTypeFromExtension(ext)
                }
            }
        }
        return type
    }

    /**
     * 获取文件
     * Context.getExternalFilesDir() --> SDCard/Android/data/你的应用的包名/files/
     * 目录，一般放一些长时间保存的数据
     * Context.getExternalCacheDir() -->
     * SDCard/Android/data/你的应用包名/cache/目录，一般存放临时缓存数据
     * @param file
     * @return
     */
    fun getFolderSize(file: File): Long {
        var size: Long = 0
        val fileList = file.listFiles()
        if(fileList!=null){
            for (i in fileList.indices) {
                // 如果下面还有文件
                size = if (fileList[i].isDirectory) {
                    size + getFolderSize(fileList[i])
                } else {
                    size + fileList[i].length()
                }
            }
        }
        return size
    }

    /**
     * 格式化单位，获取文件大小
     *
     * @param size
     * @return
     */
    fun getFormatSize(size: Double): String {
        val kiloByte = size / 1024
        val megaByte = kiloByte / 1024
        if (megaByte < 1) {
            val result1 =
                BigDecimal(kiloByte.toString())
            return result1.setScale(2, BigDecimal.ROUND_HALF_UP).toPlainString() + "KB"
        }
        val gigaByte = megaByte / 1024
        if (gigaByte < 1) {
            val result2 =
                BigDecimal(megaByte.toString())
            return result2.setScale(2, BigDecimal.ROUND_HALF_UP).toPlainString() + "MB"
        }
        val teraBytes = gigaByte / 1024
        if (teraBytes < 1) {
            val result3 =
                BigDecimal(gigaByte.toString())
            return result3.setScale(2, BigDecimal.ROUND_HALF_UP).toPlainString() + "GB"
        }
        val result4 = BigDecimal(teraBytes)
        return result4.setScale(2, BigDecimal.ROUND_HALF_UP).toPlainString() + "TB"
    }

    /**
     * 获得文件字节大小
     * @param srcPath
     * @return
     */
    fun getFileLength(srcPath: String): Long {
        if(srcPath.isEmpty()) return -1
        val srcFile = File(srcPath)
        return if (!srcFile.exists()) {
            -1
        } else srcFile.length()
    }

    /**
     * 文件是否存在
     * @param path
     * @return
     */
    fun isFileExist(path: String) = path.isNotEmpty() && File(path).exists()
}