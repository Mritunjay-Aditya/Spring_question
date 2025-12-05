package com.music.streaming.platform.service;

import com.music.streaming.platform.dto.TrackRequest;
import com.music.streaming.platform.model.Track;

import java.util.List;

public interface TrackService {

    Track createTrack(TrackRequest trackRequest);

    List<Track> getAllTracks();

    Track getTrackById(Long trackId);

    Track updateTrack(Long trackId, TrackRequest trackRequest);

    void deleteTrack(Long trackId);
}
