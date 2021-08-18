package com.josorio.poc.coupon.ctrl;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.josorio.poc.coupon.model.CouponUseRq;
import com.josorio.poc.coupon.service.CouponServiceImpl;
import com.josorio.poc.coupon.service.CouponServiceInterface;

@RestController
@RequestMapping("/v1/coupon")
public class CouponApiController implements CouponApi {

	@Autowired
	private CouponServiceInterface couponService;

	public CouponApiController(CouponServiceImpl couponService) {
		this.couponService = couponService;
	}

	public ResponseEntity<Object> healthCheck() {
		String message = String.format("Service up! %s", LocalDateTime.now());
		return new ResponseEntity<>(message, HttpStatus.OK);
	}

	@Override
	public ResponseEntity<Object> coupon(CouponUseRq coupon) {
		return couponService.buy(coupon);
	}

}
