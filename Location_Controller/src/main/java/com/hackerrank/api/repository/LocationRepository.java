package com.hackerrank.api.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.hackerrank.api.model.Location;

@Repository
public interface LocationRepository extends JpaRepository<Location, Integer> {
}
