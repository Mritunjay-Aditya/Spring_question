package com.hackerrank.api.controller;

import com.hackerrank.api.model.Location;
import com.hackerrank.api.repository.LocationRepository;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping(value = "/api")
public class LocationController {
  private final LocationRepository locationRepository;

  public LocationController(LocationRepository locationRepository) {
    this.locationRepository = locationRepository;
  }


  //1. POST
  @RequestMapping(value = "/location", method = RequestMethod.POST)
  public ResponseEntity<Location> addRecord(@RequestBody Location newRecord) {
    if (newRecord.getId() != null) {
      return new ResponseEntity(newRecord, HttpStatus.OK);
    }

    if (newRecord.getId().toString() != null) {
      return new ResponseEntity(newRecord, HttpStatus.BAD_REQUEST);
    }

    Location createRecord = locationRepository.save(newRecord);
    return new ResponseEntity(createRecord, HttpStatus.CREATED);
  }

  //2. GET by Id
  @RequestMapping(value = "/location/{id}", method = RequestMethod.GET)
  public ResponseEntity<Location> getRecordsById(@PathVariable Integer id) {
    Optional<Location> data = locationRepository.findById(id);
    if (data.isPresent()) {
      return new ResponseEntity(data, HttpStatus.OK);
    } else {
      return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
    }
  }

  //3. GET
  @RequestMapping(value = "/location", method = RequestMethod.GET)
  public ResponseEntity<List<Location>> getRecords() {
    List<Location> data = locationRepository.findAll(Sort.by(Sort.Direction.ASC, "id"));
    return new ResponseEntity<>(data, HttpStatus.OK);
  }
}
