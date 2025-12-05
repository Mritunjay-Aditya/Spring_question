package com.hackerrank.api.service;

import com.hackerrank.api.model.Sale;

import java.util.List;

public interface SaleService {

  List<Sale> getAllSale();

  Sale createNewSale(Sale sale);

  Sale getSaleById(Long id);
}
