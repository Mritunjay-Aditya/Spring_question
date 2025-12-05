package com.hackerrank.restcontrolleradvice.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

import com.hackerrank.restcontrolleradvice.dto.BuzzException;
import com.hackerrank.restcontrolleradvice.dto.FizzBuzzException;
import com.hackerrank.restcontrolleradvice.dto.FizzException;
import com.hackerrank.restcontrolleradvice.dto.GlobalError;

@RestControllerAdvice
public class FizzBuzzExceptionHandler extends ResponseEntityExceptionHandler {

  //TODO:: implement handler methods for FizzException, BuzzException and FizzBuzzException
	
	@ExceptionHandler(FizzException.class)
	public ResponseEntity<GlobalError> handleFizz(FizzException e){
		GlobalError error=new GlobalError(e.getMessage(),e.getErrorReason());
		return new ResponseEntity<>(error,HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@ExceptionHandler(BuzzException.class)
	public ResponseEntity<GlobalError> handleBuzz(BuzzException e){
		GlobalError error=new GlobalError(e.getMessage(),e.getErrorReason());
		return new ResponseEntity<GlobalError>(error,HttpStatus.BAD_REQUEST);
	}
	
	@ExceptionHandler(FizzBuzzException.class)
	public ResponseEntity<GlobalError> handleFizzBuzz(FizzBuzzException e){
		GlobalError error=new GlobalError(e.getMessage(),e.getErrorReason());
		return new ResponseEntity<GlobalError>(error,HttpStatus.INSUFFICIENT_STORAGE);
	}
}
