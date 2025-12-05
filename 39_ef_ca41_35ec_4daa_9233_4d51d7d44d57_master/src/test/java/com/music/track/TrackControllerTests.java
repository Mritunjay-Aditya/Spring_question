package com.music.track;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.music.track.dto.TrackRequest;
import com.music.track.model.Track;
import com.music.track.repository.TrackRepository;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.internal.matchers.apachecommons.ReflectionEquals;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.DirtiesContext;
import org.springframework.test.web.servlet.MockMvc;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import static org.hamcrest.Matchers.*;
import static org.junit.jupiter.api.Assertions.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;


@SpringBootTest
@DirtiesContext(classMode = DirtiesContext.ClassMode.BEFORE_EACH_TEST_METHOD)
@AutoConfigureMockMvc
class TrackControllerTests {

    @Autowired
    private TrackRepository trackRepository;
    @Autowired
    private MockMvc mockMvc;
    private static final ObjectMapper om = new ObjectMapper();
    private static final SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
    private static Date testDate;

    @BeforeAll
    public static void initialSetup() throws ParseException {
        testDate = simpleDateFormat.parse("2019-03-12");
    }

    @BeforeEach
    public void setup() {
        trackRepository.deleteAll();
    }

    private TrackRequest createSampleTrackRequest() {
        return new TrackRequest(
                "Henry Kaldera",
                "ZZZ Album",
                testDate,
                100
        );
    }

    @Test
    void testCreateTrack() throws Exception {
        TrackRequest sampleTrackRequest = createSampleTrackRequest();
        Track actualRecord = om.readValue(mockMvc.perform(post("/music/platform/v1/tracks")
                        .contentType("application/json")
                        .content(om.writeValueAsString(sampleTrackRequest)))
                .andDo(print())
                .andExpect(jsonPath("$.id", greaterThan(0)))
                .andExpect(status().isCreated()).andReturn().getResponse().getContentAsString(), Track.class);
        assertTrue(trackRepository.findById(actualRecord.getId()).isPresent());
    }

    @Test
    void testListOfTracks() throws Exception {
        TrackRequest sampleTrackRequest = createSampleTrackRequest();

        for (int i = 0; i < 5; i++) {
            om.readValue(mockMvc.perform(post("/music/platform/v1/tracks")
                            .contentType("application/json")
                            .content(om.writeValueAsString(sampleTrackRequest)))
                    .andDo(print())
                    .andExpect(jsonPath("$.id", greaterThan(0)))
                    .andExpect(status().isCreated()).andReturn().getResponse().getContentAsString(), Track.class);
        }

        List<Track> actualResult = om.readValue(mockMvc.perform(get("/music/platform/v1/tracks"))
                .andDo(print())
                .andExpect(jsonPath("$.*", isA(ArrayList.class)))
                .andExpect(status().isOk()).andReturn().getResponse().getContentAsString(), new TypeReference<List<Track>>() {
        });

        assertEquals(5, actualResult.size());
    }
    @Test
    void testListOfTracksEmpty() throws Exception {
        mockMvc.perform(get("/music/platform/v1/tracks"))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$").isEmpty());
    }
    @Test
    void testTrackDeleteById() throws Exception {
        TrackRequest sampleTrackRequest = createSampleTrackRequest();
        Track expectedRecord = om.readValue(mockMvc.perform(post("/music/platform/v1/tracks")
                        .contentType("application/json")
                        .content(om.writeValueAsString(sampleTrackRequest)))
                .andDo(print())
                .andExpect(status().isCreated()).andReturn().getResponse().getContentAsString(), Track.class);

        mockMvc.perform(delete("/music/platform/v1/tracks/" + expectedRecord.getId())
                        .contentType("application/json"))
                .andDo(print())
                .andExpect(status().isNoContent());

        assertFalse(trackRepository.findById(expectedRecord.getId()).isPresent());
    }
    @Test
    void testSortTrackByTitle() throws Exception {
        List<TrackRequest> sampleTrackRequest = differentTrackRequests();
        for(TrackRequest track : sampleTrackRequest){
            om.readValue(mockMvc.perform(post("/music/platform/v1/tracks")
                            .contentType("application/json")
                            .content(om.writeValueAsString(track)))
                    .andDo(print())
                    .andExpect(status().isCreated()).andReturn().getResponse().getContentAsString(), Track.class);
        }

        List<Track> actualResult = om.readValue(mockMvc.perform(get("/music/platform/v1/tracks/sorted")

                )
                .andDo(print())
                .andExpect(jsonPath("$.*", isA(ArrayList.class)))
                .andExpect(status().isOk()).andReturn().getResponse().getContentAsString(), new TypeReference<List<Track>>() {
        });

        assertEquals("Anuradha", actualResult.get(0).getTitle());
        assertEquals(Integer.valueOf(150), actualResult.get(0).getPlayCount());
        assertEquals("AnuradhaX", actualResult.get(1).getTitle());
        assertEquals(Integer.valueOf(100), actualResult.get(1).getPlayCount());
    }

    private void assertTrack(Track expected, Track actual) {
        Assertions.assertTrue(new ReflectionEquals(expected).matches(actual));
    }

    public List<TrackRequest> differentTrackRequests() {
        List<TrackRequest> trackRequests = new ArrayList<>();
        trackRequests.add(new TrackRequest("Anuradha", "Album 1", testDate,  150));
        trackRequests.add(new TrackRequest("AnuradhaX", "Album 2", testDate,  100));
        trackRequests.add(new TrackRequest("Era", "Album 3", testDate,  200));
        trackRequests.add(new TrackRequest("Era bati 4", "Album 4", testDate,  200));
        trackRequests.add(new TrackRequest("Dasun Ti", "Album 5", testDate,  300));
        return trackRequests;
    }

}
