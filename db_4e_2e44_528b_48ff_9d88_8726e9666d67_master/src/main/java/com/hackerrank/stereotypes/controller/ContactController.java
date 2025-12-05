package com.hackerrank.stereotypes.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.hackerrank.stereotypes.model.Person;
import com.hackerrank.stereotypes.service.ContactService;

@RestController
@RequestMapping("/contact")
public class ContactController {
	@Autowired
    private ContactService contactService;

	@PostMapping("/save")
    public ResponseEntity<Person> save(@RequestBody Person person){
        Person saved = contactService.save(person);
        return new ResponseEntity<>(saved, HttpStatus.CREATED);
    }

	@GetMapping("/retrieve/{id}")
    public ResponseEntity<Person> retrieve(@PathVariable Integer id){
        Person person = contactService.retrieve(id);
        return new ResponseEntity<>(person, HttpStatus.OK);
    }
}
