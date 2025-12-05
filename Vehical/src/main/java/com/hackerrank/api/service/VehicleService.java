package com.hackerrank.api.service;

import com.hackerrank.api.model.Vehicle;
import java.util.List;

public interface VehicleService {

  List<Vehicle> getAllVehicle();

  Vehicle createNewVehicle(Vehicle vehicle);

  Vehicle getVehicleById(Long id);
}
