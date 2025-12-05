package com.artist.controller;

import com.artist.dto.ArtistRequest;
import com.artist.model.Artist;
import com.artist.service.ArtistService;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("v1/artists")
public class ArtistController {
    private final ArtistService artistService;

    public ArtistController(ArtistService artistService) {
        this.artistService = artistService;
    }

    @PostMapping()
    public ResponseEntity<Artist> createPlayList(@RequestBody ArtistRequest artistRequest){
        return new ResponseEntity<Artist>(artistService.createArtist(artistRequest),HttpStatus.CREATED);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Artist> getArtistById(@PathVariable Long id){
    	if(artistService.getArtistByID(id)!=null) {
    		return ResponseEntity.ok(artistService.getArtistByID(id));
    	}
    	return ResponseEntity.notFound().build();
    }

    @GetMapping
    public ResponseEntity<List<Artist>> getAllArtists(){
    	List<Artist> list=artistService.getArtists();
        return ResponseEntity.ok(list);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteArtist(@PathVariable Long id){
    	artistService.deleteArtist(id);
        return ResponseEntity.noContent().build();
    }
}
