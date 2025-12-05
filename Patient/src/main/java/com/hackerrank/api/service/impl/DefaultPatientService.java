package com.hackerrank.api.service.impl;

import com.hackerrank.api.exception.ElementNotFoundException;
import com.hackerrank.api.model.Patient;
import com.hackerrank.api.repository.PatientRepository;
import com.hackerrank.api.service.PatientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DefaultPatientService implements PatientService {
  private final PatientRepository patientRepository;

  @Autowired
  DefaultPatientService(PatientRepository patientRepository) {
    this.patientRepository = patientRepository;
  }

  @Override
  public List<Patient> getAllPatient() {
    return patientRepository.findAll();
  }


  @Override
  public Patient createNewPatient(Patient patient) {
    return patientRepository.save(patient);
  }

  @Override
  public Patient getPatientById(Long id) {
    return patientRepository
            .findById(id)
            .orElseThrow(() -> new ElementNotFoundException("Patient with ID not found"));
  }
}
