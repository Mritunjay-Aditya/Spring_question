package com.hackerrank.api.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hackerrank.api.model.Patient;
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
  @DisplayName("testCreation")
  public void testCreation() throws Exception {
    Patient expectedRecord = Patient.builder().country("Test Country").build();
    mockMvc.perform(post("/patient")
            .contentType("application/json")
            .content(om.writeValueAsString(expectedRecord)))
            .andDo(print())
            .andExpect(status().isCreated());
  }

  @Test
  @DisplayName("statusCode400WhenIdProvided")
  public void testCreationWithId() throws Exception {
    Patient expectedRecord = Patient.builder().id(1000000l).country("Test Country").build();
    mockMvc.perform(post("/patient")
                    .contentType("application/json")
                    .content(om.writeValueAsString(expectedRecord)))
            .andDo(print())
            .andExpect(status().isBadRequest());
  }

  @Test
  @DisplayName("statusCode404WhenNonExistentRequested")
  void statusCode404WhenNonExistentRequested() throws Exception {
    mockMvc
            .perform(get("/patient/-1"))
            .andDo(print())
            .andExpect(status().isNotFound());
  }

  @Test
  @DisplayName("statusCode404WhenNonExistentRequested")
  void statusCode200whenExistentRequested() throws Exception {
    mockMvc
            .perform(get("/patient/1"))
            .andDo(print())
            .andExpect(status().isOk());
  }

  @Test
  @DisplayName("statusCode400WhenInvalidIdRequested")
  void statusCode400WhenInvalidIdRequested() throws Exception {
    mockMvc
            .perform(get("/patient/invalid"))
            .andDo(print())
            .andExpect(status().isBadRequest());
  }
}
