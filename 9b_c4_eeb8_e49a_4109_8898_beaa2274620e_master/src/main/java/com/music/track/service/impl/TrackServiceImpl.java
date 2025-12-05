package com.music.track.service.impl;

import com.music.track.dto.TrackRequest;
import com.music.track.model.Track;
import com.music.track.repository.TrackRepository;
import com.music.track.service.TrackService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
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
    public Track getTracksByTitle(String title)  {
    	Track t=trackRepository.findByTitle(title);
        return t;
    }

}
