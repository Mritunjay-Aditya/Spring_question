package com.music.track.service.impl;

import com.music.track.dto.TrackRequest;
import com.music.track.model.Track;
import com.music.track.repository.TrackRepository;
import com.music.track.service.TrackService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.net.ResponseCache;
import java.util.List;

@Service
public class TrackServiceImpl implements TrackService {
	
	@Autowired
	private TrackRepository trackRepository;
	
    @Override
    public Track createTrack(TrackRequest trackRequest) {
    	Track t=new Track();
    	t.setAlbumName(trackRequest.albumName());
    	t.setPlayCount(trackRequest.playCount());
    	t.setReleaseDate(trackRequest.releaseDate());
    	t.setTitle(trackRequest.title());
        return trackRepository.save(t);
    }
    @Override
    public List<Track> getAllTracks() {
    	List<Track> list=trackRepository.findAll();
        return list;
    }

    @Override
    public void deleteTrack(Long trackId) {
    	trackRepository.deleteById(trackId);
    }

    @Override
    public List<Track> sortedTracks() {
    	List<Track> list=trackRepository.findAll(Sort.by(Sort.Direction.ASC,"title"));
        return list;
    }
}
