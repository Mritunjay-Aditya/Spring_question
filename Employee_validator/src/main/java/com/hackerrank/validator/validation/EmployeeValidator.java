package com.hackerrank.validator.validation;

import com.hackerrank.validator.model.Employee;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

public class EmployeeValidator implements Validator {
    @Override
    public boolean supports(Class<?> aClass) {
        return Employee.class.isAssignableFrom(aClass);
    }

    @Override
    public void validate(Object employeeObject, Errors errors) {
        // write validation logic here
    }
}
