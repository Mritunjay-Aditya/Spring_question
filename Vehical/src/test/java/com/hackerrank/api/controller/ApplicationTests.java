package com.hackerrank.api.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hackerrank.api.model.Vehicle;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ExtendWith(SpringExtension.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.DEFINED_PORT)
@AutoConfigureMockMvc
@Sql(executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD, scripts = "classpath:data.sql")
class ApplicationTests {
  ObjectMapper om = new ObjectMapper();

  @Autowired
  private MockMvc mockMvc;

  @Test
  @DisplayName("status201WhenValidRequest")
  public void status201WhenValidRequest() throws Exception {
    Vehicle expectedRecord = Vehicle.builder()
            .brand("KIA")
            .type("SUV")
            .cc(1400)
            .color("gray")
            .build();
    mockMvc.perform(post("/api/vehicle")
                    .contentType("application/json")
                    .content(om.writeValueAsString(expectedRecord)))
            .andDo(print())
            .andExpect(status().isCreated());
  }

  @Test
  @DisplayName("status400WhenInValidRequest")
  public void status400WhenInValidRequest() throws Exception {
    Vehicle expectedRecord = Vehicle.builder()
            .id(10000000l)
            .brand("KIA")
            .type("SUV")
            .cc(1400)
            .color("gray")
            .build();
    mockMvc.perform(post("/api/vehicle")
                    .contentType("application/json")
                    .content(om.writeValueAsString(expectedRecord)))
            .andDo(print())
            .andExpect(status().isBadRequest());
  }

  @Test
  @DisplayName("statusCode404WhenInvalidVehicleIdRequested")
  void statusCode404WhenInvalidVehicleIdRequested() throws Exception {
    mockMvc
            .perform(get("/api/vehicle/-1"))
            .andDo(print())
            .andExpect(status().isNotFound());
  }

  @Test
  @DisplayName("statusCode404WhenNonExistentRequested")
  void statusCode404WhenNonExistentRequested() throws Exception {
    mockMvc
            .perform(get("/api/vehicle/1"))
            .andDo(print())
            .andExpect(status().isOk());
  }
}
