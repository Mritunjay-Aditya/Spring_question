package com.hackerrank.tradingplatform.controller;

import com.hackerrank.tradingplatform.dto.AddMoneyTraderDTO;
import com.hackerrank.tradingplatform.dto.TraderDTO;
import com.hackerrank.tradingplatform.dto.UpdateTraderDTO;
import com.hackerrank.tradingplatform.model.Trader;
import com.hackerrank.tradingplatform.service.TraderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

import static java.util.stream.Collectors.toList;

@RestController
@RequestMapping(value = "/trading/traders")
public class TraderController {
    @Autowired
    private TraderService traderService;

    //register
    @RequestMapping(value = "/register", method = RequestMethod.POST, consumes = "application/json")
    @ResponseStatus(HttpStatus.CREATED)
    public void registerTrader(@RequestBody @Valid Trader trader) {
        traderService.registerTrader(trader);
    }

    //get by email
    @RequestMapping(method = RequestMethod.GET)
    @ResponseStatus(HttpStatus.OK)
    public TraderDTO getTraderByEmail(@RequestParam("email") String email) {
        return new TraderDTO(traderService.getTraderByEmail(email));
    }

    //get all
    @RequestMapping(value = "/all", method = RequestMethod.GET)
    @ResponseStatus(HttpStatus.OK)
    public List<TraderDTO> getAllTraders() {
        return traderService.getAllTraders()
                .stream()
                .map(TraderDTO::new)
                .collect(toList());
    }

    //update by email
    @RequestMapping(method = RequestMethod.PUT)
    @ResponseStatus(HttpStatus.OK)
    public void updateTrader(@RequestBody @Valid UpdateTraderDTO trader) {
        traderService.updateTrader(trader);
    }

    //add money
    @RequestMapping(value = "/add", method = RequestMethod.PUT)
    @ResponseStatus(HttpStatus.OK)
    public void addMoney(@RequestBody @Valid AddMoneyTraderDTO trader) {
        traderService.addMoney(trader);
    }
}
