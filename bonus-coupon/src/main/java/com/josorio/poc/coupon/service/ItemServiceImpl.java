package com.josorio.poc.coupon.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.stream.Collectors;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.josorio.poc.coupon.handler.NotFoundException;
import com.josorio.poc.coupon.handler.ServiceException;
import com.josorio.poc.coupon.utilities.CouponConfigurationProperties;
import com.josorio.poc.coupon.utilities.CouponConstants;

import lombok.extern.log4j.Log4j2;

@Log4j2
@Service
public class ItemServiceImpl implements ItemServiceInterface {

	@Autowired
	private RestClientService restClientService;
	@Autowired
	private CouponConfigurationProperties couponConfigurationProperties;
	@Autowired
	private ObjectMapper mapper;
	
	public ItemServiceImpl(RestClientService restClientService,CouponConfigurationProperties configurationProperties, ObjectMapper  mapper) {
		this.restClientService = restClientService;
		this.couponConfigurationProperties = configurationProperties;
		this.mapper = mapper;		
	}

	public Map<String, Float> getItemsPrices(List<String> itemIdList) {
		HashMap<String, Float> itemsPriceList = new HashMap<>();
		for (String item : itemIdList) {
			try {		
				Object response = getItemPrice(item);
				itemsPriceList.put(item, getPrice(response));
			} catch (Exception e) {
				log.error("Exception", e);
			}
		}
		return sorfHashMap(itemsPriceList);
	}

	
	@CacheEvict(value="price", key="#item")
	public Object getItemPrice(String item) throws ServiceException {
		return restClientService.invoke(null, HttpMethod.GET,
				couponConfigurationProperties.getItemApiEndpoint(), item,
				couponConfigurationProperties.getTimeOut());
	}

	public List<String> calculate(Map<String, Float> items, Float amount){
		List<String> buyItemsList = new ArrayList<>();
		Float total = 0F;
		if (items.size() < 1) {
			throw new NotFoundException(CouponConstants.NOT_FOUND);
		}else {
			for (Entry<String, Float> item : items.entrySet()) {
				if((total + item.getValue()) <= amount ) {
					total += item.getValue();
					buyItemsList.add(item.getKey());					
				}else if((total + item.getValue()) > amount) {
					break;
				}				
			}
		}
		return buyItemsList;
	}
	
	private HashMap<String, Float> sorfHashMap(HashMap<String, Float> itemsPriceList) {
		return itemsPriceList.entrySet().stream()
				.sorted((item1, item2) -> item1.getValue().compareTo(item2.getValue()))
				.collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue, (entry1, entry2) -> entry1, LinkedHashMap::new));		
	}

	private Float getPrice(Object response) throws JsonProcessingException{
		String jResponse = mapper.writeValueAsString(response);
		JSONObject json = new JSONObject(jResponse);
		Double price = json.getDouble("price");
		return price.floatValue();
	}
}
