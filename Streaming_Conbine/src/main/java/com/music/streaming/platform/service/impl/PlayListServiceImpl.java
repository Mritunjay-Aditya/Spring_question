package com.music.streaming.platform.service.impl;

import com.music.streaming.platform.common.exception.ResourceNotFoundException;
import com.music.streaming.platform.dto.PlayListRequest;
import com.music.streaming.platform.model.PlayList;
import com.music.streaming.platform.repository.PlayListRepository;
import com.music.streaming.platform.service.PlayListService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

@Service
public class PlayListServiceImpl implements PlayListService {

    private final PlayListRepository playListRepository;

    @Autowired
    public PlayListServiceImpl(PlayListRepository playListRepository) {
        this.playListRepository = playListRepository;
    }

    @Override
    public PlayList createPlayList(PlayListRequest playListRequest) {
        PlayList playList = new PlayList();
        playList.setName(playListRequest.name());
        playList.setDescription(playListRequest.description());
        return playListRepository.save(playList);
    }

    @Override
    public PlayList getPlayListById(Long playListId) {
        return playListRepository.findById(playListId)
                .orElseThrow(() -> new ResourceNotFoundException(HttpStatus.NOT_FOUND, "play List is empty "));
    }

    @Override
    public void deletePlayList(Long playListId) {
        playListRepository.deleteById(playListId);
    }
}
