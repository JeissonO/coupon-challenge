package com.josorio.poc.coupon;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.junit.Assert;
import org.junit.jupiter.api.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.MockitoJUnitRunner;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.ResponseEntity;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.josorio.poc.coupon.handler.NotFoundException;
import com.josorio.poc.coupon.model.CouponUseRq;
import com.josorio.poc.coupon.model.CouponUseRs;
import com.josorio.poc.coupon.service.CouponServiceImpl;
import com.josorio.poc.coupon.service.ItemServiceImpl;

@RunWith(MockitoJUnitRunner.class)
@SpringBootTest
@AutoConfigureMockMvc
class BonusCouponServiceTests {
	
	@Mock
	private ItemServiceImpl mockService;
	@InjectMocks
	private CouponServiceImpl couponService;
	
	@Test
	void test_coupon_postCoupon_ok() throws Exception {
		CouponUseRq request = createTestResquest();				
		HashMap<String, Float> prices = createPrices();
		when(mockService.getItemsPrices(Mockito.any())).thenReturn(prices);
		List<String> listToBuy = createListToBuy();
		when(mockService.calculate(Mockito.anyMap(), Mockito.anyFloat())).thenReturn(listToBuy);		
		ObjectMapper mapper = new ObjectMapper();
		ResponseEntity<Object> response = couponService.buy(request);
		CouponUseRs rs = mapper.convertValue(response.getBody(), CouponUseRs.class);
		Assert.assertArrayEquals(new Float[] {450F}, new Float[] {rs.getTotal()});
	}
	
	@Test
	void test_coupon_postCoupon_not_found_1() throws Exception {
		CouponUseRq request = createTestResquest();				
		HashMap<String, Float> prices = new HashMap<>();
		when(mockService.getItemsPrices(Mockito.any())).thenReturn(prices);				
		assertThrows(NotFoundException.class,() -> { couponService.buy(request);}); 
	}
	
	@Test
	void test_coupon_postCoupon_not_found_2() throws Exception {
		CouponUseRq request = createTestResquest();				
		request.setAmount(0F);
		HashMap<String, Float> prices = createPrices();
		when(mockService.getItemsPrices(Mockito.any())).thenReturn(prices);			
		assertThrows(NotFoundException.class,() -> { couponService.buy(request);}); 
	}
	
	@Test
	void test_coupon_postCoupon_not_found_3() throws Exception {
		CouponUseRq request = createTestResquest();				
		request.setItemIds(null);					
		assertThrows(Exception.class,() -> { couponService.buy(request);}); 
	}
	
	@Test
	void test_coupon_postCoupon_not_found_4() throws Exception {
		CouponUseRq request = createTestResquest();				
		HashMap<String, Float> prices = createPrices();
		when(mockService.getItemsPrices(Mockito.any())).thenReturn(prices);
		List<String> listToBuy = new ArrayList<>();
		when(mockService.calculate(Mockito.anyMap(), Mockito.anyFloat())).thenReturn(listToBuy);		
		assertThrows(NotFoundException.class,() -> { couponService.buy(request);}); 
	}	
	
	@Test
	void test_coupon_postCoupon_server_exception() throws Exception {
		CouponUseRq request = createTestResquest();	
		request.setAmount(null);
		HashMap<String, Float> prices = createPrices();		
		when(mockService.getItemsPrices(Mockito.any())).thenReturn(prices);			
		assertThrows(Exception.class,() -> { couponService.buy(request);}); 
	}
	
	private List<String> createListToBuy() {
		List<String> toBuy = new ArrayList<>();
		toBuy.add("Item-1");
		toBuy.add("Item-2");
		return toBuy;
	}

	private HashMap<String, Float> createPrices() {
		HashMap<String, Float> prices = new HashMap<>();
		prices.put("Item-1", 100F);
		prices.put("Item-2", 350F);
		prices.put("Item-3", 400F);
		return prices;
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
	
	public static String asJsonString(final Object obj) {
		try {
			return new ObjectMapper().writeValueAsString(obj);
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
}
