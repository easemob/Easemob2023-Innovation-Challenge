package com.xinghe.project.common;

import lombok.Data;

/**
 * 通用返回类
 * @param <T>
 */
@Data
public class R<T> {

    private int code;

    private T data;

    private String message;

    public R(int code, T data, String message) {
        this.code = code;
        this.data = data;
        this.message = message;
    }

    public R(int code, T data) {
        this(code, data, "");
    }

    public R(ErrorCode errorCode) {
        this(errorCode.getCode(), null, errorCode.getMessage());
    }
}
