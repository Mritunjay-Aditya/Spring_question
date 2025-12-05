package com.hackerrank.gevents.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.hackerrank.gevents.model.Event;
import com.hackerrank.gevents.repository.EventRepository;

@RestController
public class EventController {
	@Autowired
	private EventRepository eventRepository;
	
	@PostMapping("/events")
	public ResponseEntity<Event> create(@RequestBody Event event){
		return new ResponseEntity<Event>(eventRepository.save(event),HttpStatus.CREATED);
	}
	@GetMapping("/events")
	public ResponseEntity<List<Event>> getAll(){
		List<Event> list=eventRepository.findAll();
		return ResponseEntity.ok(list);
	}
	@GetMapping("/events/{eventId}")
	public ResponseEntity<Event> getEventById(@PathVariable Integer eventId){
		return eventRepository.findById(eventId)
				.map(ResponseEntity::ok)
				.orElse(ResponseEntity.notFound().build());
	}
	
	@GetMapping("/repos/{repoId}/events")
	public ResponseEntity<List<Event>> getRepoById(@PathVariable Integer repoId){
		if(eventRepository.existsById(repoId)) {
			return ResponseEntity.ok(eventRepository.findByRepoIdOrderByIdAsc(repoId));
		}
		return ResponseEntity.notFound().build();
	}
	
}
