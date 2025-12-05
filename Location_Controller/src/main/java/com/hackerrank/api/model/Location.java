package com.hackerrank.api.model;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Builder
@Entity
public class Location implements Serializable {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Integer id;
  private Float lat;
  private Float lon;

  @ElementCollection(fetch = FetchType.LAZY)
  @CollectionTable(name = "location_temperature")
  private List<Double> temperatures;

  public Location(Integer id, Float lat, Float lon, List<Double> temperatures) {
    this.id = id;
    this.lat = lat;
    this.lon = lon;
    this.temperatures = temperatures;
  }

  public Location(Float lat, Float lon, List<Double> temperatures) {
    this.lat = lat;
    this.lon = lon;
    this.temperatures = temperatures;
  }

  public Location() {
  }
}