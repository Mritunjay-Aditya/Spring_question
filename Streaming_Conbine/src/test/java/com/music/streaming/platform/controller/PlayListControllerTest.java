package com.music.streaming.platform.controller;

import com.music.streaming.platform.dto.PlayListRequest;
import com.music.streaming.platform.model.PlayList;
import com.music.streaming.platform.service.PlayListService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureMockMvc
public class PlayListControllerTest {

    @MockBean
    private PlayListService playListService;

    @Autowired
    private MockMvc mockMvc;

    @Test
    public void testCreatePlayList() throws Exception {
        when(playListService.createPlayList(any(PlayListRequest.class))).thenReturn(new PlayList());

        mockMvc.perform(post("/music/platform/v1/playlists")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{}"))
                .andExpect(status().isOk());
    }

    @Test
    public void testGetPlaylistById() throws Exception {
        when(playListService.getPlayListById(anyLong())).thenReturn(new PlayList());

        mockMvc.perform(get("/music/platform/v1/playlists/{playlistId}", 1L)
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());
    }

    @Test
    public void testDeletePlaylist() throws Exception {
        doNothing().when(playListService).deletePlayList(anyLong());

        mockMvc.perform(delete("/music/platform/v1/playlists/{playlistId}", 1L)
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isNoContent());
    }
}
