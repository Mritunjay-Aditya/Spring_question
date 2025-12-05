package com.music.track.controller;

import com.music.track.dto.TrackRequest;
import com.music.track.model.Track;
import com.music.track.service.TrackService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("music/platform/v1/tracks")
public class TrackController {

    private final TrackService trackService;
    @Autowired
    public TrackController(TrackService trackService) {
        this.trackService = trackService;
    }
    /**
     * Create a track
     * @param trackRequest
     * @return
     */
    @PostMapping()
    public ResponseEntity<Track> createTrack(@RequestBody TrackRequest trackRequest){
        return null;
    }
    /**
     * Get all tracks
     * @return
     */
    @GetMapping()
    public ResponseEntity<List<Track>> getAllTracks(){
        return null;
    }
    /**
     * Delete a track
     * @param trackId
     * @return
     */
    @DeleteMapping("/{trackId}")
    public ResponseEntity<Void> deleteTrack(@PathVariable Long trackId){
        return null;
    }

    /**
     * Get Track sorted
     * @return
     */
    @GetMapping("/sorted")
    public ResponseEntity<List<Track>> getTracksSorted() {
        return null;
    }
}
