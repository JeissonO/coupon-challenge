package com.josorio.poc.coupon.model;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

@Data
public class CouponUseRq {

	@JsonProperty("item_ids")
	public List<String> itemIds;
	@JsonProperty("amount")
	public Float amount;	
}
