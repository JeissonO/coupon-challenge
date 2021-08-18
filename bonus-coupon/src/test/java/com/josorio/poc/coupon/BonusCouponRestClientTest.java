package com.josorio.poc.coupon;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.when;

import javax.servlet.http.HttpServletRequest;

import org.junit.Assert;
import org.junit.jupiter.api.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnitRunner;
import org.springframework.boot.configurationprocessor.json.JSONObject;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import com.josorio.poc.coupon.handler.ServiceException;
import com.josorio.poc.coupon.service.RestClientService;

@RunWith(MockitoJUnitRunner.class)
@SpringBootTest
@AutoConfigureMockMvc
class BonusCouponRestClientTest {
	
	@Mock
	private RestTemplate restTemplate;
	@Mock
	private HttpServletRequest request;
	@InjectMocks
	private RestClientService restClientService;
	
	@Test
	void test_invokeApi_empty() throws Exception {
		ResponseEntity<Object> apiRs = new ResponseEntity<>(HttpStatus.OK);
		HttpHeaders httpHeaders = new HttpHeaders();
		httpHeaders.setContentType(MediaType.APPLICATION_JSON);
		HttpEntity<Object> httpEntity = new HttpEntity<>(httpHeaders);
		when(restTemplate.exchange("https://www.junit.com/item-1", HttpMethod.GET , httpEntity , Object.class)).thenReturn(apiRs );		
		Object response = restClientService.invoke(null, HttpMethod.GET, "https://www.junit.com/", "item-1", 5000);		
		Assert.assertNull(response);
	}
	
	@Test
	void test_invokeApi_200() throws Exception {
		String jsonRs = "{ \"id\": \"Item-1\", \"price\": 100  }" ;
		ResponseEntity<Object> apiRs = new ResponseEntity<>( jsonRs, HttpStatus.OK);
		HttpHeaders httpHeaders = new HttpHeaders();
		httpHeaders.setContentType(MediaType.APPLICATION_JSON);
		HttpEntity<Object> httpEntity = new HttpEntity<>(httpHeaders);
		when(restTemplate.exchange("https://www.junit.com/item-1", HttpMethod.GET , httpEntity , Object.class)).thenReturn(apiRs );		
		Object response = restClientService.invoke(null, HttpMethod.GET, "https://www.junit.com/", "item-1", 5000);	
		JSONObject json = new JSONObject(response.toString());
		Double price = json.getDouble("price");
		Assert.assertArrayEquals( new Float[] {100F}, new Float[] { price.floatValue()});		
	}	
	
	@Test
	void test_invokeApi_serviceException() throws Exception {
		HttpHeaders httpHeaders = new HttpHeaders();
		httpHeaders.setContentType(MediaType.APPLICATION_JSON);
		HttpEntity<Object> httpEntity = new HttpEntity<>(httpHeaders);		
		when(restTemplate.exchange("https://www.junit.com/item-1", HttpMethod.GET , httpEntity , Object.class))
			.thenThrow(new HttpClientErrorException(HttpStatus.BAD_REQUEST));
		
		assertThrows(ServiceException.class,() -> { restClientService.invoke(null, HttpMethod.GET, "https://www.junit.com/", "item-1", 5000);});		
	}
	
	@Test
	void test_invokeApi_serviceException_2() throws Exception {
		HttpHeaders httpHeaders = new HttpHeaders();
		httpHeaders.setContentType(MediaType.APPLICATION_JSON);
		HttpEntity<Object> httpEntity = new HttpEntity<>(httpHeaders);		
		when(restTemplate.exchange("https://www.junit.com/item-1", HttpMethod.GET , httpEntity , Object.class))
			.thenThrow(new RuntimeException());
		
		assertThrows(ServiceException.class,() -> { restClientService.invoke(null, HttpMethod.GET, "https://www.junit.com/", "item-1", 5000);});		
	}

}
