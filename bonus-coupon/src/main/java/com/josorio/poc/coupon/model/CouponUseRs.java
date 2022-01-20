package com.josorio.poc.coupon.model;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

@Data
public class CouponUseRs {

	@JsonProperty("item_ids")
	public List<String> itemIds;
	@JsonProperty("total")
	public Float total;
}
