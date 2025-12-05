package com.music.playlist.service;

import com.music.playlist.dto.PlayListRequest;
import com.music.playlist.model.PlayList;

import java.util.List;

public interface PlayListService {

    PlayList createPlayList(PlayListRequest playListRequest);
    List<PlayList> getPlayLists();

    PlayList getPlayListByID(Long id);

    void deletePlayList(Long id);
}
