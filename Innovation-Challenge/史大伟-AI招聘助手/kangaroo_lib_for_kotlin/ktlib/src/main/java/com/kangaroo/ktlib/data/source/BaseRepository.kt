package com.kangaroo.ktlib.data.source

import com.kangaroo.ktlib.data.source.local.ILocal
import com.kangaroo.ktlib.data.source.network.INetwork

/**
 * @author  SHI DA WEI
 * @date  2023/10/23 15:57
 */
class BaseRepository<T1 : INetwork,T2 : ILocal> constructor(
    private val networkDataSource: T1? = null,
    private val localDataSource: T2? = null,) {

}