package com.kangaroo.ktlib.app.init

import com.kangaroo.ktlib.util.json.HJson
import com.kangaroo.ktlib.util.json.UMosh
import com.kangaroo.ktlib.util.log.OrhanobutLog
import com.squareup.moshi.Moshi

/**
 * @author  SHI DA WEI
 * @date  2023/10/26 9:16
 */
class DefalutJsonInit(init : IInit) :
    Init(init) {
    override fun init() {
        super.init()
        HJson.init(UMosh(Moshi.Builder().build()))
    }
}