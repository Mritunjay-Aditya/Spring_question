package com.music.playlist;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.music.playlist.dto.PlayListRequest;
import com.music.playlist.model.PlayList;
import com.music.playlist.repository.PlayListRepository;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.internal.matchers.apachecommons.ReflectionEquals;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.DirtiesContext;
import org.springframework.test.web.servlet.MockMvc;

import java.util.ArrayList;
import java.util.List;

import static org.hamcrest.Matchers.greaterThan;
import static org.hamcrest.Matchers.isA;
import static org.junit.jupiter.api.Assertions.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;


@SpringBootTest
@DirtiesContext(classMode = DirtiesContext.ClassMode.BEFORE_EACH_TEST_METHOD)
@AutoConfigureMockMvc
public class ApplicationTests {
    @Autowired
    private PlayListRepository playListRepository;
    @Autowired
    private MockMvc mockMvc;
    private static final ObjectMapper om = new ObjectMapper();

    @BeforeEach
    public  void setup() {
        playListRepository.deleteAll();
    }

    private PlayListRequest createSamplePlayListRequest() {
        return new PlayListRequest(
                "Henry Kaldera",
                10
        );
    }

    @Test
    void testCreatePlayList() throws Exception {
        PlayListRequest sampleTrackRequest = createSamplePlayListRequest();
        PlayList actualRecord = om.readValue(mockMvc.perform(post("/v1/playlists")
                        .contentType("application/json")
                        .content(om.writeValueAsString(sampleTrackRequest)))
                .andDo(print())
                .andExpect(jsonPath("$.id", greaterThan(0)))
                .andExpect(status().isCreated()).andReturn().getResponse().getContentAsString(), PlayList.class);
        assertTrue(playListRepository.findById(actualRecord.getId()).isPresent());
    }

    @Test
    void testListOfTracks() throws Exception {
        PlayListRequest sampleTrackRequest = createSamplePlayListRequest();

        for (int i = 0; i < 5; i++) {
            om.readValue(mockMvc.perform(post("/v1/playlists")
                            .contentType("application/json")
                            .content(om.writeValueAsString(sampleTrackRequest)))
                    .andDo(print())
                    .andExpect(jsonPath("$.id", greaterThan(0)))
                    .andExpect(status().isCreated()).andReturn().getResponse().getContentAsString(), PlayList.class);
        }

        List<PlayList> actualResult = om.readValue(mockMvc.perform(get("/v1/playlists"))
                .andDo(print())
                .andExpect(jsonPath("$.*", isA(ArrayList.class)))
                .andExpect(status().isOk()).andReturn().getResponse().getContentAsString(), new TypeReference<List<PlayList>>() {
        });

        assertEquals(5, actualResult.size());
    }

    @Test
    void testListOfTracksEmpty() throws Exception {
        mockMvc.perform(get("/v1/playlists"))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$").isEmpty());
    }

    @Test
    void testPlayListDeleteById() throws Exception {
        PlayListRequest sampleTrackRequest = createSamplePlayListRequest();
        PlayList expectedRecord = om.readValue(mockMvc.perform(post("/v1/playlists")
                        .contentType("application/json")
                        .content(om.writeValueAsString(sampleTrackRequest)))
                .andDo(print())
                .andExpect(status().isCreated()).andReturn().getResponse().getContentAsString(), PlayList.class);

        mockMvc.perform(delete("/v1/playlists/" + expectedRecord.getId())
                        .contentType("application/json"))
                .andDo(print())
                .andExpect(status().isNoContent());

        assertFalse(playListRepository.findById(expectedRecord.getId()).isPresent());
    }

    @Test
    void testGetPlayListById() throws Exception {
        PlayListRequest sampleTrackRequest = createSamplePlayListRequest();
        PlayList actualRecord = om.readValue(mockMvc.perform(post("/v1/playlists")
                        .contentType("application/json")
                        .content(om.writeValueAsString(sampleTrackRequest)))
                .andDo(print())
                .andExpect(status().isCreated()).andReturn().getResponse().getContentAsString(), PlayList.class);

        PlayList expectedRecord = om.readValue(mockMvc.perform(get("/v1/playlists/" + actualRecord.getId())
                        .contentType("application/json"))
                .andDo(print())
                .andExpect(status().isOk()).andReturn().getResponse().getContentAsString(), PlayList.class);

        assertTrack(actualRecord, expectedRecord);
    }

    private void assertTrack(PlayList actualRecord, PlayList expectedRecord) {
        Assertions.assertTrue(new ReflectionEquals(actualRecord).matches(expectedRecord));
    }
}
