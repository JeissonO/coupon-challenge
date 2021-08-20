package com.josorio.poc.coupon.ctrl;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import com.josorio.poc.coupon.model.CouponUseRq;
import com.josorio.poc.coupon.utilities.CouponConstants;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

@Api("Coupon")
public interface CouponApi {
	
	@ApiOperation(value = "Health check of Coupon API", nickname = "health")
	@ApiResponses(value = { @ApiResponse(code = 500, message = CouponConstants.SERVER_ERROR),			
			@ApiResponse(code = 200, message = CouponConstants.TRN_SUCCESS) })
	@GetMapping("/health")
	ResponseEntity<Object> healthCheck();
	
	@ApiOperation(value = "Buy Items", nickname = "coupon")
	@ApiResponses(value = { @ApiResponse(code = 500, message = CouponConstants.SERVER_ERROR),
			@ApiResponse(code = 404, message = CouponConstants.NOT_FOUND),
			@ApiResponse(code = 200, message = CouponConstants.TRN_SUCCESS) })
	@PostMapping("/")
	ResponseEntity<Object> coupon(@RequestBody CouponUseRq coupon);
}
