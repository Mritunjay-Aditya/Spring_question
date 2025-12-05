package com.artist.service.impl;

import com.artist.dto.ArtistRequest;
import com.artist.model.Artist;
import com.artist.repository.ArtistRepository;
import com.artist.service.ArtistService;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class ArtistServiceImpl implements ArtistService {
    private final ArtistRepository artistRepository;

    public ArtistServiceImpl(ArtistRepository artistRepository) {
        this.artistRepository = artistRepository;
    }

    @Override
    public Artist createArtist(ArtistRequest artistRequest) {
    	Artist a=new Artist();
    	a.setFirstName(artistRequest.firstName());
    	a.setLastName(artistRequest.lastName());
    	
        return artistRepository.save(a);
    }

    @Override
    public List<Artist> getArtists() {
    	List<Artist> list=artistRepository.findAll();
        return list;
    }

    @Override
    public Artist getArtistByID(Long id) {
        return artistRepository.findById(id).orElse(null);
    }

    @Override
    public void deleteArtist(Long id) {
    	artistRepository.deleteById(id);
    }
}
