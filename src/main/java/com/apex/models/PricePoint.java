package com.apex.models;

import java.time.LocalDate;

public class PricePoint {
    private LocalDate date;
    private double price;

    public PricePoint(LocalDate date, double price) {
        this.date = date;
        this.price = price;
    }

    public LocalDate getDate() {
        return date;
    }

    public double getPrice() {
        return price;
    }
}
