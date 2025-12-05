package com.music.streaming.platform.controller;

import com.music.streaming.platform.dto.ArtistRequest;
import com.music.streaming.platform.model.Artist;
import com.music.streaming.platform.service.ArtistService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Collections;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureMockMvc
public class ArtistControllerTest {

    @MockBean
    private ArtistService artistService;

    @Autowired
    private MockMvc mockMvc;

    @Test
    public void testGetAllArtists() throws Exception {
        when(artistService.getAllArtists()).thenReturn(Collections.emptyList());

        mockMvc.perform(get("/music/platform/v1/artists")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());
    }

    @Test
    public void testGetArtistById() throws Exception {
        when(artistService.getArtistById(1L)).thenReturn(new Artist());

        mockMvc.perform(get("/music/platform/v1/artists/{artistId}", 1L)
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());
    }

    @Test
    public void testCreateArtist() throws Exception {
        when(artistService.createArtist(any(ArtistRequest.class))).thenReturn(new Artist());

        mockMvc.perform(post("/music/platform/v1/artists")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{}"))
                .andExpect(status().isOk());
    }

    @Test
    public void testUpdateArtist() throws Exception {
        when(artistService.updateArtist(any(), any(ArtistRequest.class))).thenReturn(new Artist());

        mockMvc.perform(put("/music/platform/v1/artists/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{}"))
                .andExpect(status().isOk());
    }

    @Test
    public void testDeleteArtist() throws Exception {
        mockMvc.perform(delete("/music/platform/v1/artists/1")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isNoContent());
    }
}