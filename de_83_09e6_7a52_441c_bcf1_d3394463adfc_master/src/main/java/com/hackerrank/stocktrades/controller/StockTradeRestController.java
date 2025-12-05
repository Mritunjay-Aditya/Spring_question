package com.hackerrank.stocktrades.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.hackerrank.stocktrades.model.StockTrade;
import com.hackerrank.stocktrades.repository.StockTradeRepository;

@RestController
@RequestMapping("/trades")
public class StockTradeRestController {
	@Autowired
	private StockTradeRepository stockTradeRepository;
	
	@PostMapping
	public ResponseEntity<StockTrade> create(@RequestBody StockTrade stockTrade){
		return new ResponseEntity<StockTrade>(stockTradeRepository.save(stockTrade),HttpStatus.CREATED);
	}
	
	@GetMapping
	public ResponseEntity<List<StockTrade>> getAll(){
		List<StockTrade> list=stockTradeRepository.findAll();
		return ResponseEntity.ok(list);
	}
	
	@GetMapping("/{id}")
	public ResponseEntity<StockTrade> getById(@PathVariable Integer id){
		return stockTradeRepository.findById(id)
				.map(ResponseEntity::ok)
				.orElse(ResponseEntity.notFound().build());
	}
}
