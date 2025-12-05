package com.hackerrank.api.service.impl;

import com.hackerrank.api.exception.BadRequestException;
import com.hackerrank.api.exception.ElementNotFoundException;
import com.hackerrank.api.model.Sale;
import com.hackerrank.api.repository.SaleRepository;
import com.hackerrank.api.service.SaleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DefaultSaleService implements SaleService {
  private final SaleRepository saleRepository;

  @Autowired
  DefaultSaleService(SaleRepository saleRepository) {
    this.saleRepository = saleRepository;
  }

  @Override
  public List<Sale> getAllSale() {
    return saleRepository.findAll();
  }

  @Override
  public Sale createNewSale(Sale sale) {
    if (sale.getId() != null) {
      throw new BadRequestException("The ID must not be provided when creating a new Sale");
    }

    return saleRepository.save(sale);
  }

  @Override
  public Sale getSaleById(Long id) {
    return saleRepository
        .findById(id)
        .orElseThrow(() -> new ElementNotFoundException("Sale with ID not found"));
  }
}
