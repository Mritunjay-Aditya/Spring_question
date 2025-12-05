package com.hackerrank.weather.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.hackerrank.weather.model.Weather;
import com.hackerrank.weather.repository.WeatherRepository;

@RestController
@RequestMapping("/weather")
public class WeatherApiRestController {
	
	@Autowired
	private WeatherRepository weatherRepository;
	
	@PostMapping
	public ResponseEntity<Weather> create(@RequestBody Weather weather){
		return new ResponseEntity<Weather>(weatherRepository.save(weather),HttpStatus.CREATED);
	}
	@GetMapping
	public ResponseEntity<List<Weather>> getAll(){
		return ResponseEntity.ok(weatherRepository.findAll());
	}
	
	@DeleteMapping("/{id}")
	public ResponseEntity<Void> delete(@PathVariable Integer id){
		weatherRepository.deleteById(id);
		return ResponseEntity.noContent().build();
	}
	
	@GetMapping("/{id}")
	public ResponseEntity<Weather> getById(@PathVariable Integer id){

		return weatherRepository.findById(id)
				.map(ResponseEntity::ok)
				.orElse(ResponseEntity.notFound().build());
	}
}
