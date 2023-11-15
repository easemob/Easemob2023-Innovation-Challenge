/*
 * Copyright 2023 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.kangaroo.ktdemo.data.model

import com.kangaroo.ktdemo.data.model.local.LocalUser
import com.kangaroo.ktdemo.data.model.network.responses.NetUser
import com.kangaroo.ktdemo.data.model.network.responses.TaskStatus

// Local to External
fun LocalUser.toExternal() = Task(
    id = id,
    title = title,
    description = description,
    isCompleted = isCompleted,
)

@JvmName("localToExternal")
fun List<LocalUser>.toExternal() = map(LocalUser::toExternal)


@JvmName("networkToLocal")
fun List<NetUser>.toLocal() = map(NetUser::toLocal)

// Network to Local
fun NetUser.toLocal() = LocalUser(
    id = id,
    title = title,
    description = shortDescription,
    isCompleted = (status == TaskStatus.COMPLETE),
)
