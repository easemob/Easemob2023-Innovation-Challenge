package com.kangaroo.ktlib.util.okhttp

import com.kangaroo.ktlib.R
import com.kangaroo.ktlib.app.init.sysContext
import com.kangaroo.ktlib.app.tagToSysLogTag
import com.kangaroo.ktlib.util.json.HJson
import com.kangaroo.ktlib.util.log.ULog
import okhttp3.Headers
import okhttp3.Interceptor
import okhttp3.Response
import okhttp3.internal.http.promisesBody
import okhttp3.internal.platform.Platform
import okio.Buffer
import okio.GzipSource
import java.io.EOFException
import java.io.IOException
import java.nio.charset.Charset
import java.nio.charset.StandardCharsets
import java.util.TreeSet
import java.util.concurrent.TimeUnit

/**
 * @author  SHI DA WEI
 * @date  2023/10/30 14:40
 */
class LibLogInterceptor : Interceptor {

    val tag = "LibLogInterceptor"

    @Throws(IOException::class)
    override fun intercept(chain: Interceptor.Chain): Response {
        val request = chain.request()
        val requestBody = request.body

        val connection = chain.connection()
        var requestStartMessage =
            ("${sysContext.getString(R.string.libNetSend)} \n${request.method} ${request.url}${if (connection != null) " " + connection.protocol() else ""}")
        if (requestBody != null) {
            requestStartMessage += " (${requestBody.contentLength()}-byte body)\n"
        }
        val headers = request.headers

        if (requestBody != null) {
            // Request body headers are only present when installed as a network interceptor. When not
            // already present, force them to be included (if available) so their values are known.
            requestBody.contentType()?.let {
                if (headers["Content-Type"] == null) {
                    requestStartMessage += "Content-Type: $it\n"
                }
            }
            if (requestBody.contentLength() != -1L) {
                if (headers["Content-Length"] == null) {
                    requestStartMessage += "Content-Length: ${requestBody.contentLength()}\n"
                }
            }
        }

        for (i in 0 until headers.size) {
            requestStartMessage += "${headers.name(i)} : ${headers.value(i)}\n"
        }

        if (requestBody == null) {
            requestStartMessage += "${request.method}"
            ULog.d(requestStartMessage,tag = tagToSysLogTag(tag))
        } else if (bodyHasUnknownEncoding(request.headers)) {
            requestStartMessage += "${request.method} (encoded body omitted)"
            ULog.d(requestStartMessage,tag = tagToSysLogTag(tag))
        } else if (requestBody.isDuplex()) {
            requestStartMessage += "${request.method} (duplex request body omitted)"
            ULog.d(requestStartMessage,tag = tagToSysLogTag(tag))
        } else if (requestBody.isOneShot()) {
            requestStartMessage += "${request.method} (one-shot body omitted)"
            ULog.d(requestStartMessage,tag = tagToSysLogTag(tag))
        } else {
            val buffer = Buffer()
            requestBody.writeTo(buffer)

            val contentType = requestBody.contentType()
            val charset: Charset = contentType?.charset(StandardCharsets.UTF_8) ?: StandardCharsets.UTF_8

            if (buffer.isProbablyUtf8()) {
                val str = buffer.readString(charset)
                requestStartMessage += str+"\n"
                requestStartMessage += "${request.method} (${requestBody.contentLength()}-byte body)"
                ULog.d(requestStartMessage,tag = tagToSysLogTag(tag))
                try {
                    var any:Any? = HJson.fromJson(str, Any::class.java)
                    ULog.json(str,tag = tagToSysLogTag(tag))
                } catch (e: Exception) {

                }
            } else {
                requestStartMessage += "${request.method} (binary ${requestBody.contentLength()}-byte body omitted)"
                ULog.d(requestStartMessage,tag = tagToSysLogTag(tag))
            }
        }

        val startNs = System.nanoTime()
        val response: Response
        try {
            response = chain.proceed(request)
        } catch (e: Exception) {
            ULog.e("HTTP FAILED:", e.message,tag = tagToSysLogTag(tag), throwable = e)
            throw e
        }

        val tookMs = TimeUnit.NANOSECONDS.toMillis(System.nanoTime() - startNs)

        val responseBody = response.body!!
        val contentLength = responseBody.contentLength()
        val bodySize = if (contentLength != -1L) "$contentLength-byte" else "unknown-length"
        var responseMessage = "${sysContext.getString(R.string.libNetGet)} \n ${response.code}${if (response.message.isEmpty()) "" else ' ' + response.message} ${response.request.url} (${tookMs}ms${ ", $bodySize body"})\n"

        val responseheaders = response.headers
        for (i in 0 until responseheaders.size) {
            responseMessage += "${responseheaders.name(i)} : ${responseheaders.value(i)}\n"
        }

        if (!response.promisesBody()) {
            responseMessage +="END HTTP"
            ULog.d(responseMessage,tag = tagToSysLogTag(tag))
        } else if (bodyHasUnknownEncoding(response.headers)) {
            responseMessage +="END HTTP (encoded body omitted)"
            ULog.d(responseMessage,tag = tagToSysLogTag(tag))
        } else {
            val source = responseBody.source()
            source.request(Long.MAX_VALUE) // Buffer the entire body.
            var buffer = source.buffer

            var gzippedLength: Long? = null
            if ("gzip".equals(responseheaders["Content-Encoding"], ignoreCase = true)) {
                gzippedLength = buffer.size
                GzipSource(buffer.clone()).use { gzippedResponseBody ->
                    buffer = Buffer()
                    buffer.writeAll(gzippedResponseBody)
                }
            }

            val contentType = responseBody.contentType()
            val charset: Charset = contentType?.charset(StandardCharsets.UTF_8) ?: StandardCharsets.UTF_8

            if (!buffer.isProbablyUtf8()) {
                responseMessage +="END HTTP (binary ${buffer.size}-byte body omitted)"
                ULog.d(responseMessage,tag = tagToSysLogTag(tag))
                return response
            }

            if (contentLength != 0L) {
                val str = buffer.clone().readString(charset)
                responseMessage += str+"\n"
                try {
                    var any:Any? = HJson.fromJson(str, Any::class.java)
                    ULog.json(str)
                } catch (e: Exception) {

                }
            }

            if (gzippedLength != null) {
                responseMessage += "END HTTP (${buffer.size}-byte, $gzippedLength-gzipped-byte body)"
                ULog.d(responseMessage,tag = tagToSysLogTag(tag))
            } else {
                responseMessage += "END HTTP (${buffer.size}-byte body)"
                ULog.d(responseMessage,tag = tagToSysLogTag(tag))
            }
        }
        return response
    }

    private fun bodyHasUnknownEncoding(headers: Headers): Boolean {
        val contentEncoding = headers["Content-Encoding"] ?: return false
        return !contentEncoding.equals("identity", ignoreCase = true) &&
                !contentEncoding.equals("gzip", ignoreCase = true)
    }
}

internal fun okio.Buffer.isProbablyUtf8(): kotlin.Boolean {
    return try {
        val prefix = Buffer()
        val byteCount = if (buffer.size < 64) buffer.size else 64
        buffer.copyTo(prefix, 0, byteCount)
        for (i in 0..15) {
            if (prefix.exhausted()) {
                break
            }
            val codePoint = prefix.readUtf8CodePoint()
            if (Character.isISOControl(codePoint) && !Character.isWhitespace(codePoint)) {
                return false
            }
        }
        true
    } catch (e: EOFException) {
        false // Truncated UTF-8 sequence.
    }
}
