package com.josorio.poc.coupon.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface ItemServiceInterface {

	public HashMap<String, Float> getItemsPrices(List<String> itemIdList);
	public List<String> calculate(Map<String, Float> items, Float amount);
}
