package com.hackerrank.api.repository;

import com.hackerrank.api.model.Location;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LocationRepository extends JpaRepository<Location, Integer> {
}
