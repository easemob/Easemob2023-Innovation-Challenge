package com.kangaroo.ktlib.util.store.filestorage

import com.kangaroo.ktlib.util.store.filestorage.UStorage.THRESHOLD_MIN_SPCAE

enum class StorageType @JvmOverloads constructor ( val storageDirectoryName : DierctoryType,val storageMinSize:Long = THRESHOLD_MIN_SPCAE) {
    TYPE_LOG(DierctoryType.log),
    TYPE_CACHE(DierctoryType.cache),
    TYPE_TEMP(DierctoryType.temp),
    TYPE_FILE(DierctoryType.file),
    TYPE_AUDIO(DierctoryType.audio),
    TYPE_IMAGE(DierctoryType.image),
    TYPE_VIDEO(DierctoryType.video),
    TYPE_THUMB_IMAGE(DierctoryType.thumb),
    TYPE_THUMB_VIDEO(DierctoryType.thumb)
}


@JvmInline
value class DierctoryType(val path:String) {
    companion object{
        val audio = DierctoryType("audio/")
        val data = DierctoryType("data/")
        val file = DierctoryType("file/")
        val log = DierctoryType("log/")
        val cache = DierctoryType("cache/")
        val temp = DierctoryType("temp/")
        val image = DierctoryType("image/")
        val thumb = DierctoryType("thumb/")
        val video = DierctoryType("video/")
    }
}