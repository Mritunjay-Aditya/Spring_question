package com.music.streaming.platform.controller;

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

import com.music.streaming.platform.dto.PlayListRequest;
import com.music.streaming.platform.model.PlayList;
import com.music.streaming.platform.service.PlayListService;

@RestController
@RequestMapping("/music/platform/v1/playlists")
public class PlayListController {
	@Autowired
	private PlayListService playListService;
	
	@PostMapping
	public ResponseEntity<PlayList> create(@RequestBody PlayListRequest playListRequest){
		return new ResponseEntity<PlayList>(playListService.createPlayList(playListRequest),HttpStatus.OK);
	}
	
	@DeleteMapping("/{artistId}")
	public ResponseEntity<PlayList> delete(@PathVariable Long artistId){
		playListService.deletePlayList(artistId);
		return ResponseEntity.noContent().build();
	}
	
	@GetMapping("/{artistId}")
	public ResponseEntity<PlayList> getPlayList(@PathVariable Long artistId){
		if(playListService.getPlayListById(artistId)!=null) {
			return ResponseEntity.ok(playListService.getPlayListById(artistId));
		}
		return ResponseEntity.notFound().build();
	}
}
