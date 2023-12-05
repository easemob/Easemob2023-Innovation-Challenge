package com.kangaroo.ktlib.data.models.data

import androidx.datastore.core.CorruptionException
import androidx.datastore.core.Serializer
import com.google.protobuf.InvalidProtocolBufferException
import com.kangaroo.ktlib.data.models.PersistentPreferences
import java.io.InputStream
import java.io.OutputStream

/**
 * @author  SHI DA WEI
 * @date  2023/11/3 9:37
 */
object PersistentSerializer : Serializer<PersistentPreferences> {

    override val defaultValue: PersistentPreferences = PersistentPreferences.getDefaultInstance()

    override suspend fun readFrom(input: InputStream): PersistentPreferences {
        try {
            return PersistentPreferences.parseFrom(input)
        } catch (exception: InvalidProtocolBufferException) {
            throw CorruptionException("Cannot read proto.", exception)
        }
    }

    override suspend fun writeTo(t: PersistentPreferences, output: OutputStream) = t.writeTo(output)
}

object InnerPersistentSerializer : Serializer<PersistentPreferences.Persistent> {

    override val defaultValue: PersistentPreferences.Persistent = PersistentPreferences.Persistent.getDefaultInstance()

    override suspend fun readFrom(input: InputStream): PersistentPreferences.Persistent {
        try {
            return PersistentPreferences.Persistent.parseFrom(input)
        } catch (exception: InvalidProtocolBufferException) {
            throw CorruptionException("Cannot read proto.", exception)
        }
    }

    override suspend fun writeTo(t: PersistentPreferences.Persistent, output: OutputStream) = t.writeTo(output)
}