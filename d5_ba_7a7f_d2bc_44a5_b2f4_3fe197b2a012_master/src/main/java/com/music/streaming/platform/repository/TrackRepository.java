package com.music.streaming.platform.repository;

import com.music.streaming.platform.model.Track;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TrackRepository extends CrudRepository<Track, Long> {
}
