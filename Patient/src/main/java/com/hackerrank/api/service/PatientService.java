package com.hackerrank.api.service;

import com.hackerrank.api.model.Patient;
import java.util.List;

public interface PatientService {

  List<Patient> getAllPatient();

  Patient createNewPatient(Patient patient);

  Patient getPatientById(Long id);
}
