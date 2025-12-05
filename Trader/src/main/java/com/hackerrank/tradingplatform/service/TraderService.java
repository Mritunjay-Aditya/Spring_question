package com.hackerrank.tradingplatform.service;

import com.hackerrank.tradingplatform.dto.AddMoneyTraderDTO;
import com.hackerrank.tradingplatform.dto.UpdateTraderDTO;
import com.hackerrank.tradingplatform.model.Trader;
import com.hackerrank.tradingplatform.repository.TraderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TraderService {
    @Autowired
    private TraderRepository traderRepository;

    public void registerTrader(Trader trader) {
        traderRepository.save(trader);
    }

    public Trader getTraderById(Long id) {
        return traderRepository.findById(id).get();
    }

    public Trader getTraderByEmail(String email) {
        return traderRepository.findByEmail(email).orElse(new Trader());
    }

    public List<Trader> getAllTraders() {
        return traderRepository.findAll();
    }

    public void updateTrader(UpdateTraderDTO trader) {
        Trader existingTrader = traderRepository.findByEmail(trader.getEmail()).get();
        traderRepository.save(existingTrader);
    }

    public void addMoney(AddMoneyTraderDTO trader) {
        Trader existingTrader = traderRepository.findByEmail(trader.getEmail()).get();

        existingTrader.setBalance(trader.getAmount());

        traderRepository.save(existingTrader);
    }
}
