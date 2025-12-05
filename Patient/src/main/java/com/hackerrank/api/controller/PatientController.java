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
  @ResponseStatus(HttpStatus.CREATED)
  public ResponseEntity<Patient> createPatient(@RequestBody Patient patient) {
    return new ResponseEntity<>(patientService.createNewPatient(patient), HttpStatus.OK);
  }

  @GetMapping("/{id}")
  @ResponseStatus(HttpStatus.CREATED)
  public Patient getPatientById(@PathVariable Long id) {
    if (id < 1) {
      return new Patient();
    }
    return patientService.getPatientById(id);
  }
}
