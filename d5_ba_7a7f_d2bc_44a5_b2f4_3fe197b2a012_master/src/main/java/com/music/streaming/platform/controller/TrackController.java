package com.music.streaming.platform.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.music.streaming.platform.dto.TrackRequest;
import com.music.streaming.platform.model.Track;
import com.music.streaming.platform.service.TrackService;

@RestController
@RequestMapping("/music/platform/v1/tracks")
public class TrackController {
	@Autowired
	private TrackService trackService;
	
	@PostMapping
	public ResponseEntity<Track> create(@RequestBody TrackRequest trackRequest){
		Track t=trackService.createTrack(trackRequest);
		return new ResponseEntity<>(t,HttpStatus.OK);
	}
	
	
	@DeleteMapping("/{trackId}")
	public ResponseEntity<Track> delete(@PathVariable Long trackId) {
		trackService.deleteTrack(trackId);
		return ResponseEntity.noContent().build();
	}

	@GetMapping
	public ResponseEntity<List<Track>> getAll() {
		List<Track> list = trackService.getAllTracks();
		return ResponseEntity.ok(list);
	}
	
	@GetMapping("/{trackId}")
	public ResponseEntity<Track> getById(@PathVariable Long trackId){
		if(trackService.getTrackById(trackId)!=null) {
			return ResponseEntity.ok(trackService.getTrackById(trackId));
		}
		return ResponseEntity.notFound().build();
	}
	
	@PutMapping("/{trackId}")
	public ResponseEntity<Track> update(@PathVariable Long trackId,@RequestBody TrackRequest trackRequest){
			if(trackService.getTrackById(trackId)!=null) {
				return ResponseEntity.notFound().build();
			}
			
			Track t=trackService.updateTrack(trackId, trackRequest);
			return ResponseEntity.ok(t);
			
	}
	
	
}
