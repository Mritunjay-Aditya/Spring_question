package com.hackerrank.restcontrolleradvice.exception;

import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

@RestControllerAdvice
public class FizzBuzzExceptionHandler extends ResponseEntityExceptionHandler {

  //TODO:: implement handler methods for FizzException, BuzzException and FizzBuzzException
}
