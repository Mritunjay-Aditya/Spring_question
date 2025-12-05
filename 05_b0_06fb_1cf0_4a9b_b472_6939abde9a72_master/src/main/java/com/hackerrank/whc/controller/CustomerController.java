package com.hackerrank.whc.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.hackerrank.whc.model.Customer;
import com.hackerrank.whc.repository.CustomerRepository;

@RestController
@RequestMapping("/api/customer")
public class CustomerController {

    final CustomerRepository customerRepository;

    public CustomerController(CustomerRepository customerRepository) {
        this.customerRepository = customerRepository;
    }
    @PostMapping
    public ResponseEntity<Customer> create(@RequestBody Customer customer){
    	return new ResponseEntity<Customer>(customerRepository.save(customer),HttpStatus.CREATED);
    }
    
    @GetMapping
    public ResponseEntity<List<Customer>> getAll(){
    	List<Customer> list=customerRepository.findAll();
    	return ResponseEntity.ok(list);
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<Customer> getById(@PathVariable Integer id){
    	return customerRepository.findById(id)
    			.map(ResponseEntity::ok)
    			.orElse(ResponseEntity.notFound().build());
    }
    
}
