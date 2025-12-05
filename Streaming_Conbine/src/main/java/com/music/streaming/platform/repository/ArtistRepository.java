package com.music.streaming.platform.repository;

import com.music.streaming.platform.model.Artist;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ArtistRepository extends CrudRepository<Artist, Long> {
}
