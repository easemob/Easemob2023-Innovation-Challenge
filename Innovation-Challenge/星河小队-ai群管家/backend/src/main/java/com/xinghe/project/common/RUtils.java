package com.xinghe.project.common;

/**
 * 返回工具类
 */
public class RUtils {

    /**
     * 成功
     * @param data
     * @param <T>
     * @return
     */
    public static <T> R<T> success(T data) {
        return new R<T>(0, data, "ok");
    }

    /**
     * 失败
     * @param errorCode
     * @return
     */
    public static R error(ErrorCode errorCode) {
        return new R(errorCode);
    }

    /**
     * 失败
     * @param code
     * @param message
     * @return
     */
    public static R error(int code, String message) {
        return new R(code, null, message);
    }

    /**
     * 失败
     * @param errorCode
     * @param message
     * @return
     */
    public static R error(ErrorCode errorCode, String message) {
        return new R(errorCode.getCode(), message);
    }
}
