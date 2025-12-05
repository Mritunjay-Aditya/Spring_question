package com.hackerrank.validator.controller;

import com.hackerrank.validator.model.Employee;
import com.hackerrank.validator.repository.EmployeeRepository;
import com.hackerrank.validator.validation.EmployeeValidator;
import com.hackerrank.validator.validation.FieldValidationMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindException;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class EmployeeController {
    @Autowired
    EmployeeRepository repository;

    @RequestMapping(value = "/employee", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<FieldValidationMessage>> validateBody(@RequestBody Employee employee) throws BindException {
        EmployeeValidator validator = new EmployeeValidator();

        WebDataBinder binder = new WebDataBinder(employee);
        binder.setValidator(validator);

        // throws BindException if there are binding/validation
        // errors, exceptions are handled using @ControllerAdvice EmployeeValidationErrorHandler
        binder.validate();
        binder.close();

        //If no validation errors save and return status
        repository.save(employee);

        return new ResponseEntity(HttpStatus.OK);
    }
}
