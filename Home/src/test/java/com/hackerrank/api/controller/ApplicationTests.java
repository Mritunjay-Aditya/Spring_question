package com.hackerrank.api.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hackerrank.api.model.Home;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpHeaders;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Base64;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ExtendWith(SpringExtension.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.DEFINED_PORT)
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
@AutoConfigureMockMvc
class ApplicationTests {
	static HttpHeaders authHeaders = new HttpHeaders();
	ObjectMapper om = new ObjectMapper();
	@Autowired
	private MockMvc mockMvc;

	@BeforeAll
	public static void init() {
		String token = new String(Base64.getEncoder().encode(("admin" + ":" + "admin").getBytes()));
		authHeaders.set("Authorization", "Basic " + token);
	}

	@Test
	@Order(1)
	@DisplayName("status201WhenValidRequest")
	public void status201WhenValidRequest() throws Exception {
		Home expectedRecord = Home.builder()
				.area(13.2f)
				.price(23.0f)
				.city("Delhi")
				.build();
		Home actualHome = om.readValue(mockMvc.perform(post("/api/home")
				.contentType("application/json")
				.headers(authHeaders)
				.content(om.writeValueAsString(expectedRecord)))
				.andDo(print())
				.andExpect(status().isCreated()).andReturn().getResponse().getContentAsString(), Home.class);

		Assertions.assertEquals(expectedRecord.getArea(), actualHome.getArea());
		Assertions.assertEquals(expectedRecord.getPrice(), actualHome.getPrice());
		Assertions.assertEquals(expectedRecord.getCity(), actualHome.getCity());
	}

	@Test
	@Order(2)
	@DisplayName("statusCode404WhenInvalidRequested")
	void statusCode404WhenInvalidRequested() throws Exception {
		mockMvc
				.perform(get("/api/home/-1").headers(authHeaders))
				.andDo(print())
				.andExpect(status().isNotFound());
	}

	@Test
	@Order(3)
	@DisplayName("statusCode404WhenNonExistentHomeRequested")
	void statusCode404WhenNonExistentHomeRequested() throws Exception {
		mockMvc
				.perform(get("/api/home/1").headers(authHeaders))
				.andDo(print())
				.andExpect(status().isOk());
	}

	@Test
	@Order(4)
	@DisplayName("statusCode400WhenInvalidIdRequested")
	void statusCode400WhenInvalidIdRequested() throws Exception {
		mockMvc
				.perform(get("/api/home/invalid").headers(authHeaders))
				.andDo(print())
				.andExpect(status().isBadRequest());
	}
}
