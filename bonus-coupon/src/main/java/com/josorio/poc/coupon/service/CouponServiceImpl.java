package com.josorio.poc.coupon.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.josorio.poc.coupon.handler.NotFoundException;
import com.josorio.poc.coupon.model.CouponUseRq;
import com.josorio.poc.coupon.model.CouponUseRs;
import com.josorio.poc.coupon.utilities.CouponConstants;

import lombok.extern.log4j.Log4j2;

@Log4j2
@Service
public class CouponServiceImpl implements CouponServiceInterface {
	

	@Autowired
	private ItemServiceInterface itemService;
	
	public CouponServiceImpl(ItemServiceImpl itemService) {
		this.itemService = itemService;	
	}

	public ResponseEntity<Object> buy(CouponUseRq request){
		CouponUseRs response = new CouponUseRs();
		HashMap<String, Float> itemsPriceList = new HashMap<>();
		try {			
			if(!request.getItemIds().isEmpty() && request.getAmount()> 0) {
				itemsPriceList = (HashMap<String, Float>) itemService.getItemsPrices(request.getItemIds());
				List<String> itemsToBuy = itemService.calculate(itemsPriceList, request.getAmount());
				if(!itemsToBuy.isEmpty()) {					
					response.setItemIds(itemsToBuy);
					response.setTotal(getTotalBill(itemsPriceList, itemsToBuy));
				}else {
					log.info(CouponConstants.ITEMS_NOT_FOUND);
					throw new NotFoundException(CouponConstants.ITEMS_NOT_FOUND);					
				}
			}else{
				log.info(CouponConstants.BAD_REQUEST);
				throw new NotFoundException(CouponConstants.BAD_REQUEST);	
			}			
		} catch (NotFoundException e) {
			log.error(CouponConstants.NOT_FOUND, e);
			throw e;
		} catch (Exception e) {
			log.error(CouponConstants.SERVER_ERROR, e);
			throw e;			
		}
		return new ResponseEntity<>(response, HttpStatus.OK);
	}

	
	private Float getTotalBill(HashMap<String, Float> itemsPriceList, List<String> itemsToBuy) {
		Float totalBill = 0F;		
		for (String item : itemsToBuy) {
			totalBill += itemsPriceList.get(item);
		}
		return totalBill;
	}	
}
