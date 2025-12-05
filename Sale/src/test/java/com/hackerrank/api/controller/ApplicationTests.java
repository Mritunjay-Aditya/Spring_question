package com.hackerrank.api.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hackerrank.api.model.Sale;
import org.hamcrest.core.Is;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

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
        @DisplayName("testCreatedWithValidData")
        public void testCreatedWithValidData() throws Exception {
                Sale expectedRecord = Sale.builder()
                                .productName("Test Country")
                                .customerEmail("test@email.com")
                                .buyingPrice(23)
                                .sellingPrice(25)
                                .build();
                mockMvc.perform(post("/sale")
                                .contentType("application/json")
                                .content(om.writeValueAsString(expectedRecord)))
                                .andDo(print())
                                .andExpect(status().isCreated());
        }

        @Test
        @DisplayName("statusCode400WhenInvalidSellingPriceProvided")
        public void statusCode400WhenInvalidSellingPriceProvided() throws Exception {
                Sale expectedRecord = Sale.builder()
                                .productName("Test Country")
                                .customerEmail("test@email.com")
                                .buyingPrice(40)
                                .sellingPrice(-40)
                                .build();
                mockMvc.perform(post("/sale")
                                .contentType("application/json")
                                .content(om.writeValueAsString(expectedRecord)))
                                .andDo(print())
                                .andExpect(status().isBadRequest())
                                .andExpect(MockMvcResultMatchers.jsonPath("$.sellingPrice",
                                                Is.is("Value should not be negative")));
        }

        @Test
        @DisplayName("statusCode400WhenInvalidEmailProvided")
        public void statusCode400WhenInvalidEmailProvided() throws Exception {
                Sale expectedRecord = Sale.builder()
                                .productName("Test Country")
                                .customerEmail("test.1#email")
                                .buyingPrice(40)
                                .sellingPrice(35)
                                .build();
                mockMvc.perform(post("/sale")
                                .contentType("application/json")
                                .content(om.writeValueAsString(expectedRecord)))
                                .andDo(print())
                                .andExpect(status().isBadRequest())
                                .andExpect(MockMvcResultMatchers.jsonPath("$.customerEmail",
                                                Is.is("Invalid customer email")));
        }

        @Test
        @DisplayName("statusCode400WhenInvalidDataProvided")
        public void statusCode400WhenInvalidDataProvided() throws Exception {
                Sale expectedRecord = Sale.builder()
                                .productName(null)
                                .customerEmail("test.email@email")
                                .buyingPrice(-40)
                                .sellingPrice(35)
                                .build();
                mockMvc.perform(post("/sale")
                                .contentType("application/json")
                                .content(om.writeValueAsString(expectedRecord)))
                                .andDo(print())
                                .andExpect(status().isBadRequest())
                                .andExpect(MockMvcResultMatchers.jsonPath("$.buyingPrice",
                                                Is.is("Value should not be negative")))
                                .andExpect(MockMvcResultMatchers.jsonPath("$.productName",
                                                Is.is("Product name is mandatory")));
        }
}
