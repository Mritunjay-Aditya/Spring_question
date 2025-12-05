package com.music.streaming.platform.service.impl;


import com.music.streaming.platform.common.exception.ResourceNotFoundException;
import com.music.streaming.platform.dto.TrackRequest;
import com.music.streaming.platform.model.Track;
import com.music.streaming.platform.repository.TrackRepository;
import com.music.streaming.platform.service.TrackService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class TrackServiceImpl implements TrackService {

    private final TrackRepository trackRepository;

    @Autowired
    public TrackServiceImpl(TrackRepository trackRepository) {
        this.trackRepository = trackRepository;
    }

    @Override
    public Track createTrack(TrackRequest trackRequest) {
        Track track = new Track();
        track.setTitle(trackRequest.title());
        track.setAlbumName(trackRequest.albumName());
        track.setReleaseDate(trackRequest.releaseDate());
        track.setDuration(trackRequest.duration());
        track.setGenre(trackRequest.genre());
        track.setDescription(trackRequest.description());
        track.setPlayCount(trackRequest.playCount());
        track.setFileUrl(trackRequest.fileUrl());
        track.setCoverImage(trackRequest.coverImage());
        return trackRepository.save(track);
    }

    @Override
    public List<Track> getAllTracks() {
        List<Track> trackList = new ArrayList<>();
        trackRepository.findAll().forEach(trackList::add);
        return trackList;

    }

    @Override
    public Track getTrackById(Long trackId) {
        return trackRepository.findById(trackId)
                .orElseThrow(() -> new ResourceNotFoundException(HttpStatus.NOT_FOUND, "Track not found with ID: " + trackId));
    }

    @Override
    public Track updateTrack(Long trackId, TrackRequest trackRequest) {
        return trackRepository.findById(trackId)
                .map(track -> {
                    track.setTitle(trackRequest.title());
                    track.setAlbumName(trackRequest.albumName());
                    track.setReleaseDate(trackRequest.releaseDate());
                    track.setDuration(trackRequest.duration());
                    track.setGenre(trackRequest.genre());
                    track.setDescription(trackRequest.description());
                    track.setPlayCount(trackRequest.playCount());
                    track.setFileUrl(trackRequest.fileUrl());
                    track.setCoverImage(trackRequest.coverImage());
                    return trackRepository.save(track);
                })
                .orElseThrow(() -> new ResourceNotFoundException(HttpStatus.NOT_FOUND, "Track not found with ID: " + trackId));
    }

    @Override
    public void deleteTrack(Long trackId) {
        trackRepository.deleteById(trackId);
    }
}
