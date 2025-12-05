package com.music.playlist.controller;

import com.music.playlist.dto.PlayListRequest;
import com.music.playlist.model.PlayList;
import com.music.playlist.service.PlayListService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("v1/playlists")
public class PlayListController {

    private PlayListService playListService;

    public PlayListController(PlayListService playListService) {
        this.playListService = playListService;
    }

    @PostMapping()
    public ResponseEntity<PlayList> createPlayList(@RequestBody PlayListRequest playListRequest){
        return new ResponseEntity<PlayList>(playListService.createPlayList(playListRequest),HttpStatus.CREATED);
    }

    @GetMapping("/{playListId}")
    public ResponseEntity<PlayList> getPlayListById(@PathVariable Long playListId){
        return ResponseEntity.ok(playListService.getPlayListByID(playListId));
    }

    @GetMapping
    public ResponseEntity<List<PlayList>> getAllPlayLists(){
    	List<PlayList> list=playListService.getPlayLists();
        return ResponseEntity.ok(list);
    }

    @DeleteMapping("/{playListId}")
    public ResponseEntity<Void> deletePlayList(@PathVariable Long playListId){
    	playListService.deletePlayList(playListId);
        return ResponseEntity.noContent().build();
    }

}
