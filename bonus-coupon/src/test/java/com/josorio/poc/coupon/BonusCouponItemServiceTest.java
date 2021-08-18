package com.josorio.poc.coupon;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.Assert;
import org.junit.jupiter.api.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.MockitoJUnitRunner;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.josorio.poc.coupon.handler.NotFoundException;
import com.josorio.poc.coupon.model.CouponUseRq;
import com.josorio.poc.coupon.service.ItemServiceImpl;
import com.josorio.poc.coupon.service.RestClientService;
import com.josorio.poc.coupon.utilities.CouponConfigurationProperties;

@RunWith(MockitoJUnitRunner.class)
@SpringBootTest
@AutoConfigureMockMvc
class BonusCouponItemServiceTest {
	
	@Mock
	private RestClientService restClientService;
	@Mock
	private CouponConfigurationProperties couponConfigurationProperties;
	@Mock
	private ObjectMapper mapper;
	@InjectMocks
	private ItemServiceImpl itemServiceImpl;
	
	@Test
	void test_items_getItemsPrices() throws Exception {
		List<String> itemIdList = createListToBuy();
		Object apiResponse = createApiResponse();
		when(restClientService.invoke( Mockito.any(), Mockito.any(), Mockito.any(), Mockito.any() , Mockito.any())).thenReturn(apiResponse);	
		when(mapper.writeValueAsString(Mockito.any())).thenReturn(apiResponse.toString());
		HashMap<String, Float> responseMap = itemServiceImpl.getItemsPrices(itemIdList);
		Assert.assertTrue("List", !responseMap.isEmpty());		
	}
	
	@Test
	void test_items_getItemsPrices_error() throws Exception {
		List<String> itemIdList = createListToBuy();
		Object apiResponse = createApiResponse();
		when(restClientService.invoke( Mockito.any(), Mockito.any(), Mockito.any(), Mockito.any() , Mockito.any())).thenReturn(apiResponse);	
		HashMap<String, Float> responseMap = itemServiceImpl.getItemsPrices(itemIdList);
		Assert.assertTrue("EmptyList", responseMap.isEmpty());		
	}
	
	@Test
	void test_items_calculate() throws Exception {
		Map<String, Float> items = createPrices();
		Float amount = 500F;
		List<String> itemsToBuyList = itemServiceImpl.calculate(items, amount);
		Assert.assertTrue("Only can buy 2 items", itemsToBuyList.size()== 2);				
	}
	
	@Test
	void test_items_calculate_error() throws Exception {
		Map<String, Float> items = new HashMap<>();
		Float amount = 500F; 
		assertThrows(NotFoundException.class,() -> { itemServiceImpl.calculate(items, amount);});
	}

	
	private Object createApiResponse() {
		return "{ \"id\": \"Item-1\", \"price\": 100  }";
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
