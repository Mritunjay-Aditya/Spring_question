package com.music.streaming.platform.service.impl;

import com.music.streaming.platform.common.exception.ResourceNotFoundException;
import com.music.streaming.platform.dto.ArtistRequest;
import com.music.streaming.platform.model.Artist;
import com.music.streaming.platform.repository.ArtistRepository;
import com.music.streaming.platform.service.ArtistService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class ArtistServiceImpl implements ArtistService {

    private final ArtistRepository artistRepository;

    @Autowired
    public ArtistServiceImpl(ArtistRepository artistRepository) {
        this.artistRepository = artistRepository;
    }

    @Override
    public Artist createArtist(ArtistRequest artistRequest) {
        Artist artist = new Artist();
        artist.setArtistName(artistRequest.artistName());
        artist.setBio(artistRequest.bio());
        artist.setGenre(artistRequest.genre());
        artist.setOrigin(artistRequest.origin());
        artist.setFormedYear(artistRequest.formedYear());
        artist.setSocialLink(artistRequest.socialLink());
        artist.setImage(artistRequest.image());
        return artistRepository.save(artist);
    }

    @Override
    public List<Artist> getAllArtists() {
        List<Artist> artistList = new ArrayList<>();
        artistRepository.findAll().forEach(artistList::add);
        return artistList;
    }

    @Override
    public Artist getArtistById(Long artistId) {
        return artistRepository.findById(artistId)
                .orElseThrow(() -> new ResourceNotFoundException(HttpStatus.NOT_FOUND, "Artist not found with ID: " + artistId));
    }

    @Override
    public Artist updateArtist(Long artistId, ArtistRequest artistRequest) {
        return artistRepository.findById(artistId)
                .map(artist -> {
                    artist.setArtistName(artistRequest.artistName());
                    artist.setBio(artistRequest.bio());
                    artist.setGenre(artistRequest.genre());
                    artist.setOrigin(artistRequest.origin());
                    artist.setFormedYear(artistRequest.formedYear());
                    artist.setSocialLink(artistRequest.socialLink());
                    artist.setImage(artistRequest.image());
                    return artistRepository.save(artist);
                }).orElseThrow(() -> new ResourceNotFoundException(HttpStatus.NOT_FOUND, "Artist not found with ID: " + artistId));
    }

    @Override
    public void deleteArtist(Long artistId) {
        artistRepository.deleteById(artistId);
    }
}
