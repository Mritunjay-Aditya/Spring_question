package com.hackerrank.api.controller;

import com.hackerrank.api.model.Vehicle;
import com.hackerrank.api.service.VehicleService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(value = "/api")
public class VehicleController {
  private final VehicleService vehicleService;

  @Autowired
  public VehicleController(VehicleService vehicleService) {
    this.vehicleService = vehicleService;
  }

  @GetMapping(value = "/vehicle")
  @ResponseStatus(HttpStatus.OK)
  public List<Vehicle> getAllVehicle() {
    return vehicleService.getAllVehicle();
  }

  @PostMapping(value = "/vehicle")
  @ResponseStatus(HttpStatus.CREATED)
  public Vehicle createVehicle(@Valid @RequestBody Vehicle vehicle) {
    return vehicleService.createNewVehicle(vehicle);
  }

  @GetMapping(value = "/vehicle/{id}")
  public ResponseEntity<Vehicle> getVehicleById(@PathVariable Long id) {
    if (id != 0) {
      //non existing
      return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
    }
    return new ResponseEntity<>(vehicleService.getVehicleById(id), HttpStatus.OK);
  }
}
