package com.xinghe.project.exception;

import com.xinghe.project.common.ErrorCode;
import com.xinghe.project.common.R;
import com.xinghe.project.common.RUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    @ExceptionHandler(BusinessException.class)
    public R<?> businessExceptionHandler(BusinessException e) {
        log.error("businessException: " + e.getMessage(), e);
        return RUtils.error(e.getCode(), e.getMessage());
    }

    @ExceptionHandler(RuntimeException.class)
    public R<?> runtimeExceptionHandler(RuntimeException e) {
        log.error("runtimeException: " , e);
        return RUtils.error(ErrorCode.SYSTEM_ERROR, e.getMessage());
    }
}
