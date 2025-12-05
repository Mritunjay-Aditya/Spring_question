package com.music.streaming.platform.common.exception;

import org.springframework.http.HttpStatus;

public class ResourceNotFoundException extends RuntimeException {

    private final HttpStatus errorCode;
    private final String message;

    public ResourceNotFoundException(HttpStatus errorCode, String message) {
        this.errorCode = errorCode;
        this.message = message;
    }

}
