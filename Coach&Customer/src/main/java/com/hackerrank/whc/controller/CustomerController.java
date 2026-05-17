package com.hackerrank.whc.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
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
	@Autowired
    CustomerRepository customerRepository;
	
	@PostMapping()
	public ResponseEntity<Customer>createCustomer(@RequestBody Customer customer){
		Customer cust = customerRepository.save(customer);
		return ResponseEntity.status(201).body(cust);
	}
	@GetMapping()
	public ResponseEntity<List<Customer>>getCustomer(){
		List<Customer> cust = customerRepository.findAll(Sort.by(Sort.Direction.ASC,"id"));
		return ResponseEntity.status(200).body(cust);
	}
	@GetMapping("/{id}")
	public ResponseEntity<Customer>getCustomerById(@PathVariable Integer id){
		Customer cust = customerRepository.findById(id).orElse(null);
		if(cust == null) {
			return ResponseEntity.status(404).build();
		}
		return ResponseEntity.status(200).body(cust);
	}
    }

