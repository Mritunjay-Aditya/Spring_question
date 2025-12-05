package com.hackerrank.api.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

@Getter
@Setter
@Builder
@Entity
public class Home implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private Float area;
    private Float price;
    private String city;

    public Home(Integer id, Float area, Float price, String city) {
        this.id = id;
        this.area = area;
        this.price = price;
        this.city = city;
    }

    public Home(Float area, Float price, String city) {
        this.area = area;
        this.price = price;
        this.city = city;
    }

    public Home() {
    }
}