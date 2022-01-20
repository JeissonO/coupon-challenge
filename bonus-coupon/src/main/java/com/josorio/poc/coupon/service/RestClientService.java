package com.josorio.poc.coupon.service;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.ClientHttpRequestFactory;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import com.josorio.poc.coupon.handler.ServiceException;

import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
public class RestClientService {

	@Autowired
	private RestTemplate restTemplate;
	@Autowired
	HttpServletRequest request;

	public RestClientService(RestTemplate restTemplate, HttpServletRequest rq) {
		this.restTemplate = restTemplate;
		this.request = rq;
	}

	public Object invoke(Object bodyRq, HttpMethod httpMethod, String endpoint, String path, Integer timeOut)
			throws ServiceException {
		try {
			HttpHeaders httpHeaders = new HttpHeaders();
			httpHeaders.setContentType(MediaType.APPLICATION_JSON);
			HttpEntity<Object> httpEntity = null;

			if (bodyRq != null) {
				httpEntity = new HttpEntity<>(bodyRq, httpHeaders);
			} else {
				httpEntity = new HttpEntity<>(httpHeaders);
			}
			restTemplate.setRequestFactory(clientHttpRequestFactory(timeOut));
			ResponseEntity<Object> response = restTemplate.exchange(endpoint + path, httpMethod, httpEntity,
					Object.class);

			if (null != response.getBody()) {
				return response.getBody();
			}

		} catch (HttpClientErrorException e) {
			log.error("HttpClientErrorException", e);
			throw new ServiceException(e.getResponseBodyAsString());
		} catch (Exception e) {
			log.error("Exception", e);
			throw new ServiceException("Invoke service error to: " + endpoint + path , e);
		}
		return null;
	}

	public ClientHttpRequestFactory clientHttpRequestFactory(Integer timeOut) {
		HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
		factory.setReadTimeout(timeOut);
		factory.setConnectTimeout(timeOut);
		return factory;
	}

}
