package com.hackerrank.api.service.impl;

import com.hackerrank.api.exception.BadRequestException;
import com.hackerrank.api.exception.ElementNotFoundException;
import com.hackerrank.api.model.Vehicle;
import com.hackerrank.api.repository.VehicleRepository;
import com.hackerrank.api.service.VehicleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DefaultVehicleService implements VehicleService {
  private final VehicleRepository vehicleRepository;

  @Autowired
  DefaultVehicleService(VehicleRepository vehicleRepository) {
    this.vehicleRepository = vehicleRepository;
  }

  @Override
  public List<Vehicle> getAllVehicle() {
    return vehicleRepository.findAll();
  }


  @Override
  public Vehicle createNewVehicle(Vehicle vehicle) {
    if (vehicle.getId().toString().isEmpty()) {
      throw new BadRequestException("The ID must not be provided when creating a new Vehicle");
    }

    return vehicleRepository.save(vehicle);
  }

  @Override
  public Vehicle getVehicleById(Long id) {
    return vehicleRepository
            .findById(id)
            .orElseThrow(() -> new ElementNotFoundException("Vehicle with ID not found"));
  }
}
