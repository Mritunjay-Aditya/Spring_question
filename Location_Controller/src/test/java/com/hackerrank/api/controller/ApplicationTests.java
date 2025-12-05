package com.hackerrank.api.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hackerrank.api.model.Location;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Arrays;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ExtendWith(SpringExtension.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.DEFINED_PORT)
@AutoConfigureMockMvc
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class ApplicationTests {
  ObjectMapper om = new ObjectMapper();

  @Autowired
  private MockMvc mockMvc;

  @Test
  @Order(1)
  @DisplayName("status201WhenValidCreated")
  public void status201WhenValidCreated() throws Exception {
    Location expectedRecord = Location.builder()
            .lat(13.2f)
            .lon(23.0f)
            .temperatures(Arrays.asList(new Double[]{23.4,56.6}))
            .build();
    Location actualLocation = om.readValue(mockMvc.perform(post("/api/location")
                    .contentType("application/json")
                    .content(om.writeValueAsString(expectedRecord)))
            .andDo(print())
            .andExpect(status().isCreated()).andReturn().getResponse().getContentAsString(), Location.class);

    Assertions.assertEquals(expectedRecord.getLat(),actualLocation.getLat());
    Assertions.assertEquals(expectedRecord.getLon(),actualLocation.getLon());
    Assertions.assertArrayEquals(expectedRecord.getTemperatures().toArray(),actualLocation.getTemperatures().toArray());
  }

  @Test
  @Order(2)
  @DisplayName("status400WhenInValidCreated")
  public void status400WhenInValidRequest() throws Exception {
    Location expectedRecord = Location.builder()
            .id(1)
            .lat(13.2f)
            .lon(23.0f)
            .temperatures(Arrays.asList(new Double[]{23.4,56.6}))
            .build();
    mockMvc.perform(post("/api/location")
                    .contentType("application/json")
                    .content(om.writeValueAsString(expectedRecord)))
            .andDo(print())
            .andExpect(status().isBadRequest());
  }


  @Test
  @Order(3)
  @DisplayName("statusCode404WhenNonExistentRequested")
  void statusCode404WhenNonExistentRequested() throws Exception {
    mockMvc
            .perform(get("/api/location/-1"))
            .andDo(print())
            .andExpect(status().isNotFound());
  }

  @Test
  @Order(4)
  @DisplayName("statusCode200WhenExistentRequested")
  void statusCode200WhenExistentRequested() throws Exception {
    mockMvc
            .perform(get("/api/location/1"))
            .andDo(print())
            .andExpect(status().isOk());
  }
}
