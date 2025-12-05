package com.hackerrank.api.exception;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

@ControllerAdvice
public class AppExceptionHandlerControllerAdvice extends ResponseEntityExceptionHandler {

    @ExceptionHandler(value = {ElementNotFoundException.class, BadRequestException.class, MethodArgumentTypeMismatchException.class})
    protected ResponseEntity<Object> handleBug(RuntimeException ex, WebRequest request) {
        return handleExceptionInternal(ex, ex.getCause(), new HttpHeaders(), HttpStatus.NOT_FOUND, request);
    }
}