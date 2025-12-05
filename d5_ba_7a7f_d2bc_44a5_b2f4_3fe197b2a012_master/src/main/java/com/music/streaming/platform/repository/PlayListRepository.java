package com.music.streaming.platform.repository;

import com.music.streaming.platform.model.PlayList;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PlayListRepository extends CrudRepository<PlayList, Long> {
}
