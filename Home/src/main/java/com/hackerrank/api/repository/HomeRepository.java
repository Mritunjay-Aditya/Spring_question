package com.hackerrank.api.repository;

import com.hackerrank.api.model.Home;
import org.springframework.data.jpa.repository.JpaRepository;

public interface HomeRepository extends JpaRepository<Home, Integer> {
}
