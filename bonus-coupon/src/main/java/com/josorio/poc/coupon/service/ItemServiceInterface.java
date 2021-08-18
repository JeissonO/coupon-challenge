package com.josorio.poc.coupon.service;

import java.util.List;
import java.util.Map;

public interface ItemServiceInterface {

	public Map<String, Float> getItemsPrices(List<String> itemIdList);
	public List<String> calculate(Map<String, Float> items, Float amount);
}
