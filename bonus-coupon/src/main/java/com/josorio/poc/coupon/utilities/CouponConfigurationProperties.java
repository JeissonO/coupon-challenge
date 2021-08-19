package com.josorio.poc.coupon.utilities;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import lombok.Data;

@Data
@Component
@ConfigurationProperties("coupon")
public class CouponConfigurationProperties {

	private String itemApiEndpoint;
	private Integer timeOut;	
}