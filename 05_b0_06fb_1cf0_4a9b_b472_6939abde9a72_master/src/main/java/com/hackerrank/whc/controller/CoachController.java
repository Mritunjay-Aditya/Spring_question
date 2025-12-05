package com.hackerrank.whc.controller;

import java.util.List;

import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.hackerrank.whc.model.Coach;
import com.hackerrank.whc.repository.CoachRepository;

import jakarta.websocket.server.PathParam;

@RestController
@RequestMapping("/api/coach")
public class CoachController {

    final CoachRepository coachRepository;

    public CoachController(CoachRepository coachRepository) {
        this.coachRepository = coachRepository;
    }
    
    @PostMapping
    public ResponseEntity<Coach> create(@RequestBody Coach coach){
    	return new ResponseEntity<Coach>(coachRepository.save(coach),HttpStatus.CREATED);
    }
    
    @GetMapping
    public ResponseEntity<List<Coach>> getAll(){
    	List<Coach> list=coachRepository.findAll(Sort.by(Sort.Direction.ASC,"id"));
    	return ResponseEntity.ok(list);
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<Coach> getById(@PathVariable Integer id){
    	return coachRepository.findById(id)
    			.map(ResponseEntity::ok)
    			.orElse(ResponseEntity.notFound().build());
    }
}
