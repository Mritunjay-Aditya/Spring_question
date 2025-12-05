package com.hackerrank.api.controller;

import com.hackerrank.api.model.Vehicle;
import com.hackerrank.api.service.VehicleService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

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

	@PostMapping("/vehicle")
	public ResponseEntity<Vehicle> createVehicle(@RequestBody Vehicle vehicle) {

		if (vehicle.getId() == null) {
			return new ResponseEntity<>(vehicleService.createNewVehicle(vehicle), HttpStatus.CREATED);

		} else {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);

		}
	}

	@GetMapping(value = "/vehicle/{id}")
	public ResponseEntity<Vehicle> getVehicleById(@PathVariable Long id) {
		if (id < 1||id==null) {
			return ResponseEntity.notFound().build();
		}
		Vehicle v = vehicleService.getVehicleById(id);

		if (v != null) {
			return new ResponseEntity<>(v, HttpStatus.OK);
		}

		return new ResponseEntity<>(HttpStatus.NOT_FOUND);
	}
}
