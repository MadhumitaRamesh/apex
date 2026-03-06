package com.apex.services;

/**
 * PricingService calculates the final cost based on various factors.
 */
public class PricingService {

    private static final double TAX_RATE = 0.18; // 18% GST Example
    private static final double FLAT_SHIPPING = 500.0;

    /**
     * Calculates the "True Cost" of a product.
     */
    public double calculateTrueCost(double basePrice, boolean includeShipping, boolean includeTax) {
        double finalPrice = basePrice;
        
        if (includeTax) {
            finalPrice += (basePrice * TAX_RATE);
        }
        
        if (includeShipping) {
            finalPrice += FLAT_SHIPPING;
        }
        
        return finalPrice;
    }
}
