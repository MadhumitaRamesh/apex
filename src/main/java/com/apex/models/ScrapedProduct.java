package com.apex.models;

public class ScrapedProduct {
    private String name;
    private double price;
    private double mrp;
    private double shipping;
    private String store;
    private String url;

    public ScrapedProduct(String name, double price, String store, String url) {
        this(name, price, price, 0.0, store, url);
    }

    public ScrapedProduct(String name, double price, double mrp, double shipping, String store, String url) {
        this.name = name;
        this.price = price;
        this.mrp = mrp > 0 ? mrp : price;
        this.shipping = shipping;
        this.store = store;
        this.url = url;
    }

    // Getters
    public String getName() { return name; }
    public double getPrice() { return price; }
    public double getMrp() { return mrp; }
    public double getShipping() { return shipping; }
    public String getStore() { return store; }
    public String getUrl() { return url; }

    // Logic for Tax & Shipping
    public double getGstAmount() { return price * 0.18; }
    public double getTotalWithTaxAndShipping() { return price + getGstAmount() + shipping; }
    public int getSavingsPercentage() {
        if (mrp <= price) return 0;
        return (int) (((mrp - price) / mrp) * 100);
    }

    // Setter for price adjustments
    public void setPrice(double price) { this.price = price; }
}
