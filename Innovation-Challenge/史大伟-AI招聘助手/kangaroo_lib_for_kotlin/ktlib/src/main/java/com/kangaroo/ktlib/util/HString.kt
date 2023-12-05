package com.kangaroo.ktlib.util

import android.text.TextUtils
import org.json.JSONArray
import org.json.JSONObject
import java.io.StringReader
import java.io.StringWriter
import java.util.*
import javax.xml.transform.OutputKeys
import javax.xml.transform.Source
import javax.xml.transform.TransformerFactory
import javax.xml.transform.stream.StreamResult
import javax.xml.transform.stream.StreamSource

/**
 * author : WaTaNaBe
 * e-mail : 297165331@qq.com
 * time : 2020/09/17
 * desc :String 扩展
 */
object HString{
    fun concatObject(splt: String?, vararg args: Any?) : String{
        var sp = splt
        if(splt==null){
            sp = ""
        }
        if(args.isEmpty()){
            return ""
        }
        val ret = StringBuilder()

        args.forEach {
            if(it==null){
                ret.append("null").append(sp)
            }else{
                ret.append(it.toString()).append(sp)
            }
        }

        var result = ret.toString()
        return result.substring(0, result.length - sp!!.length);
    }

    fun getStringValue(any: Any?):String{
        return any.toString()
    }

    fun to32UUID():String{
        return UUID.randomUUID().toString().replace("-", "")
    }

    fun to36UUID():String{
        return UUID.randomUUID().toString()
    }

    /**
     * 数字变为百分比
     */
    fun percentString(percent: Float):String{
        return String.format(Locale.US, "%d%%", (percent * 100).toInt())
    }

    /**
     * 删除字符串中的空白符,换行符,tab
     */
    fun removeBlanks(content: String?):String?{
        if(content==null)
            return null
        else{
            val buff = StringBuilder(content)
            for((i, chars) in content.reversed().withIndex()){
                if (' ' == chars || ('\n' == chars) || ('\t' == chars)
                    || ('\r' == chars)) {
                    buff.deleteCharAt(i)
                }
            }
            return buff.toString()
        }
    }

    /**
     * counter ASCII character as one, otherwise two
     *
     * @param str
     * @return count
     */
    fun counterChars(str: String): Int {
        // return
        if (TextUtils.isEmpty(str)) {
            return 0
        }
        var count = 0
        for (i in 0 until str.length) {
            val tmp = str[i].toInt()
            count += if (tmp > 0 && tmp < 127) {
                1
            } else {
                2
            }
        }
        return count
    }

    /**
     * 获取get请求网络字符串
     */
    fun getNetString(map: Map<String, String?>):String?{
        val param = StringBuilder("")
        map.forEach{
            if(it.value==null){
                return@forEach
            }
            param.append(it.key).append('=').append(it.value).append('&')
        }
        return if(param.isNotEmpty()) param.substring(0, param.toString().length - 1) else null
    }

    /**
     * json 格式化
     *
     * @param json
     * @return
     */
    fun jsonFormat(json: String): String? {
        var json = json
        if (TextUtils.isEmpty(json)) {
            return null
        }
        json = json.trim { it <= ' ' }
        return when {
            json.startsWith("{") -> {
                val jsonObject = JSONObject(json)
                jsonObject.toString(4)
            }
            json.startsWith("[") -> {
                val jsonArray = JSONArray(json)
                jsonArray.toString(4)
            }
            else -> {
                json
            }
        }
    }

    /**
     * xml 格式化
     *
     * @param xml
     * @return
     */
    fun xmlFormat(xml: String): String? {
        if (TextUtils.isEmpty(xml)) {
            return null
        }
        val xmlInput: Source =
            StreamSource(StringReader(xml))
        val xmlOutput =
            StreamResult(StringWriter())
        val transformer =
            TransformerFactory.newInstance().newTransformer()
        transformer.setOutputProperty(OutputKeys.INDENT, "yes")
        transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2")
        transformer.transform(xmlInput, xmlOutput)
        return xmlOutput.writer.toString().replaceFirst(">".toRegex(), ">\n")
    }

}



