package com.music.streaming.platform.common.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice
public class ApplicationExceptions {

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ProblemDetail> applicationExceptionHandler(Exception exception) {
        Map<Class<? extends Exception>, HttpStatus> exceptionMappings = new HashMap<>();
        exceptionMappings.put(ResourceNotFoundException.class, HttpStatus.NOT_FOUND);
        exceptionMappings.put(SQLException.class, HttpStatus.INTERNAL_SERVER_ERROR);


        HttpStatus httpStatus = exceptionMappings.getOrDefault(exception.getClass(), HttpStatus.INTERNAL_SERVER_ERROR);
        return ResponseEntity.status(httpStatus)
                .body(ProblemDetail.forStatusAndDetail(httpStatus, exception.getMessage()));
    }
}
