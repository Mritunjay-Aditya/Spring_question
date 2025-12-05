package com.hackerrank.api.controller;
 
import com.hackerrank.api.model.Patient;

import com.hackerrank.api.service.PatientService;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.http.HttpStatus;

import org.springframework.http.ResponseEntity;

import org.springframework.web.bind.annotation.*;
 
import java.util.List;
 
@RestController

@RequestMapping("/patient")

public class PatientController {

  private final PatientService patientService;
 
  @Autowired

  public PatientController(PatientService patientService) {

    this.patientService = patientService;

  }
 
  @GetMapping

  @ResponseStatus(HttpStatus.OK)

  public List<Patient> getAllPatient() {

    return patientService.getAllPatient();

  }
 
  @PostMapping

  public ResponseEntity<Patient> createPatient(@RequestBody Patient patient) {

	 if(patient.getId() == null) {

    return new ResponseEntity<>(patientService.createNewPatient(patient), HttpStatus.CREATED);

	 }

	 else {
		 return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
	 }
  }
 
  @GetMapping("/{id}")

  public ResponseEntity<Patient> getPatientById(@PathVariable Long id) {

    if (id < 0) {

      return new ResponseEntity<>(HttpStatus.NOT_FOUND);

    }

        Patient p = patientService.getPatientById(id);

        if(p == null) {
        	
        	return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }

        else {
        	return new ResponseEntity<>(p,HttpStatus.OK);
        }

  }

}

 