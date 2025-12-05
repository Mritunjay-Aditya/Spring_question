package com.hackerrank.api.controller;

import com.hackerrank.api.model.Home;
import com.hackerrank.api.repository.HomeRepository;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping(value = "/api")
public class HomeController {
  private final HomeRepository homeRepository;

  public HomeController(HomeRepository homeRepository) {
    this.homeRepository = homeRepository;
  }


  //1. POST
  @RequestMapping(value = "/home", method = RequestMethod.POST)
  public ResponseEntity<Home> addRecord(@RequestBody Home newRecord) {
    if (newRecord.getId() != null) {
      return new ResponseEntity<>(newRecord, HttpStatus.BAD_REQUEST);
    }
    Home createRecord = homeRepository.save(newRecord);
    return new ResponseEntity<>(createRecord, HttpStatus.CREATED);
  }

  //2. GET by Id
  @RequestMapping(value = "/home/{id}", method = RequestMethod.GET)
  public ResponseEntity<Home> getRecordsById(@PathVariable Integer id) {
	  if(id<1) {
		  return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }
	 return homeRepository.findById(id)
			 .map(ResponseEntity::ok)
			 .orElse(ResponseEntity.notFound().build());
  }

  //3. GET
  @RequestMapping(value = "/home", method = RequestMethod.GET)
  public ResponseEntity<List<Home>> getRecords() {
    List<Home> data = homeRepository.findAll(Sort.by(Sort.Direction.ASC, "id"));
    return new ResponseEntity<>(data, HttpStatus.OK);
  }
}
