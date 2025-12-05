package com.hackerrank.api.controller;

import com.hackerrank.api.model.Sale;
import com.hackerrank.api.service.SaleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.context.request.WebRequest;

import jakarta.validation.Valid;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/sale")
public class SaleController {
    private final SaleService saleService;

    @Autowired
    public SaleController(SaleService saleService) {
        this.saleService = saleService;
    }

    @GetMapping
    @ResponseStatus(HttpStatus.OK)
    public List<Sale> getAllSale() {
        return saleService.getAllSale();
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Sale createSale(@Valid @RequestBody Sale sale) {
        return saleService.createNewSale(sale);
    }

    @GetMapping("/{id}")
    @ResponseStatus(HttpStatus.OK)
    public Sale getSaleById(@PathVariable Long id) {
        return saleService.getSaleById(id);
    }

    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(MethodArgumentNotValidException.class)
    protected Map<String, String> handleBugs(MethodArgumentNotValidException ex, WebRequest request) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach((error) -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });
        return errors;
    }
}
