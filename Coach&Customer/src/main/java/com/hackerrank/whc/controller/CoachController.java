package com.hackerrank.whc.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.hackerrank.whc.model.Coach;
import com.hackerrank.whc.repository.CoachRepository;

@RestController
@RequestMapping("/api/coach")
public class CoachController {

	private final CustomerController customerController;
	@Autowired
	CoachRepository coachRepository;

	CoachController(CustomerController customerController) {
		this.customerController = customerController;
	}

	@PostMapping()
	public ResponseEntity<Coach> createCoach(@RequestBody Coach coach) {
		Coach coa = coachRepository.save(coach);
		return ResponseEntity.status(201).body(coa);
	}

	@GetMapping()
	public ResponseEntity<List<Coach>> getAllCoach() {
		List<Coach> coa = coachRepository.findAll(Sort.by(Sort.Direction.ASC,"id"));
		return ResponseEntity.status(200).body(coa);
	}

	@GetMapping("/{id}")
	public ResponseEntity<Coach> getCoachById(@PathVariable Integer id) {
		Coach coa = coachRepository.findById(id).orElse(null);
		if (coa == null) {
			return ResponseEntity.status(404).build();
		}
		return ResponseEntity.status(200).body(coa);
	}
}
