package com.kangaroo.ktlib.util.encryption

import android.app.Application
import android.util.Base64
import com.kangaroo.ktlib.util.SSystem
import com.kangaroo.ktlib.util.store.filestorage.ExternalStorage
import com.kangaroo.ktlib.util.store.filestorage.UStorage
import java.nio.charset.Charset
import java.security.NoSuchAlgorithmException
import java.security.SecureRandom
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.SecretKeySpec

/**
 * author : WaTaNaBe
 * e-mail : 297165331@qq.com
 * time : 2020/09/21
 * desc :
 */
object HEncryption {

    lateinit var mLibKey:ByteArray

    val mLibKeyString :String by lazy {
        String(mLibKey)
    }

    fun init(context: Application, safeCode: String? = null){
        mLibKey = generateLibKey(context,safeCode)
    }


    /**
     * 获取aes 128位key
     */
    private fun generateLibKey(context: Application,safeCode: String?): ByteArray {
        val size = 128 / 8
        val stringBuilder = StringBuilder()
        stringBuilder.append(SSystem.getUniqueId())
            .append(context.packageName)
            .append(safeCode)
        val libKey: String = MessageDigestUtils.md5(stringBuilder.toString())
        val result = libKey.toByteArray()
        val keyResult = ByteArray(size)
        for (i in 0 until size){
            keyResult[i] = result[i % result.size]
        }
        return keyResult
    }


    /**
     * 加密
     */
    fun libEncrypt(data: String): String {
        return String(data.toByteArray().encrypt("AES", mLibKey), charset("ISO-8859-1"))
    }

    /**
     * 解密
     */
    fun libDecrypt(safedata: String): String {
        return String(
            safedata.toByteArray(charset("ISO-8859-1")).decrypt("AES", mLibKey),
            Charset.defaultCharset()
        )
    }

    fun generateKey(algorithm: String, salt: String?, size: Int): ByteArray {
        var keyGen: KeyGenerator = KeyGenerator.getInstance(algorithm) // 秘钥生成器
        if (salt == null) {
            keyGen.init(size) // 初始秘钥生成器
        } else {
            keyGen.init(size, SecureRandom(salt.toByteArray())) // 初始秘钥生成器
        }
        val secretKey = keyGen.generateKey() // 生成秘钥
        return secretKey.encoded // 获取秘钥字节数组
    }

}


fun String.base64EncodeToUtf8(): String {
    return Base64.encodeToString(this.toByteArray(), Base64.DEFAULT)
}

fun String.Base64DecodeToUtf8(): String {
    return String(Base64.decode(this, Base64.DEFAULT), Charset.defaultCharset())
}

fun ByteArray.base64Encode(): String {
    return base64Encode(Base64.DEFAULT)
}

fun String.Base64Decode(): ByteArray {
    return Base64Decode(Base64.DEFAULT)
}

fun ByteArray.base64Encode(flags: Int): String {
    return Base64.encodeToString(this, flags)
}

fun String.Base64Decode(flags: Int): ByteArray {
    return Base64.decode(this, flags)
}

/**
 * 加密
 */
fun ByteArray.encrypt(algorithm: String, key: ByteArray): ByteArray {
    val secretKey: SecretKey = SecretKeySpec(key, algorithm) // 恢复秘钥
    var cipher: Cipher = Cipher.getInstance(algorithm) // 对Cipher完成加密或解密工作
    cipher.init(Cipher.ENCRYPT_MODE, secretKey) // 对Cipher初始化,加密模式
    return cipher.doFinal(this) // 加密数据
}

/**
 * 解密
 * @param data
 * @param key
 * @return
 */
fun ByteArray.decrypt(algorithm: String, key: ByteArray): ByteArray {
    val secretKey: SecretKey = SecretKeySpec(key, algorithm) // 恢复秘钥
    var cipher: Cipher = Cipher.getInstance(algorithm) // 对Cipher完成加密或解密工作
    cipher.init(Cipher.DECRYPT_MODE, secretKey) // 对Cipher初始化,加密模式
    return cipher.doFinal(this) // 解密数据
}