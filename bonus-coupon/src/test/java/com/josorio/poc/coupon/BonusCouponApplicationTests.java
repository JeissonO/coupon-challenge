package com.josorio.poc.coupon;


import java.util.ArrayList;
import java.util.List;

import org.junit.Assert;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.MockitoJUnitRunner;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import com.josorio.poc.coupon.ctrl.CouponApiController;
import com.josorio.poc.coupon.model.CouponUseRq;
import com.josorio.poc.coupon.service.CouponServiceImpl;

@RunWith(MockitoJUnitRunner.class)
@SpringBootTest
@AutoConfigureMockMvc
class BonusCouponApplicationTests {

	@Autowired
	private MockMvc mockMvc;
	@Mock
	private CouponServiceImpl mockService;
	@InjectMocks
	private CouponApiController apiController;

	@BeforeEach
    public void setUp() {
        System.setProperty("API_ENDPOINT", "https://localhost.com");
        mockMvc = MockMvcBuilders.standaloneSetup(apiController).build();
    }

	@Test
	void test_coupon_healthCheck() throws Exception {
		mockMvc.perform(MockMvcRequestBuilders.get("/v1/coupon/health"))
			.andExpect(MockMvcResultMatchers.status().is2xxSuccessful());
	}

	@Test
	void test_coupon_postCoupon() throws Exception {
		CouponUseRq request = createTestResquest();
		ResponseEntity<Object> responseEntity = new ResponseEntity<>(HttpStatus.OK);
		Mockito.when(mockService.buy(Mockito.any())).thenReturn(responseEntity);
		ResponseEntity<Object> response = apiController.coupon(request);
		Assert.assertSame(response.getStatusCode(), responseEntity.getStatusCode());
	}

	private CouponUseRq createTestResquest() {
		CouponUseRq request = new CouponUseRq();
		List<String> intemsList = new ArrayList<>();
		intemsList.add("Item-1");
		intemsList.add("Item-2");
		intemsList.add("Item-3");
		request.setItemIds(intemsList );
		request.setAmount(500F);
		return request;
	}

}
