package com.hackerrank.stereotypes.service;

import com.hackerrank.stereotypes.model.Person;
import com.hackerrank.stereotypes.repository.ContactRepository;

public class ContactService {
    ContactRepository contactRepository;

    public Person retrieve(Integer id){
        return contactRepository.findById(id).get();
    }

    public Person save(Person person){
        return contactRepository.save(person);
    }
}
