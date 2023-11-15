package com.kangaroo.ktdemo.data.model

/**
 * @author  SHI DA WEI
 * @date  2023/10/24 15:35
 */
data class Task(
    val title: String = "",
    val description: String = "",
    val isCompleted: Boolean = false,
    val id: String,
) {

    val titleForList: String
        get() = if (title.isNotEmpty()) title else description

    val isActive
        get() = !isCompleted

    val isEmpty
        get() = title.isEmpty() || description.isEmpty()
}
