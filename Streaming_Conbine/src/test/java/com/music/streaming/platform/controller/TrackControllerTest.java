package com.music.streaming.platform.controller;

import com.music.streaming.platform.dto.TrackRequest;
import com.music.streaming.platform.model.Track;
import com.music.streaming.platform.service.TrackService;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Collections;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureMockMvc
public class TrackControllerTest {

    @MockBean
    private TrackService trackService;

    @Autowired
    private MockMvc mockMvc;

    @Test
    public void testCreateTrack() throws Exception {
        when(trackService.createTrack(any(TrackRequest.class))).thenReturn(new Track());

        mockMvc.perform(post("/music/platform/v1/tracks")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{}"))
                .andExpect(status().isOk());
    }

    @Test
    public void testGetAllTracks() throws Exception {
        when(trackService.getAllTracks()).thenReturn(Collections.emptyList());

        mockMvc.perform(get("/music/platform/v1/tracks")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());
    }

    @Test
    public void testGetTrackById() throws Exception {
        when(trackService.getTrackById(anyLong())).thenReturn(new Track());

        mockMvc.perform(get("/music/platform/v1/tracks/{trackId}", 1L)
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());
    }

    @Test
    public void testUpdateTrack() throws Exception {
        when(trackService.updateTrack(anyLong(), any(TrackRequest.class))).thenReturn(new Track());

        mockMvc.perform(put("/music/platform/v1/tracks/{trackId}", 1L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{}"))
                .andExpect(status().isOk());
    }

    @Test
    public void testDeleteTrack() throws Exception {
        Mockito.doNothing().when(trackService).deleteTrack(anyLong());

        mockMvc.perform(delete("/music/platform/v1/tracks/{trackId}", 1L)
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isNoContent());
    }
}