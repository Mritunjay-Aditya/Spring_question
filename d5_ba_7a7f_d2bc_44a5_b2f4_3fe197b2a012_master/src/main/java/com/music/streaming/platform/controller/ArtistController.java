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

import com.music.streaming.platform.dto.ArtistRequest;
import com.music.streaming.platform.model.Artist;
import com.music.streaming.platform.service.ArtistService;

@RestController
@RequestMapping("/music/platform/v1/artists")
public class ArtistController {
	
	@Autowired
	private ArtistService artistService;
	
	@PostMapping
	public ResponseEntity<Artist> create(@RequestBody ArtistRequest artistRequest){
		return new ResponseEntity<Artist>(artistService.createArtist(artistRequest),HttpStatus.OK);
	}
	
	@GetMapping
	public ResponseEntity<List<Artist>> getAll(){
		List<Artist> list=artistService.getAllArtists();
		return ResponseEntity.ok(list);
	}
	
	@DeleteMapping("/{artistId}")
	public ResponseEntity<Void> delete(@PathVariable Long artistId){
		artistService.deleteArtist(artistId);
		return ResponseEntity.noContent().build();
	}
	
	@GetMapping("/{artistId}")
	public ResponseEntity<Artist> getById(@PathVariable Long artistId){
		if(artistService.getArtistById(artistId)!=null) {
			return ResponseEntity.ok(artistService.getArtistById(artistId));
		}
		return ResponseEntity.notFound().build();
	}
	
	@PutMapping("/{artistId}")
	public ResponseEntity<Artist> update(@PathVariable Long artistId,@RequestBody ArtistRequest artistRequest){
		Artist artist=artistService.updateArtist(artistId, artistRequest);
		return ResponseEntity.ok(artist);
	}
}
