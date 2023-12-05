package com.kangaroo.ktdemo.data.model.network.responses

/**
 * @author  SHI DA WEI
 * @date  2023/10/25 9:31
 */
data class NetUser(
    val id: String,
    val title: String,
    val shortDescription: String,
    val priority: Int? = null,
    val status: TaskStatus = TaskStatus.ACTIVE
)

enum class TaskStatus {
    ACTIVE,
    COMPLETE
}
