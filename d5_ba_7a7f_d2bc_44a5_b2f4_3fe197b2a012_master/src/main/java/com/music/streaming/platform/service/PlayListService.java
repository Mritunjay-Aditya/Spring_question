package com.music.streaming.platform.service;

import com.music.streaming.platform.dto.PlayListRequest;
import com.music.streaming.platform.model.PlayList;

public interface PlayListService {

    PlayList createPlayList(PlayListRequest playListRequest);

    PlayList getPlayListById(Long playListId);

    void deletePlayList(Long playListId);
}
