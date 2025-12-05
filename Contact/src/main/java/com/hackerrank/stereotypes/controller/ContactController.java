package com.hackerrank.stereotypes.controller;

import com.hackerrank.stereotypes.model.Person;
import com.hackerrank.stereotypes.service.ContactService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

public class ContactController {
    ContactService contactService;

    public ResponseEntity<Person> save(Person person){
        Person saved = contactService.save(person);
        return new ResponseEntity(saved, HttpStatus.CREATED);
    }

    public ResponseEntity<Person> retrieve(Integer id){
        Person person = contactService.retrieve(id);
        return new ResponseEntity(person, HttpStatus.OK);
    }
}
