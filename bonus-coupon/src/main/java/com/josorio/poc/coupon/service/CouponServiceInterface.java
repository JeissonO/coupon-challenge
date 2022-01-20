package com.josorio.poc.coupon.service;

import org.springframework.http.ResponseEntity;

import com.josorio.poc.coupon.model.CouponUseRq;

public interface CouponServiceInterface {

	public ResponseEntity<Object> buy(CouponUseRq coupon);
}
