package com.music.track.service.impl;

import com.music.track.dto.TrackRequest;
import com.music.track.model.Track;
import com.music.track.service.TrackService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TrackServiceImpl implements TrackService {
    @Override
    public Track createTrack(TrackRequest trackRequest) {
        return null;
    }
    @Override
    public List<Track> getAllTracks() {
        return null;
    }

    @Override
    public void deleteTrack(Long trackId) {
    }

    @Override
    public List<Track> sortedTracks() {
        return null;
    }
}
