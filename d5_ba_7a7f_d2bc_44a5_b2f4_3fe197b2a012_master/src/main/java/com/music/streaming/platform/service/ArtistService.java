package com.music.streaming.platform.service;


import com.music.streaming.platform.dto.ArtistRequest;
import com.music.streaming.platform.model.Artist;

import java.util.List;

public interface ArtistService {

    Artist createArtist(ArtistRequest artistRequest);

    List<Artist> getAllArtists();

    Artist getArtistById(Long artistId);

    Artist updateArtist(Long artistId, ArtistRequest artistRequest);

    void deleteArtist(Long artistId);
}
